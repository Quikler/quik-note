import 'package:flutter/material.dart';
import 'package:quik_note/fill/custom_colors.dart';

class CheckboxText extends StatefulWidget {
  final void Function(bool? value)? onChecked;

  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool isChecked;
  final bool truncateText;
  final String? hint;

  const CheckboxText(
    this.text, {
    super.key,
    this.fontSize,
    this.isChecked = false,
    this.truncateText = false,
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
      _striked = _checked = value ?? false;
    });
  }

  bool _checked = false;
  bool _striked = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.isChecked;
    _striked = _checked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _checked,
          onChanged: _handleChecked,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        Expanded(
          child: Text(
            widget.text,
            style: TextStyle(
              overflow: widget.truncateText ? TextOverflow.ellipsis : null,
              decoration: _striked ? TextDecoration.lineThrough : null,
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
