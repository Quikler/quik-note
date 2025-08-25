import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quik_note/fill/custom_colors.dart';

class CheckboxTextfield extends StatefulWidget {
  final void Function(bool? value)? onChecked;
  final void Function(String value)? onTextChanged;
  final void Function(bool hasFocus)? onTextFocus;

  final double? fontSize;
  final String? initialValue;
  final bool isDisabled;
  final bool isChecked;
  final String? hint;

  const CheckboxTextfield({
    super.key,
    this.fontSize,
    this.initialValue,
    this.isDisabled = true,
    this.isChecked = false,
    this.hint,
    this.onChecked,
    this.onTextChanged,
    this.onTextFocus,
  });

  @override
  State<StatefulWidget> createState() => _CheckboxTextfieldState();
}

class _CheckboxTextfieldState extends State<CheckboxTextfield> {
  final _textFocusNode = FocusNode();

  _handleChecked(bool? value) {
    widget.onChecked?.call(value);
  }

  _handleTextChanged(String value) {
    widget.onTextChanged?.call(value);
  }

  @override
  void initState() {
    super.initState();

    _textFocusNode.addListener(() {
      final focused = _textFocusNode.hasFocus;
      widget.onTextFocus?.call(focused);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          value: widget.isChecked,
          onChanged: widget.isDisabled ? null : _handleChecked,
        ),
        Expanded(
          child: TextFormField(
            initialValue: widget.initialValue,
            inputFormatters: [FilteringTextInputFormatter.deny('\n')],
            textInputAction: TextInputAction.next,
            maxLines: null,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: widget.isDisabled ? Colors.grey : CustomColors.purple70,
              ),
              border: InputBorder.none,
              hintText: widget.hint ?? "Untitiled",
            ),
            style: TextStyle(
              fontSize: widget.fontSize,
              color: widget.isDisabled ? Colors.grey : CustomColors.purple,
            ),
            readOnly: widget.isDisabled,
            onChanged: _handleTextChanged,
          ),
        ),
      ],
    );
  }
}
