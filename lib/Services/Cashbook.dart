import 'dart:io';

import 'package:daily_collection/Models/CashbookEntity/CashbookEntity.dart';
import 'package:daily_collection/Models/PostResponse.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class CashBookService {
  static final CashBookService _sqlService = CashBookService.initCon();
  factory CashBookService() => _sqlService;
  CashBookService.initCon();

  static Database? database;

  static void initializeDb() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", "myDb.db");
    database = await databaseFactory.openDatabase(dbPath);
    await database?.execute('''
  CREATE TABLE IF NOT EXISTS Cashbook (
      id INTEGER PRIMARY KEY,
      name TEXT ,
      remark TEXT ,
      amount INTEGER,
      date DATE,
      type TEXT CHECK (type IN ('DR', 'CR'))
  )
  ''');
  }

  saveCash(CashbookModel map) async {
    try {
      if (database == null) throw ("Cashbook Database Not found");

      var data = await database?.insert("Cashbook", map.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      if (data == null || data == 0) {
        return PostResponse(false, error: "Failed to Save Entry");
      }
      return PostResponse(true, msg: "Saved Successfully");
    } catch (e) {}
  }

  getAllCash(String? start, String? end, String? name) async {
    if (database == null) throw ("Cashbook Database Not found");
    if (name == null || name.trim().isEmpty) {
      var data = await database?.query(
        "cashbook",
        where: "date between ? and ?",
        whereArgs: [start, end],
        orderBy: "date DESC",
      );
      if (data == null || data.isEmpty) return null;
      return data.map((e) => CashbookModel.fromJson(e)).toList();
    }

    var data = await database?.query(
      "cashbook",
      where: "name =? and date between ? and ?",
      whereArgs: [name.trim().toUpperCase(), start, end],
      orderBy: "date DESC",
    );
    if (data == null || data.isEmpty) return null;
    return data.map((e) => CashbookModel.fromJson(e)).toList();
  }

  getFilteredDataFromName(String? start, String? end, String? name) async {
    if (database == null) throw ("Cashbook Database Not found");
    if (name == null) return null;
    var data = await database?.query("cashbook",
        where: "name =? and date between ? and ?",
        whereArgs: [name.trim().toUpperCase(), start, end]);
    if (data == null || data.isEmpty) return null;
    return data.map((e) => CashbookModel.fromJson(e)).toList();
  }

  Future<List<String>?> getSuggestionListOfNames() async {
    if (database == null) throw ("Cashbook Database Not found");

    var data =
        await database?.query("cashbook", distinct: true, columns: ["name"]);
    if (data == null || data.isEmpty) return null;
    return data.map((e) => e["name"].toString()).toList();
  }
}
