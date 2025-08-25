import 'package:flutter/material.dart';
import 'package:quik_note/data/db_todo.dart';
import 'package:quik_note/models/todo.dart';
import 'package:quik_note/pages/edit_todo_form_page.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';
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

  bool _isTitleChecked = false;
  bool _todoExpanded = true;

  void _handleTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Material(child: EditTodoFormPage(todo: widget.todo)),
      ),
    );
  }

  Future _handleChildCheck(int id, bool checked) async {
    final child = widget.todo.children.firstWhere((child) => child.id == id);
    setState(() {
      child.checked = checked;
    });

    final updatedTodo = Todo(
      child.id,
      child.title,
      widget.todo.id,
      child.checked,
    );

    await updateTodo(updatedTodo);
  }

  Future _handleCheck(bool? checked) async {
    _isTitleChecked = checked ?? false;

    final updatedTodo = Todo(
      widget.todo.id,
      widget.todo.title,
      null,
      _isTitleChecked,
    );

    await updateTodo(updatedTodo);
  }

  void _handleDownArrowTap() {
    setState(() {
      _todoExpanded = !_todoExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    _isTitleChecked = widget.todo.checked;
  }

  @override
  Widget build(BuildContext context) {
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
                                    widget.todo.title,
                                    fontWeight: FontWeight.w700,
                                    isChecked: _isTitleChecked,
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
                                    //margin: EdgeInsets.all(16),
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
                                  children: widget.todo.children.map((child) {
                                    return CheckboxText(
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
