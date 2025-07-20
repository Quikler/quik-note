import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quik_note/pages/create_note_form_page.dart';
import 'package:quik_note/svgs/common.dart';

class AddNoteCard extends StatefulWidget {
  final double maxHeight;

  const AddNoteCard({super.key, this.maxHeight = 100});

  @override
  State<StatefulWidget> createState() => _AddNoteCardState();
}

class _AddNoteCardState extends State<AddNoteCard> {
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(12));

  void _handleTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Material(child: CreateNoteFormPage()),
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
                    Text(
                      textAlign: TextAlign.center,
                      "Add note",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
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
