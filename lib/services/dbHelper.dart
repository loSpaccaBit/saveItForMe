import 'package:flutter/foundation.dart';
import 'package:save_it_forme/models/bookMark.dart';
import 'package:save_it_forme/models/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "bookMark.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Category(id_category INTEGER PRIMARY KEY AUTOINCREMENT, titolo TEXT NOT NULL);');
      await db.execute(
          'CREATE TABLE BookMark(id_bookMark INTEGER PRIMARY KEY AUTOINCREMENT, titolo TEXT NOT NULL, url TEXT NOT NULL, descrizione TEXT NOT NULL, id_category INTEGER, FOREIGN KEY(id_category) REFERENCES Category(id_category));');
      await db.execute('INSERT INTO Category(titolo) VALUES (\'Main\')');
    }, version: _version);
  }

  static Future<int> addCategory(CategoryMark category) async {
    final db = await _getDB();
    return await db.insert("Category", category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addBookMark(BookMark bookMark) async {
    final db = await _getDB();
    return await db.insert("BookMark", bookMark.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateCategory(CategoryMark category) async {
    final db = await _getDB();
    return await db.update("Category", category.toJson(),
        where: 'id_category = ?',
        whereArgs: [category.id_category],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateBookMark(BookMark bookMark) async {
    final db = await _getDB();
    return await db.update("BookMark", bookMark.toJson(),
        where: 'id_bookMark = ?',
        whereArgs: [bookMark.id_bookMark],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteCategory(CategoryMark category) async {
    final db = await _getDB();
    return await db.delete("Category",
        where: 'id_category = ?', whereArgs: [category.id_category]);
  }

  static Future<int> deleteBookMark(BookMark bookMark) async {
    final db = await _getDB();
    return await db.delete("BookMark",
        where: 'id_bookMark = ?', whereArgs: [bookMark.id_bookMark]);
  }

  static Future<List<CategoryMark>?> getAllCategory() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("Category");
    print(maps);
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => CategoryMark.fromJson(maps[index]));
  }

  static Future<List<BookMark>?> getAllBookMark() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("BookMark");
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => BookMark.fromJson(maps[index]));
  }
}
