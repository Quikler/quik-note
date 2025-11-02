import 'package:flutter/foundation.dart';
import 'package:quik_note/core/result.dart';
abstract class BaseListViewModel<T> extends ChangeNotifier {
  List<T> _items = [];
  List<T> _filteredItems = [];
  Set<int> _selectedItemIds = {};
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSearchMode = false;
  List<T> get items => List.unmodifiable(_items);
  List<T> get filteredItems => List.unmodifiable(_filteredItems);
  List<T> get displayedItems =>
      _isSearchMode ? List.unmodifiable(_filteredItems) : items;
  Set<int> get selectedItemIds => Set.unmodifiable(_selectedItemIds);
  Set<int> get selectedNoteIds =>
      selectedItemIds;
  Set<int> get selectedTodoIds =>
      selectedItemIds;
  List<T> get displayedNotes =>
      displayedItems;
  List<T> get displayedTodos =>
      displayedItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSearchMode => _isSearchMode;
  bool get hasSelection => _selectedItemIds.isNotEmpty;
  int get selectedCount => _selectedItemIds.length;
  @protected
  int? getItemId(T item);
  @protected
  bool matchesSearchQuery(T item, String lowerCaseQuery);
  @protected
  dynamic get repository;
  @protected
  void setItems(List<T> items) {
    _items = items;
    _filteredItems = List.from(items);
    _isSearchMode = false;
  }
  @protected
  void addItem(T item) {
    _items = [item, ..._items];
    _filteredItems = [item, ..._filteredItems];
  }
  @protected
  void removeItemById(int id) {
    _items.removeWhere((item) => getItemId(item) == id);
    _filteredItems.removeWhere((item) => getItemId(item) == id);
    _selectedItemIds.remove(id);
  }
  @protected
  void updateItemInList(T updatedItem) {
    final id = getItemId(updatedItem);
    if (id == null) return;
    final index = _items.indexWhere((item) => getItemId(item) == id);
    if (index != -1) {
      _items[index] = updatedItem;
    }
    final filteredIndex = _filteredItems.indexWhere(
      (item) => getItemId(item) == id,
    );
    if (filteredIndex != -1) {
      _filteredItems[filteredIndex] = updatedItem;
    }
  }
  Future<void> load() async {
    _setLoading(true);
    _clearError();
    await loadItems();
    _setLoading(false);
  }
  @protected
  Future<void> loadItems();
  Future<bool> deleteById(int id) async {
    _clearError();
    final result = await performDelete(id);
    return result.when(
      success: (deleted) {
        if (deleted) {
          removeItemById(id);
          notifyListeners();
        }
        return deleted;
      },
      failure: (error, _) {
        _setError('Failed to delete item: ${error.toString()}');
        return false;
      },
    );
  }
  @protected
  Future<Result<bool>> performDelete(int id);
  Future<bool> deleteSelected() async {
    if (_selectedItemIds.isEmpty) return false;
    _clearError();
    final ids = _selectedItemIds.toList();
    final result = await performDeleteMany(ids);
    return result.when(
      success: (count) {
        for (final id in ids) {
          removeItemById(id);
        }
        _selectedItemIds.clear();
        notifyListeners();
        return count > 0;
      },
      failure: (error, _) {
        _setError('Failed to delete items: ${error.toString()}');
        return false;
      },
    );
  }
  @protected
  Future<Result<int>> performDeleteMany(List<int> ids);
  Future<bool> createItem(T item) async {
    _clearError();
    final result = await performCreate(item);
    return result.when(
      success: (createdItem) {
        addItem(createdItem);
        notifyListeners();
        return true;
      },
      failure: (error, _) {
        _setError('Failed to create item: ${error.toString()}');
        return false;
      },
    );
  }
  @protected
  Future<Result<T>> performCreate(T item);
  Future<bool> updateItem(T item) async {
    _clearError();
    final result = await performUpdate(item);
    return result.when(
      success: (updatedItem) {
        updateItemInList(updatedItem);
        notifyListeners();
        return true;
      },
      failure: (error, _) {
        _setError('Failed to update item: ${error.toString()}');
        return false;
      },
    );
  }
  @protected
  Future<Result<T>> performUpdate(T item);
  void search(String query) {
    if (query.isEmpty) {
      _isSearchMode = false;
      _filteredItems = _items;
    } else {
      _isSearchMode = true;
      final lowerQuery = query.toLowerCase();
      _filteredItems = _items.where((item) {
        return matchesSearchQuery(item, lowerQuery);
      }).toList();
    }
    notifyListeners();
  }
  void clearSearch() {
    _isSearchMode = false;
    _filteredItems = _items;
    notifyListeners();
  }
  void toggleItemSelection(int itemId) {
    if (_selectedItemIds.contains(itemId)) {
      _selectedItemIds.remove(itemId);
    } else {
      _selectedItemIds.add(itemId);
    }
    notifyListeners();
  }
  bool isItemSelected(int itemId) {
    return _selectedItemIds.contains(itemId);
  }
  void clearSelection() {
    _selectedItemIds.clear();
    notifyListeners();
  }
  void selectAll() {
    _selectedItemIds = _items
        .map((item) => getItemId(item))
        .where((id) => id != null)
        .cast<int>()
        .toSet();
    notifyListeners();
  }
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  void _clearError() {
    _errorMessage = null;
  }
  @protected
  void setLoading(bool loading) => _setLoading(loading);
  @protected
  void setError(String message) => _setError(message);
  @protected
  void clearError() => _clearError();
  @override
  void dispose() {
    _items = [];
    _filteredItems = [];
    _selectedItemIds = {};
    super.dispose();
  }
  void toggleNoteSelection(int noteId) => toggleItemSelection(noteId);
  bool isNoteSelected(int noteId) => isItemSelected(noteId);
  Future<bool> deleteNote(int id) => deleteById(id);
  Future<bool> deleteSelectedNotes() => deleteSelected();
  void searchNotes(String query) => search(query);
  Future<bool> createNote(T note) => createItem(note);
  Future<bool> updateNote(T note) => updateItem(note);
  void toggleTodoSelection(int todoId) => toggleItemSelection(todoId);
  bool isTodoSelected(int todoId) => isItemSelected(todoId);
  Future<bool> deleteTodo(int id) => deleteById(id);
  Future<bool> deleteSelectedTodos() => deleteSelected();
  void searchTodos(String query) => search(query);
}
