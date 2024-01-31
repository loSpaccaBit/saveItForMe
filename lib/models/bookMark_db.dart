import 'package:sqflite/sqflite.dart';
import 'package:save_it_forme/database/database_services.dart';
import 'bookMark.dart';

class BookMarkDB {
  final tableName = "bookMark";

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS ${tableName}(
      id INT AUTO_INCREMENT PRIMARY KEY,
      url TEXT NOT NULL,
      titolo TEXT NOT NULL
    );""");
  }
}
