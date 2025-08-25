import 'package:flutter/material.dart';
import 'package:quik_note/data/db_todo.dart';
import 'package:quik_note/viewmodels/checkbox_textfield_vm.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';

class TodosListModel extends ChangeNotifier {
  List<TodoVm> todos = [];
  List<TodoVm> bufferTodos = [];

  static TodoVm todoToVm(
    CheckboxTextfieldVm firstVm,
    List<CheckboxTextfieldVm> childrenVm,
  ) {
    final childrenOfTodoVm = childrenVm.map((child) {
      return TodoVm(child.id, child.title!, [], child.isChecked);
    });

    final parentTodo = TodoVm(
      firstVm.id,
      firstVm.title!,
      childrenOfTodoVm.toList(),
      firstVm.isChecked,
    );

    return parentTodo;
  }

  Future<void> getParentsWithChildrenFromDb() async {
    final parentTodos = await getTodos('parentId IS NULL');
    final parentVms = <TodoVm>[];

    for (int i = 0; i < parentTodos.length; i++) {
      final currentParent = parentTodos[i];
      final parentChildren = await getTodos('parentId == ?', [
        currentParent.id,
      ]);

      final parentChildrenVms = parentChildren.map(
        (child) =>
            TodoVm(child.id!, child.title, [], child.checked, child.completed),
      );

      final currentParentVm = TodoVm(
        currentParent.id!,
        currentParent.title,
        parentChildrenVms.toList(),
        currentParent.checked,
        currentParent.completed,
      );
      parentVms.add(currentParentVm);
    }

    todos = parentVms;
    notifyListeners();
  }

  void assignFromBuffer() {
    todos = bufferTodos;
    notifyListeners();
  }

  void deleteAndInsertStartTodo(TodoVm todo) {
    todos.removeWhere((n) => n.id == todo.id);
    todos.insert(0, todo);
    notifyListeners();
  }

  void whereInBuffer(bool Function(TodoVm) predicate) {
    todos = bufferTodos.where(predicate).toList();
    notifyListeners();
  }

  void updateTodo(TodoVm todo) {
    final indexOfTodo = todos.indexWhere((n) => n.id == todo.id);
    todos[indexOfTodo] = todo;
    notifyListeners();
  }

  void insertStartTodo(TodoVm todo) {
    todos.insert(0, todo);
    notifyListeners();
  }

  void insertTodo(TodoVm todo) {
    todos.add(todo);
    notifyListeners();
  }

  void deleteTodos(List<int> ids) {
    for (var i = 0; i < ids.length; i++) {
      todos.removeWhere((n) => n.id == ids[i]);
    }
  }

  void deleteTodo(int id) {
    todos.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
