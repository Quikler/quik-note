import 'package:flutter/material.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/wrappers/responsive_text.dart';

class NoteButton extends StatefulWidget {
  const NoteButton({super.key});

  @override
  State<StatefulWidget> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(324)),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3B3B), Color(0xFF992323)],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            vertical: deviceHeight(context) * 0.02,
            horizontal: 12,
          ),
        ),
        child: const ResponsiveText(
          "Notes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
