import 'package:quik_note/core/note_cache.dart';
import 'package:quik_note/repositories/note_repository.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/core/result.dart';
class NoteFormService {
  final NoteRepository _repository;
  final NoteCache _cache;
  NoteFormService(this._repository, this._cache);
  Future<Note?> loadNoteForEdit(int noteId) async {
    if (_cache.has(noteId)) {
      return _cache.get(noteId);
    }
    final result = await _repository.getById(noteId);
    return result.when(
      success: (note) => note,
      failure: (_, __) => null,
    );
  }
  void cacheNoteDraft(Note note) {
    if (note.id != null) {
      _cache.set(note.id!, note);
    }
  }
  Note? getCachedNote(int noteId) {
    return _cache.get(noteId);
  }
  bool hasCachedChanges(int noteId) {
    return _cache.has(noteId);
  }
  bool shouldSaveNote(String? title, String? content) {
    final hasTitle = title != null && title.trim().isNotEmpty;
    final hasContent = content != null && content.trim().isNotEmpty;
    return hasTitle || hasContent;
  }
  Future<Result> saveNote(Note note) async {
    final result = await _repository.update(note);
    return result.when(
      success: (updatedNote) {
        if (note.id != null) {
          _cache.remove(note.id!);
        }
        return Success(updatedNote);
      },
      failure: (error, stackTrace) {
        return Failure(error, stackTrace);
      },
    );
  }
  Future<Result> createNote(Note note) async {
    final result = await _repository.create(note);
    return result.when(
      success: (createdNote) {
        return Success(createdNote);
      },
      failure: (error, stackTrace) {
        return Failure(error, stackTrace);
      },
    );
  }
  Future<Result> deleteNote(int noteId) async {
    final result = await _repository.delete(noteId);
    _cache.remove(noteId);
    return result.when(
      success: (deleted) => Success(deleted),
      failure: (error, stackTrace) => Failure(error, stackTrace),
    );
  }
  void clearCache(int noteId) {
    _cache.remove(noteId);
  }
}
