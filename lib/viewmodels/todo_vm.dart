class TodoVm {
  int id;
  String title;
  Iterable<TodoVm>? children;
  bool checked;
  bool completed;

  TodoVm(
    this.id,
    this.title, [
    this.children,
    this.checked = false,
    this.completed = false,
  ]);
}
