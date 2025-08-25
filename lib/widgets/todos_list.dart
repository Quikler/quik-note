import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/models/notifiers/todos_list_model.dart';
import 'package:quik_note/widgets/add_todo_card.dart';
import 'package:quik_note/widgets/todo_card.dart';
import 'package:quik_note/wrappers/main_wrapper_margin.dart';

class TodosList extends StatefulWidget {
  const TodosList({super.key});

  @override
  State<StatefulWidget> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  void _loadTodos() async {
    final todosContext = context.read<TodosListModel>();
    await todosContext.getParentsWithChildrenFromDb();
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    final todosContext = context.watch<TodosListModel>();

    return SingleChildScrollView(
      child: MainWrapperMargin(
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 16,
              children: todosContext.todos.map((todo) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [TodoCard(todo: todo)],
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
