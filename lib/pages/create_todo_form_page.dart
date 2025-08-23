import 'package:flutter/material.dart';
import 'package:quik_note/data/db_todo.dart';
import 'package:quik_note/forms/create_todo_form.dart';
import 'package:quik_note/models/todo.dart';
import 'package:quik_note/utils/helpers.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/viewmodels/checkbox_textfield_vm.dart';
import 'package:quik_note/wrappers/note_form_wrapper.dart';
import 'package:quik_note/wrappers/responsive_text.dart';

import 'package:quik_note/wrappers/main_wrapper.dart';

class CreateTodoFormPage extends StatefulWidget {
  const CreateTodoFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTodoFormPageState();
}

class _CreateTodoFormPageState extends State<CreateTodoFormPage> {
  static const String _untitled = "Untitled";
  String _appTitle = _untitled;
  bool _isSaveButtonVisible = false;

  CheckboxTextfieldVm? _firstVm;
  List<CheckboxTextfieldVm> _checkBoxChildren = <CheckboxTextfieldVm>[];

  final FocusNode contentFocusNode = FocusNode();

  void _handleBackButtonPressed() => _pop();
  void _handleSaveButtonPressed() => _pop();
  void _pop() => Navigator.maybePop(context);

  void _handlePopOfPopScope(bool didPop, Object? result) async {
    await _insertNewTodoWithPop();
  }

  void _handleOnFieldsChange(
    CheckboxTextfieldVm firstVm,
    List<CheckboxTextfieldVm> checkBoxChildren,
  ) {
    print("\n_handleOnFielsChange");
    print("First vm ${firstVm.title}");
    print(
      "CheckboxChildren ${checkBoxChildren.map((child) => child.title).join(", ")}",
    );
    print("\n=================================");

    setState(() {
      final title = firstVm.title;
      if (!title.isNullOrWhiteSpace) {
        _isSaveButtonVisible = true;
        _appTitle = title ?? "";
      } else {
        _appTitle = _untitled;
      }
    });

    _firstVm = firstVm;
    _checkBoxChildren = checkBoxChildren;
  }

  Future<void> _insertNewTodoWithChildren() async {
    final title = _firstVm!.title;
    if (title.isNullOrWhiteSpace) {
      return;
    }

    //final todoModel = context.read<CreateTodoModel>();
    //final firstVm = todoModel.firstCheckBox;
    if (_firstVm == null) {
      return;
    }

    final newTodo = Todo(null, _firstVm!.title!, null, _firstVm!.isChecked);
    final newTodoId = await insertTodo(newTodo);

    if (mounted) {
      var childrenOfTodo = _checkBoxChildren
          .where(
            (checkBoxChild) =>
                !checkBoxChild.isDisabled && !checkBoxChild.isTextEmpty(),
          )
          .map((checkBoxChild) => Todo(null, checkBoxChild.title!, newTodoId))
          .toList();

      await insertTodos(childrenOfTodo);
    }

    //if (mounted) {
    //context.read<NotesListModel>().insertStartNote(newNoteWithId);
    //}
  }

  Future<void> _insertNewTodoWithPop() async {
    await _insertNewTodoWithChildren();
    _pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _handlePopOfPopScope,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: noteFormPageAppBarHeight(),
          actions: [
            // The rightest button in actions
            Visibility(
              visible: _isSaveButtonVisible,
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: IconButton(
                  iconSize: 24,
                  onPressed: _handleSaveButtonPressed,
                  icon: Icon(Icons.check),
                ),
              ),
            ),
          ],
          leading: BackButton(
            style: ButtonStyle(iconSize: WidgetStatePropertyAll(24)),
            onPressed: _handleBackButtonPressed,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff5E00FF), Color(0x59380099)],
              ),
            ),
          ),
          title: ResponsiveText(_appTitle),
          foregroundColor: Colors.white,
        ),
        body: MainWrapper(
          child: SingleChildScrollView(
            child: NoteFormWrapper(
              child: CreateTodoForm(
                //titleController: _titleController,
                onFieldsChange: _handleOnFieldsChange,
                //contentController: _contentController,
                //contentFocusNode: contentFocusNode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
