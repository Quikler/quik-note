import 'package:flutter/material.dart';
import 'package:quik_note/pages/create_note_form_page.dart';
import 'package:quik_note/pages/create_todo_form_page.dart';
import 'package:quik_note/pages/pages_enum.dart';
import 'package:quik_note/widgets/notes_list.dart';
import 'package:quik_note/widgets/todos_list.dart';

class CurrentPage {
  Widget? widget;
  PagesEnum pageEnum;
  Widget? formPageToNavigate;
  String? navigateTooltip;

  CurrentPage(
    this.widget,
    this.pageEnum,
    this.formPageToNavigate,
    this.navigateTooltip,
  );
}

class CurrentPageModel extends ChangeNotifier {
  CurrentPage? currentPage;

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

  CurrentPage _switchPagesEnum(PagesEnum pagesEnum) {
    switch (pagesEnum) {
      case PagesEnum.notes:
        return CurrentPage(
          NotesList(),
          PagesEnum.notes,
          CreateNoteFormPage(),
          'Add note',
        );
      case PagesEnum.todos:
        return CurrentPage(
          TodosList(),
          PagesEnum.todos,
          CreateTodoFormPage(),
          'Add todo',
        );
    }
  }
}
