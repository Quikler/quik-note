import 'package:quik_note/utils/helpers.dart';
class CheckboxTextfieldVm {
  int? id;
  bool isDisabled;
  bool isChecked;
  bool isTextEmpty() => title.isNullOrWhiteSpace;
  double? fontSize;
  String? hint;
  String? title;
  void Function(bool? value)? onChecked;
  void Function(String value)? onTextChanged;
  CheckboxTextfieldVm({
    this.id,
    this.isDisabled = true,
    this.isChecked = false,
    this.fontSize,
    this.hint,
    this.onChecked,
    this.onTextChanged,
    this.title,
  });
}
