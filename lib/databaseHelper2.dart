// This database helper for Irregular Verb Feature
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper2 {
  static final _databaseName = 'irregular_verb_table.db';
  static final _databaseVersion = 1;
  static var table = 'word';
  static final columnID = '_id';
  static final columnV1 = 'v1';
  static final columnV2 = 'v2';
  static final columnV3 = 'v3';

  DatabaseHelper2._privateConstructor();
  static final DatabaseHelper2 instance = DatabaseHelper2._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) 
      return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);

    var exists = await databaseExists(path);
    if (!exists) {
      print("copying existing database...");

      try {
        await Directory(dirname(path)).create(recursive: true);
      }
      catch(_) { }

      ByteData data = await rootBundle.load(join('assets', _databaseName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }
    else {
      print('opening existing database...');
    }

    return await openDatabase(path, version: _databaseVersion);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }


  Future<List> getAllWord() async {
    Database? db = await instance.database;
    var result = await db!.query(table);
    return result.toList();
  }

  Future<int?> getCount() async {
    var db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(_id) FROM $table'));
  }

  Future<List> getSuggestionWordSearching(String text) async {
    Database? db = await instance.database;
    var result = await db!.rawQuery('SELECT * FROM ' + table + ' WHERE v1 like \'$text%\'');
    return result.toList();
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    String id = row[columnID];
    return await db!.update(table, row, where: '$columnID = ?', whereArgs: [id]);
  }

  Future<int> delete(String? iid) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnID = ?', whereArgs: [iid]);
  }
}