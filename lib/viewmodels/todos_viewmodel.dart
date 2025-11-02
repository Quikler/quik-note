import 'package:quik_note/core/result.dart';
import 'package:quik_note/models/todo.dart';
import 'package:quik_note/repositories/todo_repository.dart';
import 'package:quik_note/viewmodels/base_list_viewmodel.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';
class TodosViewModel extends BaseListViewModel<TodoVm> {
  final TodoRepository _repository;
  TodosViewModel(this._repository);
  @override
  TodoRepository get repository => _repository;
  @override
  int? getItemId(TodoVm item) => item.id;
  @override
  bool matchesSearchQuery(TodoVm item, String lowerCaseQuery) {
    final titleMatch = item.title.toLowerCase().contains(lowerCaseQuery);
    final childrenMatch = item.children.any(
      (child) => child.title.toLowerCase().contains(lowerCaseQuery),
    );
    return titleMatch || childrenMatch;
  }
  @override
  Future<void> loadItems() async {
    final parentsResult = await _repository.getParents();
    await parentsResult.when(
      success: (parentTodos) async {
        final todosVm = <TodoVm>[];
        for (final parent in parentTodos) {
          final childrenResult = await _repository.getChildren(parent.id!);
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
          todosVm.add(
            TodoVm(
              id: parent.id,
              title: parent.title,
              children: childrenVm,
              checked: parent.checked,
              completed: parent.completed,
            ),
          );
        }
        setItems(todosVm);
      },
      failure: (error, _) {
        setError('Failed to load todos: ${error.toString()}');
      },
    );
  }
  Future<void> loadTodos() async {
    await load();
  }
  @override
  Future<Result<bool>> performDelete(int id) async {
    final childrenResult = await _repository.getChildren(id);
    await childrenResult.when(
      success: (children) async {
        if (children.isNotEmpty) {
          final childIds = children.map((c) => c.id!).toList();
          await _repository.deleteMany(childIds);
        }
      },
      failure: (_, __) {},
    );
    return await _repository.delete(id);
  }
  @override
  Future<Result<int>> performDeleteMany(List<int> ids) async {
    for (final id in ids) {
      final childrenResult = await _repository.getChildren(id);
      await childrenResult.when(
        success: (children) async {
          if (children.isNotEmpty) {
            final childIds = children.map((c) => c.id!).toList();
            await _repository.deleteMany(childIds);
          }
        },
        failure: (_, __) {},
      );
    }
    return await _repository.deleteMany(ids);
  }
  @override
  Future<Result<TodoVm>> performCreate(TodoVm item) async {
    final todo = Todo(
      title: item.title,
      checked: item.checked,
      completed: item.completed,
    );
    final result = await _repository.create(todo);
    return result.when(
      success: (createdTodo) => Success(
        TodoVm(
          id: createdTodo.id,
          title: createdTodo.title,
          checked: createdTodo.checked,
          completed: createdTodo.completed,
        ),
      ),
      failure: (error, stackTrace) => Failure(error, stackTrace),
    );
  }
  @override
  Future<Result<TodoVm>> performUpdate(TodoVm item) async {
    final parentTodo = Todo(
      id: item.id,
      title: item.title,
      checked: item.checked,
      completed: item.completed,
    );
    final parentResult = await _repository.update(parentTodo);
    return await parentResult.when(
      success: (updatedParent) async {
        if (item.children.isNotEmpty) {
          final childTodos = item.children
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
        return Success(item);
      },
      failure: (error, stackTrace) => Failure(error, stackTrace),
    );
  }
  Future<bool> createTodoWithChildren({
    required String title,
    required List<String> childrenTitles,
    bool checked = false,
  }) async {
    clearError();
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
            failure: (error, _) {
              setError('Failed to create children: ${error.toString()}');
            },
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
        addItem(todoVm);
        notifyListeners();
        return true;
      },
      failure: (error, _) {
        setError('Failed to create todo: ${error.toString()}');
        return false;
      },
    );
  }
  Future<bool> updateTodoWithChildren(TodoVm todoVm) async {
    return updateItem(todoVm);
  }
  Future<bool> toggleTodoChecked(TodoVm todoVm) async {
    final updated = todoVm.copyWith(checked: !todoVm.checked);
    return updateTodoWithChildren(updated);
  }
  Future<bool> toggleTodoCompleted(TodoVm todoVm) async {
    final updated = todoVm.copyWith(completed: !todoVm.completed);
    return updateTodoWithChildren(updated);
  }
}
