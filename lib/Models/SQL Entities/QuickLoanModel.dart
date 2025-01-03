import 'dart:developer';

import 'package:daily_collection/utils/datetime.dart';
import 'package:intl/intl.dart';

class LoanModel {
  int? id;
  int amount = 0;
  int installement = 0;
  int days = 0;
  int agreedAmount = 0;
  String startDate = "";
  String endDate = "";
  String disbursementDate = "";
  String? remark;
  String? witnessName;
  String? witnessMobile;
  String? witnessAddress;
  bool status = true;
  int cid = 0;

  LoanModel.fromJson(Map<String, Object?> json) {
    try {
      id = json["id"] as int?;
      amount = json["amount"] as int;
      agreedAmount = json["agreedAmount"] as int;
      installement = json["installement"] as int;
      days = json["days"] as int;
      startDate = getFormattedDate(json["startDate"] as String);
      endDate = getFormattedDate(json["endDate"] as String);
      remark = json["remark"] as String?;
      witnessName = json["witnessName"] as String?;
      witnessMobile = json["witnessMobile"] as String?;
      witnessAddress = json["witnessAddress"] as String?;
      status = json["status"].runtimeType == int
          ?
          // if 1 then true else false
          json["status"] == 1
              ? true
              : false
          : true;
      disbursementDate = getFormattedDate(json["disbursementDate"] as String);
      cid = json["cid"] as int;
    } catch (err) {
      log(err.toString());
      // log(err.());
    }
  }

  LoanModel(
      {this.id,
      required this.amount,
      required this.agreedAmount,
      required this.installement,
      required this.days,
      required this.startDate,
      required this.endDate,
      required this.disbursementDate,
      this.remark,
      this.witnessName,
      this.witnessMobile,
      this.witnessAddress,
      required this.status,
      required this.cid});

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "amount": amount,
      "agreedAmount": agreedAmount,
      "installement": installement,
      "days": days,
      "startDate": startDate,
      "endDate": endDate,
      "remark": remark,
      "witnessName": witnessName,
      "witnessMobile": witnessMobile,
      "witnessAddress": witnessAddress,
      "cid": cid,
      "disbursementDate": disbursementDate
    };
  }
}

class ELoanModel extends LoanModel {
  double overdue = 0.0;
  ELoanModel.fromJson(json) : super.fromJson(json) {
    overdue = json["overdue"];
  }
}

class CustomerModel {
  int? id;
  String name = "";
  String mobile = "";
  String address = "";
  String aadhar = "";
  String father = "";
  bool exist = false;

  CustomerModel.fromJson(Map<String, Object?> map) {
    id = map["id"] as int?;
    name = map["name"] as String;
    aadhar = map["aadhar"] as String;
    mobile = map["mobile"] as String;
    address = map["address"] as String;
    father = map["father"] as String;
  }

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "mobile": mobile,
      "aadhar": aadhar,
      "father": father
    };
  }

  CustomerModel(
      {this.id,
      required this.name,
      required this.mobile,
      required this.address,
      required this.aadhar,
      required this.father});
}

class CollectionModel {
  int? id;
  int loanId;

  int amount;
  String collectionDate;

  toMap() {
    return {
      "id": id,
      "loanId": loanId,
      "amount": amount,
      "collectionDate": collectionDate
    };
  }

  // CollectionModel.fromJson(Map<String, Object?> map);

  CollectionModel(
      {this.id,
      required this.loanId,
      required this.amount,
      required this.collectionDate}) {
    collectionDate = getFormattedDate(collectionDate);
  }
}

class DashboardModel {
  int? totalcase = 0;
  int? active = 0;
  int? closed = 0;
  double? totalamt = 0;
  double? agreed = 0;
  double? received = 0;
  double? inHand = 0;

  DashboardModel.fromJson(Map<String, Object?> map) {
    totalcase = map["totalcase"] as int?;
    active = map["active"] as int?;
    closed = map["closed"] as int?;
    totalamt = map["totalamt"] as double?;
    agreed = map["agreed"] as double?;
    received = map["received"] as double?;
    inHand = map["inHand"] as double?;
  }

  // Map<String, Object?> toMap() {
  //   return {
  //     "totalCases": totalcase,
  //     "activeCases": active,
  //     "closedCases": closed,
  //     "totalloanamount": totalamt,
  //     "totalagreedamount": agreed,
  //     "totalreceivedamount": received
  //   };
  // }
}

class InstallementReportModel {
  late double received;
  late double remaining;
  late double overdue;
  late String lastCollection;

  InstallementReportModel.fromJson(Map<String, Object?> map) {
    received = map["received"] as double? ?? 0.0;
    overdue = map["overdue"] == null || map["overdue"] as double < 0
        ? 0.0
        : map["overdue"] as double;
    remaining = map["remaining"] as double? ?? 0.0;
    lastCollection = map["lastCollection"] as String? ?? "";
  }
}

class DateWiseLoanReportModel {
  late int customerId;
  late int loanId;
  late int amount;
  late String customerName;
  late String startDate;
  late String disbursementDate;

  DateWiseLoanReportModel.fromJson(Map<String, Object?> map) {
    customerId = map["customerId"] as int? ?? 0;
    loanId = map["loanId"] as int? ?? 0;
    amount = map["amount"] as int? ?? 0;
    customerName = map["customerName"] as String? ?? "";
    startDate = map["startDate"] as String? ?? "";
    disbursementDate = map["disbursementDate"] as String? ?? "";
  }
}

class DateWiseCollectionReportModel {
  late int customerId;
  late int loanId;
  late int amount;
  late String customerName;
  late String collectionDate;

  DateWiseCollectionReportModel.fromJson(Map<String, Object?> map) {
    customerId = map["customerId"] as int? ?? 0;
    loanId = map["loanId"] as int? ?? 0;
    amount = map["amount"] as int? ?? 0;
    customerName = map["customerName"] as String? ?? "";
    collectionDate = map["collectionDate"] as String? ?? "";
  }
}

class DateWiseTransactionReportModel {
  late double amount;
  late String to;
  late String date;
  late String type;

  DateWiseTransactionReportModel.fromJson(Map<String, Object?> map) {
    amount = map["amount"] as double? ?? 0.0;
    to = map["to"] as String? ?? "";
    date = map["date"] as String? ?? "";
    type = map["type"] as String? ?? "";
  }
}

class LoanReportIdModel {
  late LoanModel loanModel;
  late CustomerModel customerModel;
  late InstallementReportModel? reportModel;
}

class LoanReportModel {
  final int? loanId;
  final int? customerId;
  final String? customerName;
  final double? overdue;
  final int? amount;
  final int? installement;
  final int? days;
  final int? agreedAmount;
  final String? startDate;
  final String? endDate;
  final String? disbursementDate;
  final String? remark;
  final String? witnessName;
  final bool? status;
  final double? received;
  const LoanReportModel(
      {this.loanId,
      this.customerId,
      this.customerName,
      this.overdue,
      this.amount,
      this.installement,
      this.days,
      this.agreedAmount,
      this.startDate,
      this.endDate,
      this.disbursementDate,
      this.remark,
      this.witnessName,
      this.status,
      this.received});

  LoanReportModel.fromJson(Map<String, Object?> data)
      : loanId = data['id'] as int?,
        customerId = data['cid'] as int?,
        customerName = data['customerName'] as String?,
        overdue = data['overdue'] as double?,
        amount = data['amount'] as int?,
        installement = data['installement'] as int?,
        days = data['days'] as int?,
        agreedAmount = data['agreedAmount'] as int?,
        startDate = data['startDate'] as String?,
        endDate = data['endDate'] as String?,
        disbursementDate = data['disbursementDate'] as String?,
        remark = data['remark'] as String?,
        witnessName = data['witnessName'] as String?,
        status = (data['status'] as int) == 1,
        received = data['received'] as double?;
}

class TransactionReportModel {
  List<ELoanModel> loanModel = [];
  late CustomerModel customerModel;
  double overdue = 0.0;
}

class ListItemModel {
  String? collectionDate;
  String? type;
  int amount = 0;
  int? id;
  int totalPaidAmounttillDate = 0;
  ListItemModel.fromJson(Map<String, Object?> map) {
    type = map["type"] as String;
    collectionDate = map["date"] as String?;
    amount = map["amount"] as int;
    id = map["id"] as int;
  }
  ListItemModel(
      {required this.collectionDate, required this.type, required this.amount});
}

class CustomerLoanReportModel {
  final int id;
  final int cid;
  final String customerName;
  final String mobile;
  final double amount;
  final double agreedAmount;
  final int installment;
  final String startDate;
  final String endDate;
  final String remark;
  final int status;
  final double received;
  final double overdue;

  CustomerLoanReportModel({
    required this.id,
    required this.cid,
    required this.customerName,
    required this.mobile,
    required this.amount,
    required this.agreedAmount,
    required this.installment,
    required this.startDate,
    required this.endDate,
    required this.remark,
    required this.status,
    required this.received,
    required this.overdue,
  });

  factory CustomerLoanReportModel.fromJson(Map<String, dynamic> json) {
    return CustomerLoanReportModel(
      id: json['id'],
      cid: json['cid'],
      customerName: json['customerName'],
      mobile: json['mobile'],
      amount: json['amount'].toDouble(),
      agreedAmount: json['agreedAmount'].toDouble(),
      installment: json['installement'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      remark: json['remark'] ?? "",
      status: json['status'],
      received: json['received'].toDouble(),
      overdue: json['overdue'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cid': cid,
      'customerName': customerName,
      'mobile': mobile,
      'amount': amount,
      'agreedAmount': agreedAmount,
      'installement': installment,
      'startDate': startDate,
      'endDate': endDate,
      'remark': remark,
      'status': status,
      'received': received,
      'overdue': overdue,
    };
  }
}

getFormattedDate(String date) {
  return DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
}
