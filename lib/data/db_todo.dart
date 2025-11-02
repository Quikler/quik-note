import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/todo.dart';
import 'package:quik_note/utils/helpers.dart';

Future<int> insertTodo(Todo todo) async {
  final db = await getNotesDb();
  return await db.insert('todos', todo.toMap());
}

Future<void> insertTodos(Iterable<Todo> todos) async {
  final db = await getNotesDb();
  final batch = db.batch();
  for (var todo in todos) {
    batch.insert('todos', todo.toMap());
  }
  await batch.commit(noResult: true);
}

Future<List<Todo>> getTodos([String? where, List<Object?>? whereArgs]) async {
  final db = await getNotesDb();
  final List<Map<String, Object?>> todoMaps = await db.query(
    'todos',
    where: where,
    whereArgs: whereArgs,
  );
  return [
    for (final {
          'id': id as int,
          'title': title as String,
          'parentId': parentId as int?,
          'checked': checked as int,
          'completed': completed as int,
        }
        in todoMaps)
      Todo(
        id: id,
        title: title,
        parentId: parentId,
        checked: checked.toBool(),
        completed: completed.toBool(),
      ),
  ];
}

Future<void> updateTodos(Iterable<Todo> todos) async {
  final db = await getNotesDb();
  final batch = db.batch();
  for (var todo in todos) {
    batch.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }
  await batch.commit(noResult: true);
}

Future<int> updateTodo(Todo todo) async {
  final db = await getNotesDb();
  return await db.update(
    'todos',
    todo.toMap(),
    where: 'id = ?',
    whereArgs: [todo.id],
  );
}

Future<int> deleteTodo(int id) async {
  final db = await getNotesDb();
  return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
}

Future<int> deleteTodos(List<int> ids) async {
  final db = await getNotesDb();
  return await db.delete(
    'todos',
    where: 'id IN (${List.filled(ids.length, '?').join(',')})',
    whereArgs: ids,
  );
}
