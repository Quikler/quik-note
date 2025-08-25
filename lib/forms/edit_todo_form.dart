import 'package:flutter/material.dart';
import 'package:quik_note/utils/converters.dart';
import 'package:quik_note/utils/helpers.dart';
import 'package:quik_note/viewmodels/checkbox_textfield_vm.dart';

class EditTodoForm extends StatefulWidget {
  final void Function(
    CheckboxTextfieldVm firstVm,
    List<CheckboxTextfieldVm> checkBoxChildren,
  )
  onFieldsChange;

  const EditTodoForm({super.key, required this.onFieldsChange});

  @override
  State<StatefulWidget> createState() {
    return _EditTodoFormState();
  }
}

class _EditTodoFormState extends State<EditTodoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CheckboxTextfieldVm? _firstVm;
  final _checkBoxChildren = <CheckboxTextfieldVm>[];
  int _currChildIndex = 0;

  _handleChildVmTextChanged(CheckboxTextfieldVm sender, String value) {
    // value not empty and child text is empty
    if (sender.isTextEmpty() && !value.isNullOrWhiteSpace) {
      setState(() {
        _checkBoxChildren[_currChildIndex].isDisabled = false;
        _currChildIndex++;

        final nextChild = CheckboxTextfieldVm(
          hint: "Todo something...",
          fontSize: 18,
        );
        nextChild.onTextChanged = (String val) =>
            _handleChildVmTextChanged(nextChild, val);
        nextChild.onChecked = (bool? checked) =>
            _handleCheckboxChecked(nextChild, checked);

        _checkBoxChildren.add(nextChild);
      });

      // value is empty -> remove child
    } else if (value.isNullOrWhiteSpace) {
      setState(() {
        final indexOfSender = _checkBoxChildren.indexOf(sender);
        _checkBoxChildren.removeAt(indexOfSender);
        _currChildIndex--;
      });
    }

    sender.title = value;
    widget.onFieldsChange(_firstVm!, _checkBoxChildren);
  }

  _handleFirstVmTextChanged(String value) {
    if (_firstVm!.isTextEmpty() && !value.isNullOrWhiteSpace) {
      setState(() {
        for (var i = 0; i < _currChildIndex + 1; i++) {
          _checkBoxChildren[i].isDisabled = false;
        }
        _currChildIndex++;

        // second child
        final nextChild = CheckboxTextfieldVm(
          hint: "Todo something...",
          fontSize: 18,
        );
        nextChild.onTextChanged = (String val) =>
            _handleChildVmTextChanged(nextChild, val);
        nextChild.onChecked = (bool? checked) =>
            _handleCheckboxChecked(nextChild, checked);

        _checkBoxChildren.add(nextChild);
      });
    } else if (value.isNullOrWhiteSpace) {
      _checkBoxChildren.removeAt(_currChildIndex - 1);
      for (var child in _checkBoxChildren) {
        child.isDisabled = true;
      }

      _currChildIndex--;
    }

    _firstVm!.title = value;
    widget.onFieldsChange(_firstVm!, _checkBoxChildren);
  }

  _handleCheckboxChecked(CheckboxTextfieldVm sender, bool? checked) {
    setState(() {
      sender.isChecked = checked ?? false;
    });

    widget.onFieldsChange(_firstVm!, _checkBoxChildren);
  }

  @override
  void initState() {
    super.initState();

    _firstVm = CheckboxTextfieldVm(
      hint: "Title",
      isDisabled: false,
      fontSize: 24,
      onTextChanged: _handleFirstVmTextChanged,
    );
    _firstVm?.onChecked = (bool? checked) =>
        _handleCheckboxChecked(_firstVm!, checked);

    final firstChild = CheckboxTextfieldVm(
      hint: "Todo something...",
      fontSize: 18,
    );
    firstChild.onTextChanged = (String value) =>
        _handleChildVmTextChanged(firstChild, value);
    firstChild.onChecked = (bool? checked) =>
        _handleCheckboxChecked(firstChild, checked);

    _checkBoxChildren.add(firstChild);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          convertToCheckboxTextfield(_firstVm!, null),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: _checkBoxChildren.map((child) {
                return convertToCheckboxTextfield(child, ValueKey(child));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
