import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/pages/edit_note_form_page.dart';
import 'package:quik_note/utils/helpers.dart';

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

  String _getNoteTitle() {
    final n = widget.note;
    if (n.title.isNullOrWhiteSpace) {
      return n.content?.trim() ?? "";
    }

    return n.title?.trim() ?? "";
  }

  String _getNoteContent() {
    final n = widget.note;

    // if content is null or white space return empty string
    if (n.content.isNullOrWhiteSpace) {
      return "";
    }

    final splittedContent = n.content!.split('\n');
    splittedContent.removeWhere((c) => c.isNullOrWhiteSpace);

    // if title is null or white space then content should not be empty
    if (n.title.isNullOrWhiteSpace) {
      if (splittedContent.length > 1) {
        return splittedContent[1];
      }
      return "";
    }

    return splittedContent[0];
  }

  String _formatCreationTime() {
    final formatter = DateFormat('MM-dd hh:mm');

    // if lastEditedTime is presented display it instead of creationTime
    if (widget.note.lastEditedTime != null) {
      return formatter.format(widget.note.lastEditedTime!);
    }

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
        //borderRadius: _borderRadius,
        onTap: _handleTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFFBFBF9),
            borderRadius: _borderRadius,
          ),
          child: Container(
            //padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getNoteTitle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF380099),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          Text(
                            _formatCreationTime(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFA3A3A3),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _getNoteContent(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFA3A3A3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  color: Colors.pink,
                  onPressed: _handleNoteDelete,
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
