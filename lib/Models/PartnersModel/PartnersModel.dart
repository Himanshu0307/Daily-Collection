class PartnerModel {
  int? id;
  late String name;
  late double percentage;

  PartnerModel.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    percentage = map["percentage"] ?? 0.0;
  }

  PartnerModel(this.name, this.percentage);

  toJson() {
    Map<String, dynamic> map = {};
    map["id"] = id;
    map["name"] = name;
    map["percentage"] = percentage;
    return map;
  }
}

class PartnerTransaction {
  late int? id;
  late int partnerId;
  late double amount;
  late String date;
  late String? remark;
  late String type;
  PartnerTransaction(
      {required this.partnerId,
      required this.amount,
      required this.date,
      this.remark,
      required this.type});

  PartnerTransaction.fromJson(Map<String, Object?> map) {
    id = map["id"] as int?;
    partnerId = map["partnerId"] as int? ?? 0;
    amount = map["amount"] as double? ?? 0.0;
    date = map["date"] as String;
    remark = map["remark"] as String?;
    type = map["type"] as String;
  }
  toJson() {
    Map<String, Object?> map = {};
    map["partnerId"] = partnerId;
    map["amount"] = amount;
    map["date"] = date;
    map["remark"] = remark;
    map["type"] = type;
    return map;
  }
}

class PartnersReport {
  double? totalCr;
  double? totalDr;
  double? loanAmt;
  double? collAmt;
  double? finalAmount;
  String? name;

  PartnersReport.fromJson(Map<String, dynamic> map) {
    totalCr = map["totalCr"];
    totalDr = map["totalDr"];
    loanAmt = map["loanAmt"] ?? 0.0;
    collAmt = map["collAmt"] ?? 0.0;
    finalAmount = (map["finalAmount"] as double).ceilToDouble() ?? 0.0;
    name = map["name"];
  }

  // toJson() {
  //   Map<String, dynamic?> map = {};
  //   map["id"] = id;
  //   map["name"] = name;
  //   map["percentage"] = percentage;
  //   return map;
  // }
}
