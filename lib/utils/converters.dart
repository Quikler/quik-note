import 'package:flutter/material.dart';
import 'package:quik_note/viewmodels/checkbox_textfield_vm.dart';
import 'package:quik_note/widgets/checkbox_textfield.dart';

CheckboxTextfield convertToCheckboxTextfield(
  CheckboxTextfieldVm vm,
  ValueKey? key,
) => CheckboxTextfield(
  key: key,
  hint: vm.hint,
  isDisabled: vm.isDisabled,
  isChecked: vm.isChecked,
  fontSize: vm.fontSize,
  onChecked: vm.onChecked,
  onTextChanged: vm.onTextChanged,
);
