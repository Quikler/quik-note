import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/viewmodels/todos_viewmodel.dart';
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
    final todosViewModel = context.read<TodosViewModel>();
    await todosViewModel.loadTodos();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todosViewModel = context.watch<TodosViewModel>();
    return SingleChildScrollView(
      child: MainWrapperMargin(
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 16,
              children: todosViewModel.items.map((todo) {
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
