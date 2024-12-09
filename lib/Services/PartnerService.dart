import 'dart:io';

import 'package:daily_collection/Models/PostResponse.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

import '../Models/PartnersModel/PartnersModel.dart';

class PartnerService {
  static final _partnerInstance = PartnerService.empty();
  factory PartnerService() => _partnerInstance;
  PartnerService.empty();
  static Database? database;

  void showSnackBar(BuildContext context, PostResponse response) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.success ? response.msg : response.error)));
  }

  static void initializeDb() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", "myDb.db");
    database = await databaseFactory.openDatabase(dbPath);
    await database?.execute('''
      CREATE TABLE IF NOT EXISTS Partner(
      id INTEGER PRIMARY KEY,
      name TEXT ,
      percentage double 
     )
  ''');
    await database?.execute('''
      CREATE TABLE IF NOT EXISTS PartnerTransaction(
      id INTEGER PRIMARY KEY,
      partnerId INTEGER,
      amount double ,
      date Date,
      remark TEXT,
      type TEXT CHECK (type IN ('DR', 'CR')),
      FOREIGN KEY(partnerId) REFERENCES Partner(id) ON DELETE CASCADE
     )
  ''');

    await database?.execute('''
       CREATE TABLE IF NOT EXISTS Config(
      id INTEGER PRIMARY KEY,
      name TEXT,
      value Text 
      )
  ''');
  }

  getPartnersName() async {
    if (database == null) throw ("Partner Database Not found");
    var data = await database?.query("partner", columns: ["id", "name"]);

    if (data == null || data.isEmpty) return null;
    return data.map((e) => PartnerModel.fromJson(e)).toList();
  }

  Future<PartnersReport?> getPartnerReport(int partnerId, String date) async {
    try {
      if (database == null) throw ("Partner Database Not found");
      // print(date);
      // print(partnerId);
      var data = await database?.rawQuery('''
    With loanc as (SELECT total(amount) as loanAmt from Loan WHERE date(Loan.startDate)<=date("${date}")),
    coll as (SELECT total(amount)  as collAmt from Collection where date(collectionDate)<=date("${date}")),
    partnert as (SELECT 
    (SELECT total(amount) FROM PartnerTransaction where type=="DR" and partnerId=${partnerId} and PartnerTransaction.date<=date("${date}")) as totalDr,
    (SELECT total(amount) FROM PartnerTransaction where type=="CR" and partnerId=${partnerId} and PartnerTransaction.date<=date("${date}")) as totalCr
    ),
    configs as (Select cast([value] as double) as [value] from Config where id =1)
    select Partner.name, totalCr,totalDr,loanAmt,collAmt, ((collAmt-loanAmt-[value])*(Partner.percentage*0.01) ) -totalDr +totalCr as finalAmount from loanc,coll,partnert,Partner,configs where Partner.id=${partnerId};
    ''');

      if (data == null || data.isEmpty) return null;
      // print(data);
      return data.map((e) => PartnersReport.fromJson(e)).firstOrNull!;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<PartnerTransaction>?> getPartnerTransactions(
      int partnerId, String date) async {
    if (database == null) throw ("Partner Database Not found");
    var data = await database?.query("PartnerTransaction",
        where: "partnerId=? and date(PartnerTransaction.date)<=date(?)",
        whereArgs: [partnerId, date]);

    if (data == null || data.isEmpty) return null;
    return data.map((e) => PartnerTransaction.fromJson(e)).toList();
  }

  Future<PostResponse> savePartners(PartnerModel partnerModel) async {
    if (database == null) throw ("Partner Database Not found");
    var data = await database?.insert("partner", partnerModel.toJson());

    if (data == null || data <= 0) {
      return PostResponse(false, error: "Failed to Save");
    }
    return PostResponse(true, msg: "Saved Successfully");
  }

  Future<PostResponse> savePartnerTransaction(
      PartnerTransaction partnerModel) async {
    if (database == null) throw ("Partner Database Not found");
    var data =
        await database?.insert("PartnerTransaction", partnerModel.toJson());

    if (data == null || data <= 0) {
      return PostResponse(false, error: "Failed to Save");
    }
    return PostResponse(true, msg: "Saved Successfully");
  }
}
