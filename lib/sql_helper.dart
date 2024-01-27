import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'commend_model.dart';

class SQLHelper {

  // create table
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE commends(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        email TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  //create database
  static Future<Database> db() async {
    return openDatabase(
      'dbtech.db',
      version: 1,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  //insert data
  static Future<int> createItem(CommendModel model) async {
    final db = await SQLHelper.db();

    final data = model.toMap();
    final id = await db.insert('commends', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  //get all data
  static Future<List<CommendModel>> getItems() async {
    final db = await SQLHelper.db();
    List<Map<String, Object?>> data = await db.query('commends');
    return data.map((e) => CommendModel.valueFromDatabase(e)).toList();
  }

  //get by id
  static Future<CommendModel> getItem(int id) async {
    final db = await SQLHelper.db();
    var data = await db.query('commends', where: "id = ?", whereArgs: [id], limit: 1);
    return data.map((e) => CommendModel.valueFromDatabase(e)).toList().first;
  }

  // Update an item by id
  static Future<int> updateItem(CommendModel model) async {
    final db = await SQLHelper.db();

    final data = model.toMap();

    final result = await db.update('commends', data, where: "id = ?", whereArgs: [model.id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("commends", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}