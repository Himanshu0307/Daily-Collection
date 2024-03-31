import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../Models/ListItem.dart';
import '../Models/PostResponse.dart';
import '../Models/SQL Entities/QuickLoanModel.dart';

class SQLService {
  static final SQLService _sqlService = SQLService.initCon();
  factory SQLService() => _sqlService;
  SQLService.initCon();

  static Database? database;

  static void initializeDb() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", "myDb.db");
    database = await databaseFactory.openDatabase(dbPath);
    await database?.execute('''
  CREATE TABLE IF NOT EXISTS Customer (
      id INTEGER PRIMARY KEY,
      name TEXT ,
      address TEXT,
      mobile TEXT,
      aadhar TEXT,
      father TEXT,
      active BOOLEAN DEFAULT 1  CHECK (active IN (0, 1))
     
  )
  ''');
    await database?.execute('''
  CREATE TABLE IF NOT EXISTS Loan (
      id INTEGER PRIMARY KEY,
      cid INTEGER ,
      amount INTEGER,
      agreedAmount INTEGER,
      installement INTEGER,
      days INTEGER,
      startDate Date,
      endDate Date,
      remark TEXT,
      witnessName Text,
      witnessMobile Text,
      witnessAddress Text,
      status BOOLEAN DEFAULT 1  CHECK (status IN (0, 1)),
      FOREIGN KEY(cid) REFERENCES Customer(id) ON DELETE CASCADE
  )
  ''');
    await database?.execute('''
  CREATE TABLE IF NOT EXISTS Collection(id INTEGER PRIMARY KEY,
  loanId INTEGER,
  amount INTEGER NOT NULL,
  collectionDate Date NOT NULL,
  FOREIGN KEY(loanId) REFERENCES Loan(id) ON DELETE CASCADE)
  ''');
    await database?.execute('''
  CREATE TRIGGER IF NOT EXISTS `trigger_after_update_Collection_amount` AFTER Insert  ON `Collection` BEGIN
    UPDATE Loan
    SET status = 0
    WHERE loan.id = new.loanId
    AND (
        SELECT SUM(amount)
        FROM Collection 
        WHERE Collection.loanId = new.loanId
    ) >= loan.agreedAmount;
END;
  ''');
    database?.execute("PRAGMA foreign_keys=ON");
  }

  // Get List of all Customer
  Future<List<CustomerModel>?> getCustomerList() async {
    if (database == null) throw Exception("No database found");
    var data = await database?.query('Customer', orderBy: "id DESC");

    if (data == null || data.isEmpty) return null;

    var customer = data.map((e) => CustomerModel.fromJson(e)).toList();
    return Future.value(customer);
  }

  // Get Customer from LoanId
  Future<LoanModel?> getLoanModelFromLoanId(int? loanId) async {
    if (database == null) throw Exception("No database found");
    if (loanId == null) return null;
    var data = await database?.rawQuery('''
      Select c.name as customerName,c.mobile,c.aadhar,c.father,Loan.* from Loan INNER JOIN Customer c on c.id=Loan.cid 
    where Loan.id=$loanId;
    ''');
    if (data == null || data.isEmpty) return null;

    return LoanModel.fromJson(data.first);
  }

  // Get Customer and all Active Loan Status
  Future<List<LoanModel>?> getCustomerAndLoanInfo(String name) async {
    if (database == null) throw Exception("No database found");
    try {
      var data = await database?.rawQuery('''
          Select l.*,c.id as customerId,c.name customerName,c.mobile from Loan l inner join Customer c on l.cid=c.id and l.status=1
          where c.name='${name.toUpperCase()}' 
      ''');
      if (data == null || data.isEmpty) return null;
      // log("sdfsfsfsdf" + data.toString());
      return data.map((e) => LoanModel.fromJson(e)).toList();
    } catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  // Get Customer and all  Loan Status
  Future<List<LoanModel>?> getCustomerAndLoanInfoIgnoreStatus(
      int? loanId) async {
    if (database == null) throw Exception("No database found");
    try {
      if (loanId == null) return null;
      var data = await database?.rawQuery('''
          Select l.*,c.id as customerId,c.name customerName,c.mobile from Loan l inner join Customer c on l.cid=c.id 
          where c.id='$loanId' 
      ''');
      if (data == null || data.isEmpty) return null;
      // log("sdfsfsfsdf" + data.toString());
      return data.map((e) => LoanModel.fromJson(e)).toList();
    } catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  // Get List of All Transaction
  Future<List<ListItemModel>?> getTransactionList(int loanId) async {
    try {
      if (database == null) throw Exception("No database found");
      var data = await database?.rawQuery('''
      
        Select * from (
        SELECT c.amount,'CR' as [type],c.collectionDate as [date],c.id FROM Collection c where c.loanId=$loanId
        UNION ALL
        SELECT l.amount,'DR' as [type],l.startDate as [date],l.id from Loan l WHERE l.id=$loanId
        ) a
        order by [date] asc,[type]Desc;
        ''');
      if (data == null || data.isEmpty) return null;
      int previous = 0;
      return data.map((e) {
        var item = ListItemModel.fromJson(e);
        item.totalPaidAmounttillDate =
            item.type == "CR" ? (previous + item.amount) : 0;
        previous = item.totalPaidAmounttillDate;
        return item;
      }).toList();
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

  // Get List of All Transaction
  Future<InstallementReportModel?> getInstallementCard(int? loanId) async {
    try {
      if (database == null) throw Exception("No database found");
      if (loanId == null) return null;

      var data = await database?.rawQuery('''
      WITH total as ( select total(c.amount) as received ,collectionDate as lastCollection from Collection c WHERE c.loanId=$loanId order by collectionDate desc limit 1)
      SELECT total.received,total.lastCollection,l.agreedAmount-total.received as remaining,
      case when l.status=0 then 0.0 
      else
      min(cast(l.agreedAmount as double)-total.received,
      cast((julianday('now')-julianday(startDate)+1) as INTEGER)*l.installement -total.received
      )
      end as overdue
      from total
      INNER JOIN Loan l on l.id=$loanId
        ''');

      if (data == null || data.isEmpty) return null;
      return InstallementReportModel.fromJson(data.first);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Get Collection Report Between two Date
  Future<List<DateWiseCollectionReportModel>?> getCollectionReportBwDates(
      String? start, String? close) async {
    try {
      if (database == null) throw Exception("No database found");
      if (start == null || close == null) return null;
      var data = await database?.rawQuery('''
      SELECT Customer.id as cid,Customer.name,Loan.id as loanId,Collection.amount,Collection.collectionDate  FROM Collection
      left JOIN Loan on Collection.loanId=Loan.id
      LEFT JOIN Customer on Loan.cid=Customer.id
      where Collection.collectionDate BETWEEN "$start" and "$close"
      Order By collectionDate DESC,Loan.id DESC;
        ''');

      if (data == null || data.isEmpty) return null;

      return data
          .map((e) => DateWiseCollectionReportModel.fromJson(e))
          .toList();
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

  // Get Loan Report Between two Date
  Future<List<DateWiseCollectionReportModel>?> getLoanReportBwDates(
      String? start, String? close) async {
    try {
      if (database == null) throw Exception("No database found");
      if (start == null || close == null) return null;
      var data = await database?.rawQuery('''
      SELECT Customer.id as cid,Customer.name,Loan.id as loanId,Loan.amount,Loan.startDate as collectionDate FROM Loan
      LEFT JOIN Customer on Loan.cid=Customer.id
      where Loan.startDate BETWEEN "$start" and "$close"
      Order By startDate DESC,Loan.id DESC;
        ''');

      if (data == null || data.isEmpty) return null;

      return data
          .map((e) => DateWiseCollectionReportModel.fromJson(e))
          .toList();
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

  // Get List of All Loan
  Future<List<LoanModel>?> getLoanList() async {
    try {
      if (database == null) throw Exception("No database found");
      var data = await database?.rawQuery('''
      WITH Coll as (
      Select l.id as id,
      c.id as cid,
      c.name as customerName,
      c.mobile as mobile,
      l.amount as amount,
      agreedAmount as 'agreedAmount',
      installement as 'installement',
      days as 'days',
      startDate as 'startDate',
      endDate as 'endDate',
      remark  as 'remark' ,
      status as status,
      total(cl.amount) as received
      from Loan  l
      left join Collection cl on cl.loanId=l.id
      LEFT JOIN Customer c on c.id=l.cid
      GROUP BY l.id
      )
      Select 
      Coll.*,
       case when Coll.status=0 then 0.0 
      else
      min(cast(Coll.agreedAmount as double)-Coll.received,
      cast((julianday('now')-julianday(Coll.startDate)+1) as INTEGER )*Coll.installement -Coll.received
      )
      end as overdue
      from Coll;
''');
      if (data == null || data.isEmpty) return null;
      // log(data.toString());
      return data.map((e) => LoanModel.fromJson(e)).toList();
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

//  Get LoanList from CID that are active
  Future<List<LoanModel>?> getLoanListFromCid(int cid) async {
    try {
      if (database == null) throw Exception("No database found");
      var data = await database?.rawQuery('''
      WITH Coll as (
      Select l.id as id,
      c.id as cid,
      c.name as customerName,
      c.mobile as mobile,
      l.amount as amount,
      agreedAmount as 'agreedAmount',
      installement as 'installement',
      startDate as 'startDate',
      endDate as 'endDate',
      remark  as 'remark' ,
      status as status,
      total(cl.amount) as received
      from Loan  l
      left join Collection cl on cl.loanId=l.id
      inner JOIN Customer c on c.id=l.cid and c.id=$cid
        where l.status=1
      GROUP BY l.id
      )
      Select 
      Coll.*,
       case when Coll.status=0 then 0.0 
      else
      min(cast(Coll.agreedAmount as double)-Coll.received,
      cast((julianday('now')-julianday(Coll.startDate)+1) as INTEGER )*Coll.installement -Coll.received
      )
      end as overdue
      from Coll;
''');
      if (data == null || data.isEmpty) return null;
      // log(data.toString());
      return data.map((e) => LoanModel.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Get DashboardData
  Future<DashboardModel?> getDashBoardData() async {
    if (database == null) throw Exception("No database found");

    try {
      var loanStatus = await database?.rawQuery('''
           WITH closedtable as (select count(id) as closed from Loan where status<>1),
          activetable as (select count(id) as active from Loan where status=1),
          loantable as ( Select total(amount) totalamt,total(agreedAmount) as agreed from Loan ),
          collectiontable as (Select total(amount) as received FROM Collection)
          Select c.closed+a.active as totalcase,c.closed,a.active,l.totalamt,l.agreed,co.received 
          from activetable a,closedtable c,loantable l,collectiontable co;
        ''');
      if (loanStatus == null || loanStatus.isEmpty) return null;
      return DashboardModel.fromJson(loanStatus.first);
    } catch (e) {
      return null;
    }
  }

  //  Search Customer for adding new Loan
  Future<List<CustomerModel>?> searchCustomerForLoan(String name) async {
    if (database == null) throw Exception("No database found");
    if (name.isEmpty) return null;
    var data = await database?.rawQuery('''
          Select * from Customer c
          where c.name like '${name.toUpperCase()}%'; 
      ''');
    if (data == null || data.isEmpty) return null;

    return data.map((e) => CustomerModel.fromJson(e)..exist = true).toList();
  }

  Future<List<CustomerModel>?> searchCustomerForActiveLoan(String name) async {
    if (database == null) throw Exception("No database found");
    var data = await database?.rawQuery('''
          Select * from Customer c
          where c.name like '%${name.toUpperCase()}%' and c.active=1; 
      ''');
    if (data == null || data.isEmpty) return null;

    return data.map((e) => CustomerModel.fromJson(e)..exist = true).toList();
  }

  // Close a Loan
  Future<PostResponse> CloseLoan(int loanId) async {
    try {
      log(loanId.toString());
      if (database == null) throw Exception("No database found");
      var data = await database?.rawQuery('''
          update Loan set status=0 where id=$loanId
      ''');
      if (data == null || data == 0) {
        return PostResponse(false, error: "Failed to Save");
      }

      return PostResponse(true, msg: "Successfully Closed the loan");
    } catch (e) {
      log(e.toString());
      return PostResponse(false, error: "Error Occured Please Contact Admin");
    }
  }

// Save Customer Only
  Future<PostResponse> saveCustomer(CustomerModel value) async {
    if (database == null) throw Exception("No database found");
    var data = await database?.insert("Customer", value.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    if (data == null) {
      return PostResponse(false, error: "Failed to insert Customer");
    }
    if (data == 0) {
      return PostResponse(false, error: "Customer Already Exist");
    }

    return PostResponse(true, msg: "Customer Saved");
  }

// Save Collection
  Future<PostResponse> saveCollection(CollectionModel value) async {
    if (database == null) throw Exception("No database found");
    //check Loan Validation
    var dateStart = await database?.query("Loan",
        where: "id=?", whereArgs: [value.loanId], columns: ["startDate"]);
    if (DateFormat("yyyy-MM-dd")
        .parse(dateStart?.first["startDate"] as String)
        .isAfter(DateFormat("yyyy-MM-dd").parse(value.collectionDate!))) {
      return PostResponse(false,
          error: "Collection Date can't be before loan start Date");
    }
    var data = await database?.insert("Collection", value.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    if (data == null || data == 0) {
      return PostResponse(false, error: "Failed to save Collection");
    }
    return PostResponse(true, msg: "Collection Saved");
  }

// Save Loan Information
  Future<PostResponse> saveLoan(LoanModel value) async {
    if (database == null) throw Exception("No database found");
    try {
      database?.transaction((txn) async {
        if (!value.customer!.exist) {
          CustomerModel customerModel = value.customer!;
          customerModel.name = customerModel.name!.toUpperCase();
          value.cid = await txn.insert("Customer", customerModel.toMap(),
              conflictAlgorithm: ConflictAlgorithm.rollback);
          if (value.cid == null) {
            return PostResponse(false,
                error: "Error in saving the customer details.");
          } else if (value.cid == 0) {
            return PostResponse(false, error: "Customer Already Exist");
          }
        }
        value.customer = null;

        var data = await txn.insert("Loan", value.toMap(),
            conflictAlgorithm: ConflictAlgorithm.rollback);
        if (data == 0) {
          return PostResponse(false, error: "Failed to save Loan");
        }
      });
      return PostResponse(true, msg: "Loan Saved");
    } catch (e) {
      return PostResponse(false, error: "Failed to save Loan");
    }
  }

  Future<PostResponse> deleteLoan(int? loanId) async {
    if (database == null) throw Exception("No database found");
    if (loanId == null) return PostResponse(false, error: "Loan Not found");
    try {
      int value = await database?.rawDelete('''
        Delete from Loan where id=$loanId and status<>0;
      ''') ?? 0;

      if (value > 0) {
        return PostResponse(true, msg: "Loan Deleted Successfully");
      } else {
        return PostResponse(false, error: "Failed to Delete");
      }
    } catch (e) {
      return PostResponse(false, error: "Failed to Delete Loan");
    }
  }

  Future<PostResponse> deleteCollection(int? id) async {
    if (database == null) throw Exception("No database found");
    if (id == null) return PostResponse(false, error: "Transaction Not found");
    try {
      int value = await database
              ?.delete("Collection", where: "id=? ", whereArgs: [id]) ??
          0;
      if (value > 0) {
        return PostResponse(true, msg: "Transaction Deleted Successfully");
      } else {
        return PostResponse(false, error: "Failed to Delete");
      }
    } catch (e) {
      return PostResponse(false, error: "Failed to Delete Transaction");
    }
  }

// Close Database
  Future<void> closeDB() async {
    await database?.close();
  }
}
