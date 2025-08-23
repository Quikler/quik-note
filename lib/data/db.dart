import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getNotesDb() async {
  return openDatabase(
    join(await getDatabasesPath(), 'notes.db'),
    onCreate: (db, version) {
      return db.execute('''
            CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, starred BOOLEAN NOT NULL DEFAULT 0, creationTime DATETIME DEFAULT current_timestamp, lastEditedTime DATETIME);
            CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, parentId INTEGER, checked BOOLEAN NOT NULL DEFAULT 0, completed BOOLEAN NOT NULL DEFAULT 0);
        ''');
    },
    version: 1,
  );
}
