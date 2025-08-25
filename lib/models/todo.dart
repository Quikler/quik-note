import 'package:quik_note/utils/helpers.dart';

class Todo {
  final int? id;
  final String title;
  final int? parentId;
  final bool checked;
  final bool completed;

  const Todo(
    this.id,
    this.title,
    this.parentId, [
    this.checked = false,
    this.completed = false,
  ]);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'parentId': parentId,
      'checked': checked.toInt(),
      'completed': completed.toInt(),
    };
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant Todo other) {
    return id == other.id &&
        title == other.title &&
        parentId == other.parentId &&
        checked == other.checked &&
        completed == other.completed;
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, parentId: $parentId, checked: $checked, completed: $completed}';
  }

  Todo copyWith({
    int? id,
    String? title,
    int? parentId,
    bool? checked,
    bool? completed,
  }) => Todo(
    id ?? this.id,
    title ?? this.title,
    parentId ?? this.parentId,
    checked ?? this.checked,
    completed ?? this.completed,
  );
}
