import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/forms/create_todo_form.dart';
import 'package:quik_note/viewmodels/todos_viewmodel.dart';
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
  final _checkBoxChildren = <CheckboxTextfieldVm>[];
  int _currChildIndex = 0;
  void _handleBackButtonPressed() => _pop();
  void _handleSaveButtonPressed() => _pop();
  void _pop() => Navigator.maybePop(context);
  void _handlePopOfPopScope(bool didPop, Object? result) async =>
      await _insertNewTodoWithPop();
  Future<void> _insertNewTodoWithChildren() async {
    if (_firstVm!.title.isNullOrWhiteSpace) {
      return;
    }
    final childrenTitles = _checkBoxChildren
        .where(
          (checkBoxChild) =>
              !checkBoxChild.isDisabled && !checkBoxChild.isTextEmpty(),
        )
        .map((checkBoxChild) => checkBoxChild.title!)
        .toList();
    if (mounted) {
      await context.read<TodosViewModel>().createTodoWithChildren(
        title: _firstVm!.title!,
        childrenTitles: childrenTitles,
        checked: _firstVm!.isChecked,
      );
    }
  }
  Future<void> _insertNewTodoWithPop() async {
    await _insertNewTodoWithChildren();
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
  }
  _handleFirstVmTextChanged(String value) {
    setState(() {
      final title = _firstVm?.title;
      if (!title.isNullOrWhiteSpace) {
        _isSaveButtonVisible = true;
        _appTitle = title ?? "";
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
    } else if (value.isNullOrWhiteSpace) {
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
      hint: "Title",
      isDisabled: false,
      fontSize: 24,
      onTextChanged: _handleFirstVmTextChanged,
    );
    _firstVm?.onChecked = (bool? checked) =>
        _handleCheckboxChecked(_firstVm!, checked);
    final firstChild = CheckboxTextfieldVm(
      hint: "Todo something...",
      fontSize: 18,
    );
    firstChild.onTextChanged = (String value) =>
        _handleChildVmTextChanged(firstChild, value);
    firstChild.onChecked = (bool? checked) =>
        _handleCheckboxChecked(firstChild, checked);
    _checkBoxChildren.add(firstChild);
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _handlePopOfPopScope,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: noteFormPageAppBarHeight(),
          actions: [
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
