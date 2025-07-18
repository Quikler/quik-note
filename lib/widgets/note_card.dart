import 'package:flutter/material.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.creationTime,
    required this.onNoteDelete,
  });

  final int? id;
  final String title;
  final String? content;
  final DateTime creationTime;
  final Function(int? id) onNoteDelete;

  @override
  State<StatefulWidget> createState() {
    return _NoteCardState();
  }
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFFBFBF9),
        borderRadius: BorderRadius.all(Radius.circular(48)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.cyan,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: Color(0xFFFBFBF9),
                size: 48,
              ),
            ),
          ),
          Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF380099),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Aug 21, 2021",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA3A3A3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
