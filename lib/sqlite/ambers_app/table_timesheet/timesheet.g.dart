import 'package:flutter/material.dart';
/// AUTO-GENERATED CODE - DO NOT MODIFY
/// Created: May 16,2020 22:30(utc)

import 'package:sqflite/sqflite.dart';
import 'package:flutter_sqlite_controller/flutter_sqlite_controller.dart' as SQL;

///- Class declaration
class Timesheet extends SQL.SQLParse<Timesheet>{

   /// Class and Column keys
   static const String columnParentTableName = 'parentTableName';
   static const String columnParentRowid = 'parentRowid';
   static const String columnFinish = 'finish';     // finish shift
   static const String columnJobid = 'jobid';     // id in jobs table
   static const String columnRate = 'rate';     // hourly rate
   static const String columnStart = 'start';

   ///- Property/Column declarations
   static bool _createTableIfNeeded = true;    //Safety check to avoid repeatedly creating the timesheet table

   String _finish;     // finish shift
   DateTime get finish => SQL.getDateTime(_finish);
   setFinish(dynamic newValue) => _finish = SQL.dateString(newValue);

   int _jobid;     // id in jobs table
   int get jobid => _jobid;
   setJobid(int newValue) => _jobid = newValue;

   double _rate;     // hourly rate
   double get rate => _rate;
   setRate(double newValue) => _rate = newValue;

   String _start;
   DateTime get start => SQL.getDateTime(_start);
   setStart(dynamic newValue) => _start = SQL.dateString(newValue);


   ///- ToJson
   Map<String, dynamic> toJson() => {
       'finish': finish,
       'jobid': jobid,
       'rate': rate,
       'start': start,
   };

   ///- ToCloud
   Map<String, dynamic> toCloud() => {
       'finish': finish,
       'jobid': jobid,
       'rate': rate,
       'start': start,
   };

///- Static constructors
  static Timesheet build(dynamic data) {
    if (data == null) return null;
    if (data is Map) return Timesheet.fromJson(data);
    if (data is Timesheet) return data;
    throw Exception('static timesheetBuild could not parse: ${data.toString()}');
  }
  
  ///- buildArray
  static List<Timesheet> buildArray(List<dynamic> array) {
    List<Timesheet> result = List();
    if (array == null) return result;
    if (array is List<Map<String,dynamic>>) {
      for (Map<String,dynamic> item in array) {
         if (item['parentTableName'] == null) {
           result.add(Timesheet.fromCloud(item));
         } else {
           result.add(Timesheet.fromJson(item));
         }
      }
      return result;
    }
    if (array is List<Timesheet>) {
      for (Timesheet item in array) {
         result.add(item);
      }
      return result;
    }
    throw Exception('Unknown datatype $array');
  }


   ///- Constructor
   Timesheet({
       int parentRowid,
       String parentTableName,
       dynamic finish,
       int jobid,
       double rate,
       dynamic start,
     }){
       this.parentRowid = parentRowid;
       this.parentTableName = parentTableName;
       setFinish(finish);
       setJobid(jobid);
       setRate(rate);
       setStart(start);
   }


   ///- Factory fromJson
   factory Timesheet.fromJson(Map<String, dynamic> json) { 
       var _instance = Timesheet(
         parentRowid : json['parentRowid'] ?? 0,
         parentTableName : json['parentTableName'] ?? '',
         finish : json['finish'],
         jobid : json['jobid'],
         rate : json['rate'],
         start : json['start'],
       );
       return _instance;
   }

   ///- Factory from Cloud
   factory Timesheet.fromCloud(Map<String, dynamic> json) { 
       var _instance = Timesheet(
         finish : json['finish'],
         jobid : json['jobid'],
         rate : json['rate'],
         start : json['start'],
       );
       return _instance;
   }
   ///- **************** BEGIN Sqlite C.R.U.D.  {Create, Read, Update, Delete}

   ///- SQLite Create 
   Future<int> create({@required SQL.SQLiteLink link}) async {
     await createTable();
     this.parentRowid = link.rowid;
     this.parentTableName = link.tableName;
     final sql = '''INSERT INTO TIMESHEET
     (
         parentRowid,
         parentTableName,
         finish,
         jobid,
         rate,
         start
     )
     VALUES
     (
         ${link.rowid},
         "${link.tableName}",
         "$_finish",
         $_jobid,
         $_rate,
         "$_start"
     )''';

     int newRowid = await SQL.SqliteController.database.rawInsert(sql);
     this.rowid = newRowid;
     return this.rowid;
   }

   ///- SQLite Read
   static Future<List<Timesheet>> read({SQL.SQLiteLink link, String whereClause, String orderBy = 'rowid'}) async {
    await createTable();
    final clause = whereClause ?? link?.clause;
    String sql = 'SELECT rowid,* from TIMESHEET';
    if (clause != null) sql += ' WHERE $clause';
    if (orderBy != null) sql += ' ORDER BY $orderBy';
    List<Map<String,dynamic>> maps = await SQL.SqliteController.database.rawQuery(sql).catchError((error, stack) {
       throw Exception(error.toString());
    });
    List<Timesheet> results = List();
    for (Map<String,dynamic> map in maps) {
       final result = Timesheet.fromJson(map);
       result.rowid = map['rowid'];
       results.add(result);
    }  
    return results;
  }

   ///- SQLite Update Class
   Future<int> update({SQL.SQLiteLink link}) async {
     final clause = link.clause;
     await createTable();
     this.parentRowid = link.rowid;
     this.parentTableName = link.tableName;
     final sql = '''UPDATE TIMESHEET
     SET
       parentRowid = $parentRowid,
       parentTableName = "$parentTableName",
       finish = "$finish",
       jobid = $jobid,
       rate = $rate,
       start = "$start"
     WHERE $clause''';

     return await SQL.SqliteController.database.rawUpdate(sql);
   }

   ///- Create Delete
   Future<int> delete({SQL.SQLiteLink link, String where}) async {
      await createTable();
      final clause = where ?? link?.clause;
      String sql = 'DELETE FROM TIMESHEET ';
      if (where != null) sql = '$sql WHERE $clause';
      return await SQL.SqliteController.database.rawDelete(sql);
   }
   ///- **************** END Sqlite C.R.U.D.  {Create, Read, Update, Delete}
   ///- **************** BEGINS Sqlite C.R.U.D. for linked records

   ///- SQLCreate Creates Linked Records
   Future<SQL.SQLiteLink> createLink({SQL.SQLiteLink sqlLink}) async {
      sqlLink ??= SQL.SQLiteLink(tableName: 'timesheet');
      this.rowid = await create(link: sqlLink);
      final childLink = SQL.SQLiteLink(rowid:this.rowid, tableName: className);
      return childLink;  //- Returning link to root/base object (aka "key" for future use)
   }

   ///- SQLRead Read all linked records
   static Future<List<Timesheet>> readLink({SQL.SQLiteLink sqlLink, String whereClause, String orderBy}) async {
      String where = (sqlLink?.tableName == 'timesheet') ? '(rowid = ${sqlLink.rowid})' : sqlLink?.clause;
      where ??= whereClause;
      List<Timesheet> list = await read(whereClause: where, orderBy: orderBy);
      return list;
   }

   ///- SQLReadRoot Read all linked records based on root-key
   static Future<Timesheet> readRoot({SQL.SQLiteLink sqlLink}) async {
      assert(sqlLink != null);
      String clause = '(rowid = ${sqlLink.rowid})';
      List<Timesheet> list = await readLink(whereClause: clause);
      if (list == null || list.length != 1) throw SQL.SQLiteRecordNotFoundException('Cannot find record: $clause', 400);
      return list[0];
   }

   ///- SQLUpdate update all linked records
   Future<void> updateLink({SQL.SQLiteLink sqlLink}) async {
      await update(link: sqlLink);
      return null;
   }

   ///- SQLDelete delete all linked records
   Future<void> deleteLink({SQL.SQLiteLink sqlLink}) async {
      await delete(link: sqlLink);
      return null;
   }
   ///- **************** END Sqlite C.R.U.D. for linked records

   ///- **********
   ///- SQLite Create Table
   static Future<dynamic> createTable() async {
       if (!_createTableIfNeeded) return null;
       _createTableIfNeeded = false;
       final create = '''CREATE TABLE IF NOT EXISTS TIMESHEET (
          parentRowid INTEGER DEFAULT 0,
          parentTableName TEXT DEFAULT '',
          finish TEXT,
          jobid INTEGER,
          rate REAL,
          start TEXT
          )''';

       await SQL.SqliteController.database.execute(create);
       return null;
   }

   //- ******** Helpers
   //- Utility helpers

   ///- SQL Count of records
   ///- Return count of records in timesheet
  Future<int> count(String clause) async {
    await createTable();
    final whereClause = (clause == null) ? '' : 'WHERE $clause';
    final sql = 'SELECT COUNT("rowid") FROM timesheet $whereClause';
    return Sqflite.firstIntValue(await SQL.SqliteController.database.rawQuery(sql));
  }

   ///- SQL First record of query
   ///- Return first record of sql query
  static Future<Timesheet> firstRecord({String where, String orderBy = 'rowid asc limit 1'}) async {
    await createTable();
    if (orderBy == null) throw Exception('static first - orderBy string null');
    List<Timesheet> results = await readLink(whereClause: where, orderBy: orderBy);
    return (results != null && results.length > 0) ? results[0] : null;
  }
}
