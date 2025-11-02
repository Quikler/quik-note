import 'package:quik_note/utils/helpers.dart';
class Todo {
  final int? id;
  final String title;
  final int? parentId;
  final bool checked;
  final bool completed;
  const Todo({
    this.id,
    required this.title,
    this.parentId,
    this.checked = false,
    this.completed = false,
  });
  factory Todo.fromMap(Map<String, Object?> map) {
    return Todo(
      id: map['id'] as int?,
      title: map['title'] as String,
      parentId: map['parentId'] as int?,
      checked: (map['checked'] as int?) == 1,
      completed: (map['completed'] as int?) == 1,
    );
  }
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'parentId': parentId,
      'checked': checked.toInt(),
      'completed': completed.toInt(),
    };
  }
  Todo copyWith({
    int? id,
    String? title,
    int? parentId,
    bool? checked,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      parentId: parentId ?? this.parentId,
      checked: checked ?? this.checked,
      completed: completed ?? this.completed,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          parentId == other.parentId &&
          checked == other.checked &&
          completed == other.completed;
  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      parentId.hashCode ^
      checked.hashCode ^
      completed.hashCode;
  @override
  String toString() {
    return 'Todo(id: $id, title: $title, parentId: $parentId, checked: $checked, completed: $completed)';
  }
}
