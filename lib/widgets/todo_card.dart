import 'package:flutter/material.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';
import 'package:quik_note/widgets/checkbox_text.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({super.key, required this.todo, this.children});

  final TodoVm todo;
  final Iterable<TodoVm>? children;

  @override
  State<StatefulWidget> createState() {
    return _TodoCardState();
  }
}

class _TodoCardState extends State<TodoCard> {
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(12));

  Iterable<TodoVm> _children = [];
  bool _isTitleChecked = false;

  void _handleTap() {
    return;
    //Navigator.of(context).push(
    //MaterialPageRoute(
    //builder: (context) =>
    //Material(child: EditNoteFormPage(note: widget.todo)),
    //),
    //);
  }

  void _handleChildCheck(int id, bool? checked) {
    final child = _children.firstWhere((child) => child.id == id);
    print("Checked ${child.title}");
    setState(() {
      child.checked = checked ?? false;
    });
  }

  void _handleCheck(bool? checked) {
    setState(() {
      _isTitleChecked = checked ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isTitleChecked = widget.todo.checked;
    _children = widget.children ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFFBFBF9),
            borderRadius: _borderRadius,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxText(
                              widget.todo.title,
                              fontWeight: FontWeight.w700,
                              isChecked: _isTitleChecked,
                              onChecked: _handleCheck,
                            ),
                          ),
                          //Text('right'),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: _children.map((child) {
                            return CheckboxText(
                              child.title,
                              fontWeight: FontWeight.w700,
                              isChecked: child.checked,
                              onChecked: (bool? checked) =>
                                  _handleChildCheck(child.id, checked),
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
      ),
    );
  }
}
