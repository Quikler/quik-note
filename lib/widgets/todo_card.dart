import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/core/todo_cache.dart';
import 'package:quik_note/pages/edit_todo_form_page.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';
import 'package:quik_note/viewmodels/todos_viewmodel.dart';
import 'package:quik_note/widgets/checkbox_text.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({super.key, required this.todo});

  final TodoVm todo;

  @override
  State<StatefulWidget> createState() {
    return _TodoCardState();
  }
}

class _TodoCardState extends State<TodoCard> {
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(24));
  final _todoCache = TodoCache();

  bool _isTitleChecked = false;
  bool _todoExpanded = true;

  void _handleTap() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Material(child: EditTodoFormPage(todo: _getDisplayedTodo())),
      ),
    );

    if (mounted) {
      if (widget.todo.id != null && _todoCache.has(widget.todo.id!)) {
        setState(() {});
      } else {
        await context.read<TodosViewModel>().loadTodos();
      }
    }
  }

  TodoVm _getDisplayedTodo() {
    if (widget.todo.id != null && _todoCache.has(widget.todo.id!)) {
      return _todoCache.get(widget.todo.id!)!;
    }
    return widget.todo;
  }

  Future _handleChildCheck(int? id, bool checked) async {
    if (id != null) {
      final child = widget.todo.children.firstWhere((child) => child.id == id);
      setState(() {});
      await context.read<TodosViewModel>().toggleTodoChecked(child);
    }
  }

  Future _handleCheck(bool? checked) async {
    setState(() {
      _isTitleChecked = checked ?? false;
    });

    await context.read<TodosViewModel>().toggleTodoChecked(widget.todo);
  }

  void _handleDownArrowTap() {
    setState(() {
      _todoExpanded = !_todoExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    final displayedTodo = _getDisplayedTodo();
    _isTitleChecked = displayedTodo.checked;
  }

  @override
  Widget build(BuildContext context) {
    final displayedTodo = _getDisplayedTodo();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: _handleTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFFBFBF9),
            borderRadius: _borderRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          spacing: 6,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: CheckboxText(
                                    displayedTodo.title,
                                    fontWeight: FontWeight.w700,
                                    isChecked: displayedTodo.checked,
                                    onChecked: _handleCheck,
                                  ),
                                ),
                                InkWell(
                                  onTap: _handleDownArrowTap,
                                  borderRadius: _borderRadius,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: Color(0x4D380099),
                                      borderRadius: _borderRadius,
                                    ),
                                    child: Icon(
                                      _todoExpanded
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_todoExpanded)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 28),
                                child: Column(
                                  children: displayedTodo.children.map((child) {
                                    return CheckboxText(
                                      key: UniqueKey(),
                                      child.title,
                                      truncateText: true,
                                      fontWeight: FontWeight.w700,
                                      isChecked: child.checked,
                                      onChecked: (bool? checked) =>
                                          _handleChildCheck(
                                            child.id,
                                            checked ?? false,
                                          ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
