import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'SqlService.dart';


class DashboardService {
  static final DashboardService _sqlService = DashboardService();
  factory DashboardService() => _sqlService;
  DashboardService.initCon();

  static Database? database;

   getWeekTransactionData() async {
    if (database == null) throw Exception("No database found");
    try {
      // transaction to save customer then loan
      var data = await database?.rawQuery('''

        WITH CurrentWeek AS (
            SELECT 
                date('now', 'weekday 0', '-6 days') AS start_of_week,
                date('now', 'weekday 0') AS end_of_week
        ),
        AllWeekdays AS (
            SELECT 
                '0' AS weekday UNION ALL
            SELECT '1' UNION ALL
            SELECT '2' UNION ALL
            SELECT '3' UNION ALL
            SELECT '4' UNION ALL
            SELECT '5' UNION ALL
            SELECT '6'
        ),
        DailyTotals AS (
            SELECT 
                aw.weekday,
                COALESCE(SUM(l.amount), 0) AS total_loan,
                COALESCE(SUM(c.amount), 0) AS total_collection
            FROM 
                AllWeekdays aw
            LEFT JOIN 
                Loan l ON strftime('%w', l.disbursementDate) = aw.weekday 
                    AND l.disbursementDate BETWEEN (SELECT start_of_week FROM CurrentWeek) AND (SELECT end_of_week FROM CurrentWeek)
            LEFT JOIN 
                Collection c ON l.id = c.loanId 
                    AND c.collectionDate BETWEEN (SELECT start_of_week FROM CurrentWeek) AND (SELECT end_of_week FROM CurrentWeek)
            GROUP BY 
                aw.weekday
        )

        SELECT 
            CASE 
                WHEN weekday = '0' THEN 'Sunday'
                WHEN weekday = '1' THEN 'Monday'
                WHEN weekday = '2' THEN 'Tuesday'
                WHEN weekday = '3' THEN 'Wednesday'
                WHEN weekday = '4' THEN 'Thursday'
                WHEN weekday = '5' THEN 'Friday'
                WHEN weekday = '6' THEN 'Saturday'
            END AS WeekDay,
            total_collection,
            total_loan
        FROM 
            DailyTotals

        ''');
      if (data == null || data.isEmpty) {
        return {"success": false, "message": "No data found"};
      }
      return {"success": true, "data": data};
    } catch (_) {
      return {
        "success": false,
        "message": "Something went wrong while saving loan"
      };
    }
  }
}
