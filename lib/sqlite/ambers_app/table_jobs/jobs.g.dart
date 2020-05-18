import 'package:flutter/foundation.dart';

/// AUTO-GENERATED CODE - DO NOT MODIFY
/// Created: May 16,2020 22:30(utc)

import 'package:sqflite/sqflite.dart';
import 'package:flutter_sqlite_controller/flutter_sqlite_controller.dart' as SQL;

///- Class declaration
class Jobs extends SQL.SQLParse<Jobs> {
  /// Class and Column keys
  static const String columnParentTableName = 'parentTableName';
  static const String columnParentRowid = 'parentRowid';
  static const String columnDescription = 'description'; // details of the job
  static const String columnName = 'name'; // job name
  static const String columnRate = 'rate'; // pay rate of the job

  ///- Property/Column declarations
  static bool _createTableIfNeeded = true; //Safety check to avoid repeatedly creating the Jobs table

  String _description; // details of the job
  String get description => _description;
  setDescription(String newValue) => _description = newValue;

  String _name; // job name
  String get name => _name;
  setName(String newValue) => _name = newValue;

  double _rate; // pay rate of the job
  double get rate => _rate;
  setRate(double newValue) => _rate = newValue;

  ///- ToJson
  Map<String, dynamic> toJson() => {
        'description': description,
        'name': name,
        'rate': rate,
      };

  ///- ToCloud
  Map<String, dynamic> toCloud() => {
        'description': description,
        'name': name,
        'rate': rate,
      };

  ///- Static constructors
  static Jobs build(dynamic data) {
    if (data == null) return null;
    if (data is Map) return Jobs.fromJson(data);
    if (data is Jobs) return data;
    throw Exception('static JobsBuild could not parse: ${data.toString()}');
  }

  ///- buildArray
  static List<Jobs> buildArray(List<dynamic> array) {
    List<Jobs> result = List();
    if (array == null) return result;
    if (array is List<Map<String, dynamic>>) {
      for (Map<String, dynamic> item in array) {
        if (item['parentTableName'] == null) {
          result.add(Jobs.fromCloud(item));
        } else {
          result.add(Jobs.fromJson(item));
        }
      }
      return result;
    }
    if (array is List<Jobs>) {
      for (Jobs item in array) {
        result.add(item);
      }
      return result;
    }
    throw Exception('Unknown datatype $array');
  }

  ///- Constructor
  Jobs({
    int parentRowid,
    String parentTableName,
    String description,
    String name,
    double rate,
  }) {
    this.parentRowid = parentRowid;
    this.parentTableName = parentTableName;
    setDescription(description);
    setName(name);
    setRate(rate);
  }

  ///- Factory fromJson
  factory Jobs.fromJson(Map<String, dynamic> json) {
    var _instance = Jobs(
      parentRowid: json['parentRowid'] ?? 0,
      parentTableName: json['parentTableName'] ?? '',
      description: json['description'],
      name: json['name'],
      rate: json['rate'],
    );
    return _instance;
  }

  ///- Factory from Cloud
  factory Jobs.fromCloud(Map<String, dynamic> json) {
    var _instance = Jobs(
      description: json['description'],
      name: json['name'],
      rate: json['rate'],
    );
    return _instance;
  }

  ///- **************** BEGIN Sqlite C.R.U.D.  {Create, Read, Update, Delete}

  ///- SQLite Create
  Future<int> create({@required SQL.SQLiteLink link}) async {
    await createTable();
    this.parentRowid = link.rowid;
    this.parentTableName = link.tableName;
    final sql = '''INSERT INTO JOBS
     (
         parentRowid,
         parentTableName,
         description,
         name,
         rate
     )
     VALUES
     (
         ${link.rowid},
         "${link.tableName}",
         "$_description",
         "$_name",
         $_rate
     )''';

    int newRowid = await SQL.SqliteController.database.rawInsert(sql);
    this.rowid = newRowid;
    return this.rowid;
  }

  ///- SQLite Read
  static Future<List<Jobs>> read({SQL.SQLiteLink link, String whereClause, String orderBy = 'rowid'}) async {
    await createTable();
    final clause = whereClause ?? link?.clause;
    String sql = 'SELECT rowid,* from JOBS';
    if (clause != null) sql += ' WHERE $clause';
    if (orderBy != null) sql += ' ORDER BY $orderBy';
    List<Map<String, dynamic>> maps = await SQL.SqliteController.database.rawQuery(sql).catchError((error, stack) {
      throw Exception(error.toString());
    });
    List<Jobs> results = List();
    for (Map<String, dynamic> map in maps) {
      final result = Jobs.fromJson(map);
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
    final sql = '''UPDATE JOBS
     SET
       parentRowid = $parentRowid,
       parentTableName = "$parentTableName",
       description = "$description",
       name = "$name",
       rate = $rate
     WHERE $clause''';

    return await SQL.SqliteController.database.rawUpdate(sql);
  }

  ///- Create Delete
  Future<int> delete({SQL.SQLiteLink link, String where}) async {
    await createTable();
    final clause = where ?? link?.clause;
    String sql = 'DELETE FROM JOBS ';
    if (where != null) sql = '$sql WHERE $clause';
    return await SQL.SqliteController.database.rawDelete(sql);
  }

  ///- **************** END Sqlite C.R.U.D.  {Create, Read, Update, Delete}
  ///- **************** BEGINS Sqlite C.R.U.D. for linked records

  ///- SQLCreate Creates Linked Records
  Future<SQL.SQLiteLink> createLink({SQL.SQLiteLink sqlLink}) async {
    sqlLink ??= SQL.SQLiteLink(tableName: 'Jobs');
    this.rowid = await create(link: sqlLink);
    final childLink = SQL.SQLiteLink(rowid: this.rowid, tableName: className);
    return childLink; //- Returning link to root/base object (aka "key" for future use)
  }

  ///- SQLRead Read all linked records
  static Future<List<Jobs>> readLink({SQL.SQLiteLink sqlLink, String whereClause, String orderBy}) async {
    String where = (sqlLink?.tableName == 'Jobs') ? '(rowid = ${sqlLink.rowid})' : sqlLink?.clause;
    where ??= whereClause;
    List<Jobs> list = await read(whereClause: where, orderBy: orderBy);
    return list;
  }

  ///- SQLReadRoot Read all linked records based on root-key
  static Future<Jobs> readRoot({SQL.SQLiteLink sqlLink}) async {
    assert(sqlLink != null);
    String clause = '(rowid = ${sqlLink.rowid})';
    List<Jobs> list = await readLink(whereClause: clause);
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
    final create = '''CREATE TABLE IF NOT EXISTS JOBS (
          parentRowid INTEGER DEFAULT 0,
          parentTableName TEXT DEFAULT '',
          description TEXT,
          name TEXT,
          rate REAL
          )''';

    await SQL.SqliteController.database.execute(create);
    return null;
  }

  //- ******** Helpers
  //- Utility helpers

  ///- SQL Count of records
  ///- Return count of records in Jobs
  Future<int> count(String clause) async {
    await createTable();
    final whereClause = (clause == null) ? '' : 'WHERE $clause';
    final sql = 'SELECT COUNT("rowid") FROM Jobs $whereClause';
    return Sqflite.firstIntValue(await SQL.SqliteController.database.rawQuery(sql));
  }

  ///- SQL First record of query
  ///- Return first record of sql query
  static Future<Jobs> firstRecord({String where, String orderBy = 'rowid asc limit 1'}) async {
    await createTable();
    if (orderBy == null) throw Exception('static first - orderBy string null');
    List<Jobs> results = await readLink(whereClause: where, orderBy: orderBy);
    return (results != null && results.length > 0) ? results[0] : null;
  }
}
