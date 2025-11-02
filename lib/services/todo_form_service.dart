import 'package:quik_note/core/todo_cache.dart';
import 'package:quik_note/repositories/todo_repository.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';
import 'package:quik_note/models/todo.dart';
import 'package:quik_note/core/result.dart';
class TodoFormService {
  final TodoRepository _repository;
  final TodoCache _cache;
  TodoFormService(this._repository, this._cache);
  Future<TodoVm?> loadTodoForEdit(int todoId) async {
    if (_cache.has(todoId)) {
      return _cache.get(todoId);
    }
    final parentsResult = await _repository.getParents();
    return await parentsResult.when(
      success: (parents) async {
        final parent = parents.firstWhere((p) => p.id == todoId);
        final childrenResult = await _repository.getChildren(todoId);
        final childrenVm = childrenResult.when(
          success: (children) => children
              .map(
                (child) => TodoVm(
                  id: child.id,
                  title: child.title,
                  checked: child.checked,
                  completed: child.completed,
                ),
              )
              .toList(),
          failure: (_, __) => <TodoVm>[],
        );
        return TodoVm(
          id: parent.id,
          title: parent.title,
          children: childrenVm,
          checked: parent.checked,
          completed: parent.completed,
        );
      },
      failure: (_, __) => null,
    );
  }
  void cacheTodoDraft(TodoVm todo) {
    if (todo.id != null) {
      _cache.set(todo.id!, todo);
    }
  }
  TodoVm? getCachedTodo(int todoId) {
    return _cache.get(todoId);
  }
  bool hasCachedChanges(int todoId) {
    return _cache.has(todoId);
  }
  Future<Result<TodoVm>> saveTodo(TodoVm todo) async {
    final parentTodo = Todo(
      id: todo.id,
      title: todo.title,
      checked: todo.checked,
      completed: todo.completed,
    );
    final parentResult = await _repository.update(parentTodo);
    return await parentResult.when(
      success: (updatedParent) async {
        if (todo.children.isNotEmpty) {
          final childTodos = todo.children
              .map(
                (child) => Todo(
                  id: child.id,
                  title: child.title,
                  parentId: updatedParent.id,
                  checked: child.checked,
                  completed: child.completed,
                ),
              )
              .toList();
          await _repository.updateMany(childTodos);
        }
        if (todo.id != null) {
          _cache.remove(todo.id!);
        }
        return Success(todo);
      },
      failure: (error, stackTrace) {
        return Failure(error, stackTrace);
      },
    );
  }
  Future<Result<TodoVm>> createTodo({
    required String title,
    required List<String> childrenTitles,
    bool checked = false,
  }) async {
    final parentTodo = Todo(title: title, checked: checked);
    final parentResult = await _repository.create(parentTodo);
    return await parentResult.when(
      success: (createdParent) async {
        final children = <Todo>[];
        if (childrenTitles.isNotEmpty) {
          final childTodos = childrenTitles
              .map(
                (childTitle) => Todo(
                  title: childTitle,
                  parentId: createdParent.id,
                  checked: false,
                ),
              )
              .toList();
          final childrenResult = await _repository.createMany(childTodos);
          await childrenResult.when(
            success: (_) async {
              final loadedChildren = await _repository.getChildren(
                createdParent.id!,
              );
              loadedChildren.when(
                success: (loaded) => children.addAll(loaded),
                failure: (_, __) {},
              );
            },
            failure: (_, __) {},
          );
        }
        final childrenVm = children
            .map(
              (child) => TodoVm(
                id: child.id,
                title: child.title,
                checked: child.checked,
                completed: child.completed,
              ),
            )
            .toList();
        final todoVm = TodoVm(
          id: createdParent.id,
          title: createdParent.title,
          children: childrenVm,
          checked: createdParent.checked,
          completed: createdParent.completed,
        );
        return Success(todoVm);
      },
      failure: (error, stackTrace) {
        return Failure(error, stackTrace);
      },
    );
  }
  void clearCache(int todoId) => _cache.remove(todoId);
}
