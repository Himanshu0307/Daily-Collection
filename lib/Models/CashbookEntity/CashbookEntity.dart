enum CashType { DR, CR, NA }

class CashbookModel {
  late int id;
  late int amount;
  late String name;
  late String date;
  late String? remark;
  late String? type;
  CashbookModel();

  CashbookModel.fromJson(Map<String, Object?> map) {
    id = map["id"] as int? ?? 0;
    amount = map["amount"] as int? ?? 0;
    name = map["name"] as String? ?? "";
    date = map["date"] as String? ?? "";
    type = map["type"] as String? ?? "";
    remark = map["remark"] as String? ?? "";
  }

  Map<String, Object?> toMap() {
    return {
      "Amount": amount,
      "Name": name.trim().toUpperCase(),
      "Date": date,
      "Type": type.toString(),
      "Remark": remark.toString()
    };
  }
}
