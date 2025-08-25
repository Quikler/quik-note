class TodoVm {
  int? id;
  String title;
  List<TodoVm> children = [];
  bool checked;
  bool completed;

  TodoVm(
    this.id,
    this.title,
    this.children, [
    this.checked = false,
    this.completed = false,
  ]);
}
