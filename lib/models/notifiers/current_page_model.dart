import 'package:flutter/material.dart';
import 'package:quik_note/pages/pages_enum.dart';
import 'package:quik_note/widgets/notes_list.dart';
import 'package:quik_note/widgets/todos_list.dart';

class CurrentPageModel extends ChangeNotifier {
  Widget? currentPage;

  void initPage(PagesEnum page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    currentPage = _switchPagesEnum(page);
  }

  void changePage(PagesEnum newPage) {
    currentPage = _switchPagesEnum(newPage);
    notifyListeners();
  }

  Widget _switchPagesEnum(PagesEnum pagesEnum) {
    switch (pagesEnum) {
      case PagesEnum.notes:
        return NotesList();
      case PagesEnum.todos:
        return TodosList();
    }
  }
}
