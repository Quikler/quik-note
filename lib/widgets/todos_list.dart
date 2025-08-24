import 'package:flutter/material.dart';
import 'package:quik_note/data/db_todo.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';
import 'package:quik_note/widgets/add_todo_card.dart';
import 'package:quik_note/widgets/todo_card.dart';
import 'package:quik_note/wrappers/main_wrapper_margin.dart';

class TodosList extends StatefulWidget {
  const TodosList({super.key});

  @override
  State<StatefulWidget> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  List<TodoVm> _todos = [];

  void _loadTodos() async {
    final parentTodos = await getTodos('parentId IS NULL');
    final parentVms = <TodoVm>[];

    for (int i = 0; i < parentTodos.length; i++) {
      final currentParent = parentTodos[i];
      final parentChildren = await getTodos('parentId == ?', [
        currentParent.id,
      ]);

      final parentChildrenVms = parentChildren.map(
        (child) => TodoVm(
          child.id!,
          child.title,
          null,
          child.checked,
          child.completed,
        ),
      );

      final currentParentVm = TodoVm(
        currentParent.id!,
        currentParent.title,
        parentChildrenVms,
        currentParent.checked,
        currentParent.completed,
      );
      parentVms.add(currentParentVm);
    }

    setState(() {
      _todos = parentVms;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MainWrapperMargin(
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 16,
              children: _todos.map((todo) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [TodoCard(todo: todo, children: todo.children)],
                );
              }).toList(),
            ),
            AddTodoCard(),
          ],
        ),
      ),
    );
  }
}
