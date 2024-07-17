import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:save_it_forme/models/bookMark.dart';
import 'package:save_it_forme/models/category.dart';
import 'package:save_it_forme/models/backupModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

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

  static Future<List<BookMark>?> getAllBookMarkByCategory(
      CategoryMark categoryMark) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM BookMark WHERE id_category = ${categoryMark.id_category}');
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => BookMark.fromJson(maps[index]));
  }

  static Future<int> countAllBookMarkByCategory(
      CategoryMark categoryMark) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM BookMark WHERE id_category = ${categoryMark.id_category}',
    );

    print(result);

    if (result.isEmpty || result[0]['count'] == null) {
      return 0;
    }

    int count = result[0]['count'];
    print(count);
    return count;
  }

  static Future<void> loadBackupData(BackUpData backupData) async {
    try {
      // Carica le categorie
      List<CategoryMark>? categories = backupData.category != null
          ? List<CategoryMark>.from(backupData.category
              .map((category) => CategoryMark.fromJson(category)))
          : null;
      if (categories != null) {
        for (var category in categories) {
          await addCategory(category);
        }
      }

      // Carica i segnalibri
      List<BookMark>? bookmarks = backupData.bookMark != null
          ? List<BookMark>.from(backupData.bookMark
              .map((bookmark) => BookMark.fromJson(bookmark)))
          : null;
      if (bookmarks != null) {
        for (var bookmark in bookmarks) {
          await addBookMark(bookmark);
        }
      }

      print('Dati del backup caricati correttamente nel database.');
    } catch (e) {
      print(
          'Errore durante il caricamento dei dati del backup nel database: $e');
    }
  }

  static Future<void> exportAllDB() async {
    try {
      final db = await _getDB();
      dynamic _category = await getAllCategory();
      dynamic _bookMark = await getAllBookMark();
      BackUpData backUpData =
          BackUpData(category: _category, bookMark: _bookMark);
      String jsonData = jsonEncode(backUpData.toJson());

      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String filePath = '${documentsDirectory.path}/backup_data.json';

      File jsonFile = File(filePath);
      await jsonFile.writeAsString(jsonData);
      // await FileSaver.instance
      //     .saveFile(name: 'backup_saveit_forme', file: jsonFile);
      Fluttertoast.showToast(
          msg: "Backup salvato con successo!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print('File JSON saved successfully at: $filePath');
    } catch (e) {
      print('Error exporting data: $e');
      Fluttertoast.showToast(
          msg: "Errore durante il salvataggio del backup: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Ottieni il percorso del file selezionato
        String filePath = result.files.single.path!;

        // Leggi il contenuto del file JSON
        String fileContent = await File(filePath).readAsString();

        // Decodifica il contenuto JSON in un oggetto BackUpData
        BackUpData backupData = BackUpData.fromJson(jsonDecode(fileContent));

        // Carica i dati del backup nel database
        await loadBackupData(backupData);

        print('File JSON letto e dati del database caricati correttamente.');
        Fluttertoast.showToast(
            msg: "Dati del backup caricati con successo!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        // L'utente ha annullato la selezione del file
        print('Selezione del file annullata.');
        Fluttertoast.showToast(
            msg: "Selezione del file annullata.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print('Errore durante la selezione del file o caricamento dei dati: $e');
      Fluttertoast.showToast(
          msg:
              "Errore durante la selezione del file o caricamento dei dati: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
