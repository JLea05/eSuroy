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
    final tableNames = List<String>.filled(8, "");

    final fileNames = List<String>.filled(8, "");
    tableNames.setAll(0, [
      'activities',
      'deals',
      'hotel',
      'hotelAssoc',
      'ids',
      'placeName',
      'restaurants',
      'resAssoc',
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
    ]);

    for (var i = 0; i < fileNames.length; i++) {
      final csvName = fileNames[i];
      final tableName = tableNames[i];
      await _initTable(csvfilename: csvName, tablename: tableName);
    }
  }

  static Future<void> _initTable(
      {required String tablename, required String csvfilename}) async {
    String parse = await rootBundle.loadString('assets/csv/$csvfilename.csv');
    var exist =
        await db!.rawQuery('SELECT * FROM sqlite_master WHERE name="hotel"');

    if (exist.isEmpty) {
      debugPrint('Created Table hotel!');
      await db!.execute(
          'CREATE TABLE hotel (id_hotel INTEGER, hotelName TEXT, min INTEGER, max INTEGER, lat REAL, long REAL, url TEXT, contact TEXT)');
    }
    //await db.delete('rating');
    var feedbackTable =
        await db!.rawQuery('SELECT * FROM sqlite_master WHERE name="rating"');
    if (feedbackTable.isEmpty) {
      debugPrint('Created rating table!');
      await db!.execute(
          'CREATE TABLE rating (name TEXT, phone TEXT, email TEXT, message TEXT, rating REAL, hotelName TEXT)');
    }

    //await db.delete('deals');
    //await db.delete('hotel');
    var count = await db!.query('hotel');

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
        await db!.insert('hotel', c);
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
