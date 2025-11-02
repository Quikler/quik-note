import 'package:flutter/foundation.dart';
import 'package:quik_note/core/result.dart';
import 'package:quik_note/services/todo_form_service.dart';
import 'package:quik_note/viewmodels/checkbox_textfield_vm.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';
class TodoFormViewModel extends ChangeNotifier {
  final TodoFormService _service;
  TodoFormViewModel(this._service);
  CheckboxTextfieldVm? _firstVm;
  final List<CheckboxTextfieldVm> _checkBoxChildren = [];
  int _currChildIndex = 0;
  String _appTitle = "Untitled";
  bool _isSaveButtonVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  CheckboxTextfieldVm? get firstVm => _firstVm;
  List<CheckboxTextfieldVm> get checkBoxChildren =>
      List.unmodifiable(_checkBoxChildren);
  int get currChildIndex => _currChildIndex;
  String get appTitle => _appTitle;
  bool get isSaveButtonVisible => _isSaveButtonVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> initializeForEdit(TodoVm todo) async {
    _isLoading = true;
    notifyListeners();
    final todoToEdit = todo.id != null
        ? await _service.loadTodoForEdit(todo.id!) ?? todo
        : todo;
    _firstVm = CheckboxTextfieldVm(
      id: todoToEdit.id,
      hint: "Title",
      isDisabled: false,
      fontSize: 24,
      isChecked: todoToEdit.checked,
      title: todoToEdit.title,
    );
    _checkBoxChildren.clear();
    for (var child in todoToEdit.children) {
      final childVm = CheckboxTextfieldVm(
        id: child.id,
        hint: "Todo something...",
        fontSize: 18,
        isChecked: child.checked,
        isDisabled: false,
        title: child.title,
      );
      _checkBoxChildren.add(childVm);
    }
    _checkBoxChildren.add(
      CheckboxTextfieldVm(
        hint: "Todo something...",
        fontSize: 18,
        isDisabled: false,
      ),
    );
    _checkBoxChildren.add(
      CheckboxTextfieldVm(hint: "Todo something...", fontSize: 18),
    );
    _currChildIndex = _checkBoxChildren.length - 1;
    _appTitle = _firstVm!.title ?? "Untitled";
    _isSaveButtonVisible = _firstVm!.title?.isNotEmpty ?? false;
    _isLoading = false;
    notifyListeners();
  }
  void initializeForCreate() {
    _firstVm = CheckboxTextfieldVm(
      hint: "Title",
      isDisabled: false,
      fontSize: 24,
    );
    _checkBoxChildren.clear();
    _checkBoxChildren.add(
      CheckboxTextfieldVm(hint: "Todo something...", fontSize: 18),
    );
    _currChildIndex = 0;
    _appTitle = "Untitled";
    _isSaveButtonVisible = false;
    notifyListeners();
  }
  void updateTitle(String value) {
    if (value.isNotEmpty) {
      _appTitle = value;
      _isSaveButtonVisible = true;
    } else {
      _appTitle = "Untitled";
    }
    notifyListeners();
    _cacheCurrentState();
  }
  void updateCheckboxState(CheckboxTextfieldVm vm, bool checked) {
    vm.isChecked = checked;
    notifyListeners();
    _cacheCurrentState();
  }
  void addChildField() {
    if (_currChildIndex < _checkBoxChildren.length) {
      _checkBoxChildren[_currChildIndex].isDisabled = false;
      _currChildIndex++;
      final nextChild = CheckboxTextfieldVm(
        hint: "Todo something...",
        fontSize: 18,
      );
      _checkBoxChildren.add(nextChild);
    }
    notifyListeners();
  }
  void removeChildField(CheckboxTextfieldVm vm) {
    final index = _checkBoxChildren.indexOf(vm);
    if (index != -1) {
      _checkBoxChildren.removeAt(index);
      _currChildIndex--;
    }
    notifyListeners();
  }
  TodoVm _buildTodoVm(int? baseId) {
    final childrenVm = _checkBoxChildren
        .where((child) => !child.isDisabled && child.title?.isNotEmpty == true)
        .map(
          (child) => TodoVm(
            id: child.id,
            title: child.title!,
            checked: child.isChecked,
            completed: false,
          ),
        )
        .toList();
    return TodoVm(
      id: baseId,
      title: _firstVm!.title ?? "",
      checked: _firstVm!.isChecked,
      children: childrenVm,
      completed: false,
    );
  }
  void _cacheCurrentState() {
    if (_firstVm?.id != null) {
      final currentTodo = _buildTodoVm(_firstVm!.id);
      _service.cacheTodoDraft(currentTodo);
    }
  }
  Future<bool> saveTodo(int? baseId) async {
    if (_firstVm?.title?.isEmpty ?? true) {
      return false;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final todoVm = _buildTodoVm(baseId);
    final result = await _service.saveTodo(todoVm);
    _isLoading = false;
    return result.when(
      success: (_) {
        notifyListeners();
        return true;
      },
      failure: (error, _) {
        _errorMessage = 'Failed to save todo: ${error.toString()}';
        notifyListeners();
        return false;
      },
    );
  }
  Future<bool> createTodo() async {
    if (_firstVm?.title?.isEmpty ?? true) {
      return false;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final childrenTitles = _checkBoxChildren
        .where((child) => !child.isDisabled && child.title?.isNotEmpty == true)
        .map((child) => child.title!)
        .toList();
    final result = await _service.createTodo(
      title: _firstVm!.title!,
      childrenTitles: childrenTitles,
      checked: _firstVm!.isChecked,
    );
    _isLoading = false;
    return result.when(
      success: (_) {
        notifyListeners();
        return true;
      },
      failure: (error, _) {
        _errorMessage = 'Failed to create todo: ${error.toString()}';
        notifyListeners();
        return false;
      },
    );
  }
  @override
  void dispose() {
    _checkBoxChildren.clear();
    super.dispose();
  }
}
