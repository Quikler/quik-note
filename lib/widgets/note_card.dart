import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/pages/edit_note_form_page.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({super.key, required this.note, required this.onNoteDelete});

  final Note note;
  final void Function(int? id) onNoteDelete;

  @override
  State<StatefulWidget> createState() {
    return _NoteCardState();
  }
}

class _NoteCardState extends State<NoteCard> {
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(12));

  String _formatCreationTime() {
    final formatter = DateFormat('MM-dd hh:mm');
    return formatter.format(widget.note.creationTime);
  }

  void _handleNoteDelete() async {
    final int count = await deleteNote(widget.note.id!);
    if (count > 0) {
      widget.onNoteDelete(widget.note.id);
    }
  }

  void _handleTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Material(child: EditNoteFormPage(note: widget.note)),
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
          decoration: BoxDecoration(
            color: Color(0xFFFBFBF9),
            borderRadius: _borderRadius,
          ),
          child: Container(
            //padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                            widget.note.title,
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
          ),
        ),
      ),
    );
  }
}
