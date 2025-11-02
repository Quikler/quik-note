import 'package:flutter/foundation.dart';
import 'package:quik_note/pages/pages_enum.dart';
class NavigationViewModel extends ChangeNotifier {
  PagesEnum _currentPage = PagesEnum.notes;
  PagesEnum get currentPage => _currentPage;
  bool get isNotesPage => _currentPage == PagesEnum.notes;
  bool get isTodosPage => _currentPage == PagesEnum.todos;
  String get fabTooltip {
    return switch (_currentPage) {
      PagesEnum.notes => 'Add note',
      PagesEnum.todos => 'Add todo',
    };
  }
  void navigateTo(PagesEnum page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }
  void navigateToNotes() {
    navigateTo(PagesEnum.notes);
  }
  void navigateToTodos() {
    navigateTo(PagesEnum.todos);
  }
  @override
  void dispose() {
    _currentPage = PagesEnum.notes;
    super.dispose();
  }
}
