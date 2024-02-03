import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class Utility {
  static Database? db;

  static Future<Database> initDatabase() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, 'esuroy.db');
    db = await openDatabase(path);
    return db!;
  }

  static Future<void> initTables() async {
    final tableNames = List<String>.filled(9, "");

    final fileNames = List<String>.filled(9, "");
    tableNames.setAll(0, [
      'activities',
      'deals',
      'hotel',
      'hotelAssoc',
      'ids',
      'placeName',
      'restaurants',
      'resAssoc',
      'rating'
    ]);
    fileNames.setAll(0, [
      'activities',
      'deals',
      'hotel',
      'hotelAssoc',
      'id',
      'placeName',
      'restaurant',
      'restaurantAssoc',
      'NULL',
    ]);

    for (var i = 0; i < tableNames.length; i++) {
      final csvName = fileNames[i];
      final tableName = tableNames[i];
      await _createTable(index: i, tablename: tableName);
      await _initTable(
          csvfilename: csvName,
          tablename: tableName,
          doInit: i != tableNames.length - 1);
    }
  }

  static Future<void> _createTable(
      {required int index, required String tablename}) async {
    debugPrint('Creating tables...');
    String schema = await rootBundle.loadString('assets/text/schema.txt');
    final parsed = schema.split('\n');
    var exist = await db!
        .rawQuery('SELECT * FROM sqlite_master WHERE name="$tablename"');

    if (exist.isEmpty) {
      debugPrint('Created Table $tablename!');
      await db!.execute(parsed[index]);
    }
  }

  static Future<void> _initTable(
      {required String tablename,
      required String csvfilename,
      required bool doInit}) async {
    if (!doInit) return;

    String parse = await rootBundle.loadString('assets/csv/$csvfilename.csv');
    parse = parse.substring(0, parse.length - 1);
    //await db.delete('rating');

    //await db.delete('deals');
    //await db.delete('hotel');
    var count = await db!.query(tablename);

    if (count.isEmpty) {
      List<Map<String, dynamic>> map = [];
      var columName = parse.split('\n').first.split(',');

      parse.split('\n').forEach((line) {
        int index = 0;
        line = line.replaceAll(RegExp(r'"'), '');

        debugPrint('Line: $line');
        Map<String, dynamic> l = {};
        line.split(',').forEach((str) {
          l[columName[index]] = str;
          debugPrint('Content: $str');
          debugPrint('SQL: ${columName[index]} : ${str.toString()}');

          index++;
        });
        map.add(l);
      });

      map.removeAt(0);
      for (var c in map) {
        await db!.insert(tablename, c);
        debugPrint('INSERT: $c');
      }
      debugPrint('Insert Success!');
    } else {
      count.forEach((element) {
        debugPrint(element.toString());
      });
    }
  }
}
