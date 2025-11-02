import 'package:quik_note/core/result.dart';
import 'package:quik_note/models/note.dart';
abstract interface class NoteRepository {
  Future<Result<Note>> create(Note note);
  Future<Result<List<Note>>> getAll({String? where, List<Object?>? whereArgs});
  Future<Result<List<Note>>> getStarred();
  Future<Result<Note?>> getById(int id);
  Future<Result<Note>> update(Note note);
  Future<Result<bool>> delete(int id);
  Future<Result<int>> deleteMany(List<int> ids);
}
