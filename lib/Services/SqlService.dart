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
  Future<dynamic> getCustomerList() async {
    try {
      if (database == null) throw Exception("No database found");
      var data = await database?.query('Customer', orderBy: "id DESC");

      if (data == null || data.isEmpty) {
        return {"success": false, "message": "No Data Found"};
      }
      var customer = data.map((e) => CustomerModel.fromJson(e)).toList();
      return {"success": true, "data": customer};
    } catch (e) {
      log(e.toString());
      return {"success": false, "message": "Unexprected error occured"};
    }
  }

  // // Get Customer from LoanId
  // Future<LoanModel?> getLoanModelFromLoanId(int? loanId) async {
  //   if (database == null) throw Exception("No database found");
  //   if (loanId == null) return null;
  //   var data = await database?.rawQuery('''
  //     Select c.name as customerName,c.mobile,c.aadhar,c.father,Loan.* from Loan INNER JOIN Customer c on c.id=Loan.cid
  //   where Loan.id=$loanId;
  //   ''');
  //   if (data == null || data.isEmpty) return null;

  //   return LoanModel.fromJson(data.first);
  // }

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
  Future<dynamic> getTransactionList(int loanId) async {
    try {
      if (database == null) throw Exception("No database found");
      var data = await database?.rawQuery('''
        Select * from (
        SELECT c.amount,'CR' as [type],c.collectionDate as [date],c.id FROM Collection c where c.loanId=$loanId
        UNION ALL
        SELECT l.amount,'DR' as [type],l.disbursementDate as [date],l.id from Loan l WHERE l.id=$loanId
        ) a
        order by [date] asc,[type]Desc;
        ''');
      if (data == null || data.isEmpty) {
        return {"success": false, "message": "No data found"};
      }
      int previous = 0;
      return {
        "success": true,
        "data": data.map((e) {
          var item = ListItemModel.fromJson(e);
          item.totalPaidAmounttillDate =
              item.type == "CR" ? (previous + item.amount) : 0;
          previous = item.totalPaidAmounttillDate;
          return item;
        }).toList()
      };
    } catch (e) {
      // log(e.toString());
      return {"success": false, "message": "Unexpected Error occured."};
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
  getCollectionReportBwDates(String? start, String? close) async {
    try {
      if (database == null) throw Exception("No database found");
      if (start == null || close == null) {
        return {
          "success": false,
          "message": "Invalid start Date or close Date"
        };
      }
      var data = await database?.rawQuery('''
      SELECT Customer.id as customerId,Customer.name customerName,Loan.id as loanId,Collection.amount,Collection.collectionDate FROM Collection
      left JOIN Loan on Collection.loanId=Loan.id
      LEFT JOIN Customer on Loan.cid=Customer.id
      where date(Collection.collectionDate) BETWEEN date("$start") and date("$close")
      Order By collectionDate DESC;
        ''');

      if (data == null || data.isEmpty) {
        return {"success": false, "message": "No data found"};
      }

      return {
        "success": true,
        "data":
            data.map((e) => DateWiseCollectionReportModel.fromJson(e)).toList()
      };
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

  // Get Collection Report of ALL Transactions
  Future<List<DateWiseTransactionReportModel>?> getTransactionReportBwDates(
      String? start, String? close) async {
    try {
      if (database == null) throw Exception("No database found");
      if (start == null || close == null) return null;
      var data = await database?.rawQuery('''
      WITH coll as (SELECT total(amount) as amount, collectionDate as [date],'CR' as [type],'Customer' as [to] from Collection  where collectionDate BETWEEN "$start" and "$close"  GROUP BY collectionDate ),
loantemp as (
    Select total(amount) as amount,startDate as [date], 'DR' as [type],'Customer' as [to] from Loan where startDate BETWEEN "$start" and "$close" GROUP BY startDate
    ),
partners as(
    SELECT total(amount) as amount,[date],[type],'Partner' as [to] from PartnerTransaction where [date] BETWEEN "$start" and "$close" GROUP BY [date],[type]
    )
Select * from coll
UNION ALL
Select * from Loantemp
UNION ALL 
Select * from partners
order by [date] DESC;
        ''');

      if (data == null || data.isEmpty) return null;

      return data
          .map((e) => DateWiseTransactionReportModel.fromJson(e))
          .toList();
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

  // Get Loan Report Between two Date
  Future<dynamic> getLoanReportBwDates(String? start, String? close) async {
    try {
      if (database == null) throw Exception("No database found");
      if (start == null || close == null) {
        return {"success": "false", "message": "Invalid Date inputs"};
      }
      var data = await database?.rawQuery('''
      SELECT Customer.id as customerId,Customer.name customerName,Loan.id as loanId,Loan.amount,Loan.startDate as startDate,loan.disbursementDate as disbursementDate FROM Loan
      LEFT JOIN Customer on Loan.cid=Customer.id
      where date(Loan.disbursementDate) BETWEEN date("$start") and date("$close")
      Order By disbursementDate DESC,Loan.id DESC;
        ''');

      if (data == null || data.isEmpty) {
        return {"success": false, "message": "No data found"};
      }

      return {
        "success": true,
        "data":
            data.map((e) => DateWiseLoanReportModel.fromJson(e)).toList()
      };
    } catch (e) {
      log(e.toString());
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
  Future<dynamic> getLoanListFromCid(int cid) async {
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
      if (data == null || data.isEmpty) {
        return {"success": false, "message": "No Active Loan Found"};
      }
      return {"success": true, "data": data};
    } catch (e) {
      log(e.toString());
      return {"success": false, "message": "Unexpected error occured"};
    }
  }

  // Get LoanList from CID that are active
  Future<dynamic> getActiveLoanListFromCid(int cid) async {
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
      if (data == null || data.isEmpty) {
        return {"success": false, "message": "No Active Loan Found"};
      }
      return {"success": true, "data": data};
    } catch (e) {
      log(e.toString());
      return {"success": false, "message": "Unexpected error occured"};
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
          collectiontable as (Select total(amount) as received FROM Collection),
          partnerCR as (Select total(amount) amount from PartnerTransaction where [type]="CR"),
          partnerDR as (Select total(amount) amount FROM PartnerTransaction where [type]="DR"),
          con as (Select cast([value] as double) as initial from Config where id=1 )
        
          Select c.closed+a.active as totalcase,c.closed,a.active,l.totalamt,l.agreed,co.received,
          con.initial -l.totalamt+co.received+ partnerCR.amount -partnerDR.amount as inHand
          from activetable a,closedtable c,loantable l,collectiontable co,partnerCR,partnerDR,con;
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

  // Future<List<CustomerModel>?> searchCustomerForActiveLoan(String name) async {
  //   if (database == null) throw Exception("No database found");
  //   var data = await database?.rawQuery('''
  //         Select * from Customer c
  //         where c.name like '%${name.toUpperCase()}%' and c.active=1;
  //     ''');
  //   if (data == null || data.isEmpty) return null;

  //   return data.map((e) => CustomerModel.fromJson(e)..exist = true).toList();
  // }

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
  Future<dynamic> saveCustomer(Map<String, Object?> value) async {
    if (database == null) throw Exception("No database found");
    var data = await database?.insert("Customer", value,
        conflictAlgorithm: ConflictAlgorithm.ignore);
    if (data == null) {
      return {"success": false, "message": "Failed to save customer"};
    }
    if (data == 0) {
      return {"success": false, "message": "Customer Already Exist"};
    }

    return {"success": true, "message": "New Customer Added"};
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

  Future<dynamic> deleteLoan(int? loanId) async {
    if (database == null) throw Exception("No database found");
    if (loanId == null) return PostResponse(false, error: "Loan Not found");
    try {
      int value = await database?.rawDelete('''
        Delete from Loan where id=$loanId and status<>0;
      ''') ?? 0;

      if (value > 0) {
        return {"message": "Loan Deleted Successfully", "success": true};
      } else {
        return {"message": "Failed to Delete", "success": false};
      }
    } catch (e) {
      return {"message": "Failed to Delete", "success": false};
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

  // Get Customer List for suggestion
  Future<List<CustomerModel>?> getCustomerSuggestion(String name) async {
    if (database == null) throw Exception("No database found");
    if (name.isEmpty) return null;
    var data = await database?.rawQuery('''
          Select * from Customer c
          where c.name like '${name.toUpperCase()}%'; 
      ''');
    if (data == null || data.isEmpty) return null;

    return data.map((e) => CustomerModel.fromJson(e)..exist = true).toList();
  }

  // Get Loan Report from Loan ID

  Future<dynamic> getLoanReportFromId(int loanId) async {
    if (database == null) throw Exception("No database found");
    // fix: get all three insformation i.e customer, loan. and transaction

    var loan = await database?.rawQuery('''
      Select * from loan where id=$loanId;
    ''');
    if (loan == null || loan.isEmpty) {
      return {"success": false, "message": "Loan does not exist"};
    }
    var customer = await database?.rawQuery('''
     SELECT c.* FROM Loan l
      inner join customer c on l.cid=c.id 
      where l.id=${loan.first["id"]};s
    ''');
    var transaction = await database?.rawQuery('''
      Select
    total(c.amount) as received,
    l.agreedAmount-total(c.amount)  as remaining,
    (
        min(
          (
              JULIANDAY(date()) - JULIANDAY(date(l.startDate)) + 1
          ) * l.installement,
          l.agreedAmount
        )
    )- total(c.amount)  as overdue,
    max(date(c.collectionDate)) as lastCollection
    from
        Loan l
        left join Collection c on l.id = c.loanId
    where
    l.id =${loan.first["id"]};
    ''');
    LoanReportIdModel model = LoanReportIdModel();
    model.customerModel = CustomerModel.fromJson(customer!.first);
    model.loanModel = LoanModel.fromJson(loan.first);
    model.reportModel = transaction != null
        ? InstallementReportModel.fromJson(transaction.first)
        : null;
    return {"data": model, "success": true};

    //   return LoanModel.fromJson(data.first);
  }

  // Get Loan Information as per loan Status

  Future<dynamic> getLoanListfromStatus(String status) async {
    if (status == "all") {
      var loanInfo = await database?.rawQuery('''
     SELECT l.*,c.name as customerName,total(col.amount) as received,
      (
              min(
                (
                    JULIANDAY(date()) - JULIANDAY(date(l.startDate)) + 1
                ) * l.installement,
                l.agreedAmount
              )
      )- total(col.amount)  as overdue
      FROM Loan l
      inner join Customer c on c.id=l.cid 
      left join Collection col on col.loanId=l.id
      GROUP by l.id ;
    ''');
      return {"success": true, "data": loanInfo};
    }

    // if loan status is active
    else if (status == "active") {
      var loanInfo = await database?.rawQuery('''
     SELECT l.*,c.name as customerName,total(col.amount) as received,
      (
              min(
                (
                    JULIANDAY(date()) - JULIANDAY(date(l.startDate)) + 1
                ) * l.installement,
                l.agreedAmount
              )
      )- total(col.amount)  as overdue
      FROM Loan l
      inner join Customer c on c.id=l.cid 
      left join Collection col on col.loanId=l.id
      where l.status=true
      GROUP by l.id ;
    ''');
      return {"success": true, "data": loanInfo};
    }

    // if loan status is closed
    else {
      var loanInfo = await database?.rawQuery('''
     SELECT l.*,c.name as customerName,total(col.amount) as received,
      (
              min(
                (
                    JULIANDAY(date()) - JULIANDAY(date(l.startDate)) + 1
                ) * l.installement,
                l.agreedAmount
              )
      )- total(col.amount)  as overdue
      FROM Loan l
      inner join Customer c on c.id=l.cid 
      left join Collection col on col.loanId=l.id
      where l.status=false
      GROUP by l.id ;
    ''');
      return {"success": true, "data": loanInfo};
    }
  }

// Save new customer Loan Information
  Future<dynamic> saveNewLoan(Map<String, dynamic> value) async {
    if (database == null) throw Exception("No database found");
    try {
      // transaction to save customer then loan
      await database?.transaction((txn) async {
        var customer = CustomerModel.fromJson(value);
        int cid = await txn.insert("Customer", customer.toMap());
        if (cid == 0) {
          return {"success": false, "message": "Customer Already Exist"};
        }

        var loan = LoanModel.fromJson(value);
        loan.cid = cid;
        // print(loan.toMap());
        var data = await txn.insert("Loan", loan.toMap(),
            conflictAlgorithm: ConflictAlgorithm.rollback);
        if (data == 0) {
          return {"success": false, "message": "Failed to  save Data"};
        }
      });
      return {"success": true, "message": "Loan Saved Successfull"};
    } catch (_) {
      return {
        "success": false,
        "message": "Something went wrong while saving loan"
      };
    }
  }

//  Save Loan for Existing  Information
  Future<dynamic> saveExistingCustomerLoan(Map<String, dynamic> value) async {
    if (database == null) throw Exception("No database found");
    try {
      // transaction to save customer then loan
      await database?.transaction((txn) async {
        var loan = LoanModel.fromJson(value);
        var data = await txn.insert("Loan", loan.toMap(),
            conflictAlgorithm: ConflictAlgorithm.rollback);
        if (data == 0) {
          return {"success": false, "message": "Failed to  save Data"};
        }
      });
      return {"success": true, "message": "Loan Saved Successfull"};
    } catch (_) {
      return {
        "success": false,
        "message": "Something went wrong while saving loan"
      };
    }
  }
}
