class TodoVm {
  final int? id;
  final String title;
  final List<TodoVm> children;
  final bool checked;
  final bool completed;
  const TodoVm({
    this.id,
    required this.title,
    this.children = const [],
    this.checked = false,
    this.completed = false,
  });
  TodoVm copyWith({
    int? id,
    String? title,
    List<TodoVm>? children,
    bool? checked,
    bool? completed,
  }) {
    return TodoVm(
      id: id ?? this.id,
      title: title ?? this.title,
      children: children ?? this.children,
      checked: checked ?? this.checked,
      completed: completed ?? this.completed,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoVm &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          checked == other.checked &&
          completed == other.completed;
  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ checked.hashCode ^ completed.hashCode;
  @override
  String toString() {
    return 'TodoVm(id: $id, title: $title, children: ${children.length}, checked: $checked, completed: $completed)';
  }
}
