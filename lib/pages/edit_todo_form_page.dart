import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/core/todo_cache.dart';
import 'package:quik_note/forms/create_todo_form.dart';
import 'package:quik_note/viewmodels/todos_viewmodel.dart';
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
  final _todoCache = TodoCache();
  void _handleBackButtonPressed() => _pop();
  void _handleSaveButtonPressed() => _pop();
  void _pop() => Navigator.maybePop(context);
  void _handlePopOfPopScope(bool didPop, Object? result) async =>
      await _updateTodoWithPop();
  bool _filterChildren(CheckboxTextfieldVm checkBoxChild) =>
      !checkBoxChild.isDisabled && !checkBoxChild.isTextEmpty();
  TodoVm _buildCurrentTodoVm() {
    final childrenVm = _checkBoxChildren
        .where(_filterChildren)
        .map(
          (checkBoxChild) => TodoVm(
            id: checkBoxChild.id,
            title: checkBoxChild.title!,
            checked: checkBoxChild.isChecked,
            completed: false,
          ),
        )
        .toList();
    return widget.todo.copyWith(
      title: _firstVm!.title!,
      checked: _firstVm!.isChecked,
      children: childrenVm,
    );
  }
  void _updateCache() {
    if (widget.todo.id != null) {
      final currentTodo = _buildCurrentTodoVm();
      _todoCache.set(widget.todo.id!, currentTodo);
    }
  }
  Future<void> _updateTodoWithChildren() async {
    if (_firstVm!.title.isNullOrWhiteSpace) {
      return;
    }
    final todoVm = _buildCurrentTodoVm();
    if (mounted) {
      await context.read<TodosViewModel>().updateTodoWithChildren(todoVm);
      if (widget.todo.id != null) {
        _todoCache.remove(widget.todo.id!);
      }
    }
  }
  Future<void> _updateTodoWithPop() async {
    await _updateTodoWithChildren();
    _pop();
  }
  _handleChildVmTextChanged(CheckboxTextfieldVm sender, String value) {
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
    } else if (value.isNullOrWhiteSpace) {
      setState(() {
        final indexOfSender = _checkBoxChildren.indexOf(sender);
        _checkBoxChildren.removeAt(indexOfSender);
        _currChildIndex--;
      });
    }
    sender.title = value;
    _updateCache();
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
    _updateCache();
  }
  _handleCheckboxChecked(CheckboxTextfieldVm sender, bool? checked) {
    setState(() {
      sender.isChecked = checked ?? false;
    });
    _updateCache();
  }
  @override
  void initState() {
    super.initState();
    final todoToEdit = widget.todo.id != null && _todoCache.has(widget.todo.id!)
        ? _todoCache.get(widget.todo.id!)!
        : widget.todo;
    _firstVm = CheckboxTextfieldVm(
      id: todoToEdit.id,
      hint: "Title",
      isDisabled: false,
      fontSize: 24,
      onTextChanged: _handleFirstVmTextChanged,
      isChecked: todoToEdit.checked,
      title: todoToEdit.title,
    );
    _firstVm?.onChecked = (bool? checked) =>
        _handleCheckboxChecked(_firstVm!, checked);
    for (var child in todoToEdit.children) {
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
