import 'package:quik_note/core/result.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/repositories/note_repository.dart';
import 'package:quik_note/viewmodels/base_list_viewmodel.dart';
class NotesViewModel extends BaseListViewModel<Note> {
  final NoteRepository _repository;
  NotesViewModel(this._repository);
  @override
  NoteRepository get repository => _repository;
  @override
  int? getItemId(Note item) => item.id;
  @override
  bool matchesSearchQuery(Note item, String lowerCaseQuery) {
    final titleMatch =
        item.title?.toLowerCase().contains(lowerCaseQuery) ?? false;
    final contentMatch =
        item.content?.toLowerCase().contains(lowerCaseQuery) ?? false;
    return titleMatch || contentMatch;
  }
  @override
  Future<void> loadItems() async {
    final result = await _repository.getAll();
    result.when(
      success: (notes) {
        setItems(notes);
      },
      failure: (error, _) {
        setError('Failed to load notes: ${error.toString()}');
      },
    );
  }
  Future<void> loadNotes() async {
    await load();
  }
  Future<void> loadStarredNotes() async {
    setLoading(true);
    clearError();
    final result = await _repository.getStarred();
    result.when(
      success: (notes) {
        setItems(notes);
      },
      failure: (error, _) {
        setError('Failed to load starred notes: ${error.toString()}');
      },
    );
    setLoading(false);
  }
  @override
  Future<Result<bool>> performDelete(int id) async {
    return await _repository.delete(id);
  }
  @override
  Future<Result<int>> performDeleteMany(List<int> ids) async {
    return await _repository.deleteMany(ids);
  }
  @override
  Future<Result<Note>> performCreate(Note item) async {
    return await _repository.create(item);
  }
  @override
  Future<Result<Note>> performUpdate(Note item) async {
    return await _repository.update(item);
  }
  Future<bool> toggleStarred(Note note) async {
    final updatedNote = note.copyWith(starred: !note.starred);
    return updateItem(updatedNote);
  }
}
