


// os
import 'dart:io';
import 'package:flutter/services.dart';

// 3rd
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Provider {
  static Database db;

  // 获取数据库中所有的表
  Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }

    List tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((element) {
      targetList.add(element['name']);
    });

    return targetList;
  }

  // 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTable() async {
    List<String> expectTables = ['cat', 'widget', 'collection'];

    List<String> tables = await getTables();

    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

  Future init(bool isCreated) async {
    
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'flutter_go.db');
    print(path);

    try {
      db = await openDatabase(path);
    } catch (e) {
      print("Error: $e");
    }

    bool isTableCorrect = await checkTable();
    if (!isTableCorrect) {
      db.close();
      await deleteDatabase(path);

      ByteData data = await rootBundle.load(join("assets", "app.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);

      db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
        print('db created version is $version');
      }, onOpen: (Database db) async {
        print('new db opened');
      });
    } else {
      print("open existing database success");
    }

   }

}

