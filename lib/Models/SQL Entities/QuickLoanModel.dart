import 'package:intl/intl.dart';

class LoanModel {
  int? id;
  int? amount;
  int? agreedAmount;
  int? installement;
  int? days;
  String? startDate;
  String? endDate;
  set endDateSetter(_) {
    if (startDate != null && startDate!.isNotEmpty && days != null) {
      var date =
          DateFormat("yyyy-MM-dd").parse(startDate!).add(Duration(days: days!));
      endDate = DateFormat("yyyy-MM-dd").format(date);
    }
  }

  set agreedAmountSetter(_) {
    if (installement != null && days != null) {
      agreedAmount = installement! * days!;
    }
  }

  String? remark;
  String? witnessName;
  String? witnessMobile;
  String? witnessAddress;
  String? status;
  int? cid;
  double? overdue;
  CustomerModel? customer;

  LoanModel.fromJson(Map<String, Object?> json) {
    try {
      id = json["id"] as int;
      amount = json["amount"] as int?;
      agreedAmount = json["agreedAmount"] as int;
      installement = json["installement"] as int?;
      days = json["days"] as int?;
      startDate = (json["startDate"] as String?);
      endDate = json["endDate"] as String?;
      remark = json["remark"] as String?;
      witnessName = json["witnessName"] as String?;
      witnessMobile = json["witnessMobile"] as String?;
      witnessAddress = json["witnessAddress"] as String?;
      if (json["status"].runtimeType == int) {
        status = json["status"] == 0 ? "Closed" : "Active";
      }
      if (json["status"].runtimeType == String) {
        status = json["status"] as String?;
      }
      cid = json["cid"] as int?;
      customer = CustomerModel(id: cid);
      if (json.containsKey("customerName")) {
        customer?.name = json["customerName"] as String?;
      }
      if (json.containsKey("mobile")) {
        customer?.mobile = json["mobile"] as String?;
      }
      if (json.containsKey("aadhar")) {
        customer?.aadhar = json["aadhar"] as String?;
      }
      if (json.containsKey("father")) {
        customer?.father = json["father"] as String?;
      }
      if (json.containsKey("overdue")) {
        overdue =
            json["overdue"] as double < 0.0 ? 0.0 : json["overdue"] as double?;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  LoanModel(
      {this.id,
      this.amount,
      this.agreedAmount,
      this.installement,
      this.days,
      this.startDate,
      this.endDate,
      this.remark,
      this.witnessName,
      this.witnessMobile,
      this.witnessAddress,
      this.status,
      this.cid});

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
      "cid": cid
    };
  }

  Map<String, Object?> toTableJson() {
    return {
      "LoanId": id,
      "CustomerId": cid,
      "Name": customer?.name,
      "Amount": amount,
      "Agreed Amount": agreedAmount,
      "Overdue": overdue,
      "Installement": installement,
      "Loan Tenure": days,
      "Start Date": startDate,
      "End Date": endDate,
      "Remark": remark ?? "",
      "Status": status,
    };
  }
}

class CustomerModel {
  int? id;
  String? name;
  String? address;
  String? mobile;
  String? aadhar;
  String? father;
  bool exist = false;
  bool active = false;

  CustomerModel.fromJson(Map<String, Object?> map) {
    id = map["id"] as int?;
    name = map["name"] as String?;
    aadhar = map["aadhar"] as String?;
    mobile = map["mobile"] as String?;
    address = map["address"] as String?;
    father = map["father"] as String?;
    active = (map["active"] as int) == 1 ? true : false;
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
      this.name,
      this.mobile,
      this.address,
      this.aadhar,
      this.father});
}

class CollectionModel {
  int? id;
  int? loanId;

  int? amount;
  String? collectionDate;

  toMap() {
    return {
      "id": id,
      "loanId": loanId,
      "amount": amount,
      "collectionDate": collectionDate
    };
  }

  CollectionModel.fromJson(Map<String, Object?> map);

  CollectionModel({this.id, this.loanId, this.amount, this.collectionDate});
}

class DashboardModel {
  int? totalcase = 0;
  int? active = 0;
  int? closed = 0;
  double? totalamt = 0;
  double? agreed = 0;
  double? received = 0;

  DashboardModel.fromJson(Map<String, Object?> map) {
    totalcase = map["totalcase"] as int?;
    active = map["active"] as int?;
    closed = map["closed"] as int?;
    totalamt = map["totalamt"] as double?;
    agreed = map["agreed"] as double?;
    received = map["received"] as double?;
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

class DateWiseCollectionReportModel {
  late int cid;
  late int loanId;
  late int amount;
  late String name;
  late String collectionDate;

  DateWiseCollectionReportModel.fromJson(Map<String, Object?> map) {
    cid = map["cid"] as int? ?? 0;
    loanId = map["loanId"] as int? ?? 0;
    amount = map["amount"] as int? ?? 0;
    name = map["name"] as String? ?? "";
    collectionDate = map["collectionDate"] as String? ?? "";
  }
}
