import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'eng_dictionary.db';
  static final _databaseVersion = 1;
  static var table = 'av';
  static final columnID = '_id';
  static final columnWord = 'word';
  static final columnHtml = 'html';
  static final columnDescription = 'description';
  static final columnPronounce = 'pronounce';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

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

    var exsts = await databaseExists(path);
    if (!exsts) {
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

  static void setToAV() {
    table = 'av';
  }

  static void setToVA() {
    table = 'va';
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<void> insertIntoHistory(String word) async {
    Database? db = await instance.database;
    var result = await db!.rawQuery("INSERT INTO history(_word) VALUES(\"" + word + "\")");
  }

  Future<void> DeleteHistory() async {
    Database? db = await instance.database;
    var result = await db!.rawQuery("DELETE FROM history");
  }

  Future<List> getAllWordMeaing() async {
    Database? db = await instance.database;
    var result = await db!.query(table);
    return result.toList();
  }

  Future<List> getRandomWord() async {
    Database? db = await instance.database;
    var result = await db!.rawQuery('SELECT * FROM av ORDER BY RANDOM() LIMIT 5');
    return result.toList();
  }

  Future<List> getHistoryWord() async {
    Database? db = await instance.database;
    var result = await db!.rawQuery('SELECT av.word, av.description, av.html, av.pronounce FROM history, av WHERE history._word = av.word ORDER BY _idHistory DESC LIMIT 30');
    return result.toList();
  }

  Future<int?> getCount() async {
    var db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(_id) FROM $table'));
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

  Future<List> getSuggestionWordSearching(String word) async {
    Database? db = await instance.database;
    var result = await db!.rawQuery('SELECT * FROM ' + table + ' WHERE word like \'$word%\' LIMIT 20');
    return result.toList();
  }
}