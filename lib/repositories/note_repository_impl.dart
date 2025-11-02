import 'package:quik_note/core/result.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/repositories/note_repository.dart';
final class NoteRepositoryImpl implements NoteRepository {
  const NoteRepositoryImpl();
  @override
  Future<Result<Note>> create(Note note) async {
    try {
      final db = await getNotesDb();
      final id = await db.insert('notes', note.toMap());
      final createdNote = note.copyWith(id: id);
      return Success(createdNote);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<List<Note>>> getAll({
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final db = await getNotesDb();
      final List<Map<String, Object?>> noteMaps = await db.query(
        'notes',
        orderBy: 'COALESCE(lastEditedTime, creationTime) desc',
        where: where,
        whereArgs: whereArgs,
      );
      final notes = noteMaps.map(_mapToNote).toList();
      return Success(notes);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<List<Note>>> getStarred() async {
    return getAll(where: 'starred = 1');
  }
  @override
  Future<Result<Note?>> getById(int id) async {
    try {
      final db = await getNotesDb();
      final List<Map<String, Object?>> noteMaps = await db.query(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (noteMaps.isEmpty) {
        return const Success(null);
      }
      return Success(_mapToNote(noteMaps.first));
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<Note>> update(Note note) async {
    try {
      final db = await getNotesDb();
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
      return Success(note);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<bool>> delete(int id) async {
    try {
      final db = await getNotesDb();
      final count = await db.delete('notes', where: 'id = ?', whereArgs: [id]);
      return Success(count > 0);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<int>> deleteMany(List<int> ids) async {
    try {
      if (ids.isEmpty) {
        return const Success(0);
      }
      final db = await getNotesDb();
      final count = await db.delete(
        'notes',
        where: 'id IN (${List.filled(ids.length, '?').join(',')})',
        whereArgs: ids,
      );
      return Success(count);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  Note _mapToNote(Map<String, Object?> map) {
    return Note.fromMap(map);
  }
}
