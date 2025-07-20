import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quik_note/data/db.dart';

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
  final void Function(int? id) onNoteDelete;

  @override
  State<StatefulWidget> createState() {
    return _NoteCardState();
  }
}

class _NoteCardState extends State<NoteCard> {
  String _formatCreationTime() {
    final formatter = DateFormat('MM-dd hh:mm');
    return formatter.format(widget.creationTime);
  }

  void _handleNoteDelete() async {
    final int count = await deleteNote(widget.id!);
    if (count > 0) {
      widget.onNoteDelete(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFFBFBF9),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //spacing: 12,
        children: [
          //Container(
          //alignment: Alignment.center,
          //child: Container(
          //padding: EdgeInsets.all(12),
          //decoration: BoxDecoration(
          //color: Colors.cyan,
          //boxShadow: [
          //BoxShadow(
          //color: Colors.cyan.withAlpha(100),
          //spreadRadius: 1,
          //blurRadius: 7,
          //offset: Offset(0, 4),
          //),
          //],
          //borderRadius: BorderRadius.all(Radius.circular(50)),
          //),
          //child: Icon(
          //Icons.shopping_cart,
          //color: Color(0xFFFBFBF9),
          //size: 48,
          //),
          //),
          //),
          Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF380099),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    color: Colors.pink,
                    onPressed: _handleNoteDelete,
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
              Text(
                _formatCreationTime(),
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
