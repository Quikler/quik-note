import 'package:quik_note/core/result.dart';
import 'package:quik_note/models/todo.dart';
abstract interface class TodoRepository {
  Future<Result<Todo>> create(Todo todo);
  Future<Result<int>> createMany(List<Todo> todos);
  Future<Result<List<Todo>>> getAll({String? where, List<Object?>? whereArgs});
  Future<Result<List<Todo>>> getParents();
  Future<Result<List<Todo>>> getChildren(int parentId);
  Future<Result<Todo?>> getById(int id);
  Future<Result<Todo>> update(Todo todo);
  Future<Result<int>> updateMany(List<Todo> todos);
  Future<Result<bool>> delete(int id);
  Future<Result<int>> deleteMany(List<int> ids);
}
