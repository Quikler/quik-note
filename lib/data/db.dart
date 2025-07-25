import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:quik_note/models/note.dart';

Future<Database> getNotesDb() async {
  return openDatabase(
    join(await getDatabasesPath(), 'notes.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, creationTime DATETIME DEFAULT current_timestamp, lastEditedTime DATETIME)',
      );
    },
    version: 1,
  );
}

Future<int> insertNote(Note note) async {
  final db = await getNotesDb();

  return await db.insert('notes', note.toMap());
}

Future<List<Note>> getNotes() async {
  final db = await getNotesDb();

  final List<Map<String, Object?>> noteMaps = await db.query(
    'notes',
    orderBy: 'COALESCE(lastEditedTime, creationTime) desc',
  );

  return [
    for (final {
          'id': id as int,
          'title': title as String?,
          'content': content as String?,
          'creationTime': creationTime as String,
          'lastEditedTime': lastEditedTime as String?,
        }
        in noteMaps)
      Note(
        id,
        title,
        content,
        DateTime.parse(creationTime),
        lastEditedTime == null ? null : DateTime.parse(lastEditedTime),
      ),
  ];
}

Future<int> updateNote(Note note) async {
  final db = await getNotesDb();

  return await db.update(
    'notes',
    note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
  );
}

Future<int> deleteNote(int id) async {
  final db = await getNotesDb();

  return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
}
