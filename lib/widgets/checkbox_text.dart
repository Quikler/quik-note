import 'package:flutter/material.dart';
import 'package:quik_note/fill/custom_colors.dart';

class CheckboxText extends StatefulWidget {
  final void Function(bool? value)? onChecked;

  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool isChecked;
  final String? hint;

  const CheckboxText(
    this.text, {
    super.key,
    this.fontSize,
    this.isChecked = false,
    this.hint,
    this.fontWeight,
    this.onChecked,
  });

  @override
  State<StatefulWidget> createState() => _CheckboxTextState();
}

class _CheckboxTextState extends State<CheckboxText> {
  _handleChecked(bool? value) {
    widget.onChecked?.call(value);
    setState(() {
      _checked = value ?? false;
    });
  }

  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: _checked, onChanged: _handleChecked),
        Expanded(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: CustomColors.purple,
              fontWeight: widget.fontWeight,
            ),
          ),
        ),
      ],
    );
  }
}
