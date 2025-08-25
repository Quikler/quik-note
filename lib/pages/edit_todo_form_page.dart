import 'package:flutter/material.dart';
import 'package:quik_note/data/db_todo.dart';
import 'package:quik_note/forms/create_todo_form.dart';
import 'package:quik_note/models/todo.dart';
import 'package:quik_note/utils/helpers.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/viewmodels/checkbox_textfield_vm.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';
import 'package:quik_note/wrappers/note_form_wrapper.dart';
import 'package:quik_note/wrappers/responsive_text.dart';

import 'package:quik_note/wrappers/main_wrapper.dart';

class EditTodoFormPage extends StatefulWidget {
  final TodoVm todo;

  const EditTodoFormPage({super.key, required this.todo});

  @override
  State<StatefulWidget> createState() => _EditTodoFormPageState();
}

class _EditTodoFormPageState extends State<EditTodoFormPage> {
  static const String _untitled = "Untitled";
  String _appTitle = _untitled;

  CheckboxTextfieldVm? _firstVm;
  final _checkBoxChildren = <CheckboxTextfieldVm>[];
  int _currChildIndex = 0;

  List<CheckboxTextfieldVm> _initialCheckBoxChildren = <CheckboxTextfieldVm>[];

  void _handleBackButtonPressed() => _pop();
  void _handleSaveButtonPressed() => _pop();
  void _pop() => Navigator.maybePop(context);
  void _handlePopOfPopScope(bool didPop, Object? result) async =>
      await _updateTodoWithPop();

  Future<void> _updateTodoWithChildren() async {
    if (_firstVm!.title.isNullOrWhiteSpace) {
      return;
    }

    final todoToUpdate = Todo(
      widget.todo.id,
      _firstVm!.title!,
      null,
      _firstVm!.isChecked,
    );

    await updateTodo(todoToUpdate);

    if (mounted) {
      final childrenOfTodo = _checkBoxChildren
          .where(
            (checkBoxChild) =>
                !checkBoxChild.isDisabled && !checkBoxChild.isTextEmpty(),
          )
          .map(
            (checkBoxChild) => Todo(
              checkBoxChild.id,
              checkBoxChild.title!,
              todoToUpdate.id,
              checkBoxChild.isChecked,
            ),
          )
          .toList();

      final childrenToUpdate = childrenOfTodo.where(
        (child) => child.id != null,
      );
      await updateTodos(childrenToUpdate);

      final childrenToAdd = childrenOfTodo.where((child) => child.id == null);
      await insertTodos(childrenToAdd);

      final initialChildrenOfTodo = _initialCheckBoxChildren.map(
        (initialCheckBoxChild) => Todo(
          initialCheckBoxChild.id,
          initialCheckBoxChild.title!,
          todoToUpdate.id,
          initialCheckBoxChild.isChecked,
        ),
      );

      for (var child in initialChildrenOfTodo) {
        if (!childrenOfTodo.contains(child)) {
          await deleteTodo(child.id!);
        }
      }
    }
  }

  Future<void> _updateTodoWithPop() async {
    await _updateTodoWithChildren();
    _pop();
  }

  _handleChildVmTextChanged(CheckboxTextfieldVm sender, String value) {
    // value not empty and child text is empty
    if (sender.isTextEmpty() && !value.isNullOrWhiteSpace) {
      setState(() {
        _checkBoxChildren[_currChildIndex].isDisabled = false;
        _currChildIndex++;

        final nextChild = CheckboxTextfieldVm(
          hint: "Todo something...",
          fontSize: 18,
        );
        nextChild.onTextChanged = (String val) =>
            _handleChildVmTextChanged(nextChild, val);
        nextChild.onChecked = (bool? checked) =>
            _handleCheckboxChecked(nextChild, checked);

        _checkBoxChildren.add(nextChild);
      });

      // value is empty -> remove child
    } else if (value.isNullOrWhiteSpace) {
      setState(() {
        final indexOfSender = _checkBoxChildren.indexOf(sender);
        _checkBoxChildren.removeAt(indexOfSender);
        _currChildIndex--;
      });
    }

    sender.title = value;
  }

  _handleFirstVmTextChanged(String value) {
    setState(() {
      if (!value.isNullOrWhiteSpace) {
        _appTitle = value;
      } else {
        _appTitle = _untitled;
      }
    });

    if (_firstVm!.isTextEmpty() && !value.isNullOrWhiteSpace) {
      setState(() {
        for (var i = 0; i < _currChildIndex + 1; i++) {
          _checkBoxChildren[i].isDisabled = false;
        }
        _currChildIndex++;

        // second child
        final nextChild = CheckboxTextfieldVm(
          hint: "Todo something...",
          fontSize: 18,
        );
        nextChild.onTextChanged = (String val) =>
            _handleChildVmTextChanged(nextChild, val);
        nextChild.onChecked = (bool? checked) =>
            _handleCheckboxChecked(nextChild, checked);

        _checkBoxChildren.add(nextChild);
      });
    } else if (!_firstVm!.isTextEmpty() && value.isNullOrWhiteSpace) {
      _checkBoxChildren.removeAt(_currChildIndex - 1);
      for (var child in _checkBoxChildren) {
        child.isDisabled = true;
      }

      _currChildIndex--;
    }

    _firstVm!.title = value;
  }

  _handleCheckboxChecked(CheckboxTextfieldVm sender, bool? checked) {
    setState(() {
      sender.isChecked = checked ?? false;
    });
  }

  @override
  void initState() {
    super.initState();

    _firstVm = CheckboxTextfieldVm(
      id: widget.todo.id,
      hint: "Title",
      isDisabled: false,
      fontSize: 24,
      onTextChanged: _handleFirstVmTextChanged,
      isChecked: widget.todo.checked,
      title: widget.todo.title,
    );
    _firstVm?.onChecked = (bool? checked) =>
        _handleCheckboxChecked(_firstVm!, checked);

    for (var child in widget.todo.children) {
      final childVm = CheckboxTextfieldVm(
        id: child.id,
        hint: "Todo something...",
        fontSize: 18,
        isChecked: child.checked,
        isDisabled: false,
        title: child.title,
      );
      childVm.onTextChanged = (String value) =>
          _handleChildVmTextChanged(childVm, value);
      childVm.onChecked = (bool? checked) =>
          _handleCheckboxChecked(childVm, checked);

      _checkBoxChildren.add(childVm);
    }

    _initialCheckBoxChildren = List.from(_checkBoxChildren);

    final emptyChild = CheckboxTextfieldVm(
      hint: "Todo something...",
      fontSize: 18,
      isDisabled: false,
    );
    emptyChild.onTextChanged = (String value) =>
        _handleChildVmTextChanged(emptyChild, value);
    emptyChild.onChecked = (bool? checked) =>
        _handleCheckboxChecked(emptyChild, checked);

    _checkBoxChildren.add(emptyChild);

    final disabledChild = CheckboxTextfieldVm(
      hint: "Todo something...",
      fontSize: 18,
    );
    disabledChild.onTextChanged = (String value) =>
        _handleChildVmTextChanged(disabledChild, value);
    disabledChild.onChecked = (bool? checked) =>
        _handleCheckboxChecked(disabledChild, checked);

    _checkBoxChildren.add(disabledChild);

    _currChildIndex = _checkBoxChildren.length - 1;

    _appTitle = _firstVm!.title!;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _handlePopOfPopScope,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: noteFormPageAppBarHeight(),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                iconSize: 24,
                onPressed: _handleSaveButtonPressed,
                icon: Icon(Icons.check),
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
                firstVm: _firstVm!,
                checkBoxChildren: _checkBoxChildren,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
