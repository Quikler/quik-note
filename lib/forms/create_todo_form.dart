import 'package:flutter/material.dart';
import 'package:quik_note/utils/converters.dart';
import 'package:quik_note/viewmodels/checkbox_textfield_vm.dart';

class CreateTodoForm extends StatefulWidget {
  final CheckboxTextfieldVm firstVm;
  final List<CheckboxTextfieldVm> checkBoxChildren;

  const CreateTodoForm({
    super.key,
    required this.firstVm,
    required this.checkBoxChildren,
  });

  @override
  State<StatefulWidget> createState() {
    return _CreateTodoFormState();
  }
}

class _CreateTodoFormState extends State<CreateTodoForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          convertToCheckboxTextfield(widget.firstVm, null),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: widget.checkBoxChildren.map((child) {
                return convertToCheckboxTextfield(child, ValueKey(child));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
