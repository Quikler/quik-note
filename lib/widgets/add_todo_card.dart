import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quik_note/pages/create_todo_form_page.dart';
import 'package:quik_note/svgs/common.dart';
import 'package:quik_note/wrappers/responsive_text.dart';

class AddTodoCard extends StatefulWidget {
  final double maxHeight;

  const AddTodoCard({super.key, this.maxHeight = 100});

  @override
  State<StatefulWidget> createState() => _AddTodoCardState();
}

class _AddTodoCardState extends State<AddTodoCard> {
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(12));

  void _handleTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Material(child: CreateTodoFormPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: _handleTap,
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0x80FBFBF9),
            borderRadius: _borderRadius,
          ),
          child: Container(
            constraints: BoxConstraints(maxHeight: widget.maxHeight),
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: SvgPicture.string(plusCircleSvg, width: 48),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ResponsiveText(
                      textAlign: TextAlign.center,
                      "Add todo",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
