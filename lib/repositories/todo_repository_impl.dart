import 'package:quik_note/core/result.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/todo.dart';
import 'package:quik_note/repositories/todo_repository.dart';
final class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl();
  @override
  Future<Result<Todo>> create(Todo todo) async {
    try {
      final db = await getNotesDb();
      final id = await db.insert('todos', todo.toMap());
      final createdTodo = todo.copyWith(id: id);
      return Success(createdTodo);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<int>> createMany(List<Todo> todos) async {
    try {
      if (todos.isEmpty) {
        return const Success(0);
      }
      final db = await getNotesDb();
      final batch = db.batch();
      for (final todo in todos) {
        batch.insert('todos', todo.toMap());
      }
      final results = await batch.commit(noResult: false);
      return Success(results.length);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<List<Todo>>> getAll({
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final db = await getNotesDb();
      final List<Map<String, Object?>> todoMaps = await db.query(
        'todos',
        where: where,
        whereArgs: whereArgs,
      );
      final todos = todoMaps.map(_mapToTodo).toList();
      return Success(todos);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<List<Todo>>> getParents() async {
    return getAll(where: 'parentId IS NULL');
  }
  @override
  Future<Result<List<Todo>>> getChildren(int parentId) async {
    return getAll(where: 'parentId = ?', whereArgs: [parentId]);
  }
  @override
  Future<Result<Todo?>> getById(int id) async {
    try {
      final db = await getNotesDb();
      final List<Map<String, Object?>> todoMaps = await db.query(
        'todos',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (todoMaps.isEmpty) {
        return const Success(null);
      }
      return Success(_mapToTodo(todoMaps.first));
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<Todo>> update(Todo todo) async {
    try {
      final db = await getNotesDb();
      await db.update(
        'todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
      return Success(todo);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<int>> updateMany(List<Todo> todos) async {
    try {
      if (todos.isEmpty) {
        return const Success(0);
      }
      final db = await getNotesDb();
      final batch = db.batch();
      for (final todo in todos) {
        batch.update(
          'todos',
          todo.toMap(),
          where: 'id = ?',
          whereArgs: [todo.id],
        );
      }
      final results = await batch.commit(noResult: false);
      return Success(results.length);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<bool>> delete(int id) async {
    try {
      final db = await getNotesDb();
      final count = await db.delete('todos', where: 'id = ?', whereArgs: [id]);
      return Success(count > 0);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  @override
  Future<Result<int>> deleteMany(List<int> ids) async {
    try {
      if (ids.isEmpty) {
        return const Success(0);
      }
      final db = await getNotesDb();
      final count = await db.delete(
        'todos',
        where: 'id IN (${List.filled(ids.length, '?').join(',')})',
        whereArgs: ids,
      );
      return Success(count);
    } catch (e, stackTrace) {
      return Failure(e, stackTrace);
    }
  }
  Todo _mapToTodo(Map<String, Object?> map) {
    return Todo.fromMap(map);
  }
}
