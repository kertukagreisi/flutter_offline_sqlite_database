import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Number.dart';

class SqliteService {
  static Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'numbers_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE numbers(id TEXT PRIMARY KEY, number INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<List<Number>> getNumbers() async {
    final db = await SqliteService.initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('numbers');

    return List.generate(maps.length, (i) {
      return Number(
        id: maps[i]['id'],
        number: maps[i]['number'],
      );
    });
  }

  static Future<void> insertNumber(int number) async {
    final db = await SqliteService.initializeDB();
    Number numberToBeInserted =
        Number(id: Number.getUniqueId(), number: number);
    await db.insert(
      'numbers',
      numberToBeInserted.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateNumber(Number number) async {
    final db = await SqliteService.initializeDB();
    await db.update(
      'numbers',
      number.toMap(),
      where: 'id = ?',
      whereArgs: [number.id],
    );
  }

  static Future<void> deleteNumber(String id) async {
    final db = await SqliteService.initializeDB();
    await db.delete(
      'numbers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
