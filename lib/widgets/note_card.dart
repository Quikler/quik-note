import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/viewmodels/app_bar_viewmodel.dart';
import 'package:quik_note/viewmodels/notes_viewmodel.dart';
import 'package:quik_note/pages/edit_note_form_page.dart';
import 'package:quik_note/utils/helpers.dart';
import 'package:quik_note/wrappers/responsive_text.dart';
class NoteCard extends StatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.isCheckBoxVisible,
    required this.onNoteDelete,
  });
  final Note note;
  final bool isCheckBoxVisible;
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
    if (n.content.isNullOrWhiteSpace) {
      return "";
    }
    final splittedContent = n.content!.split('\n');
    splittedContent.removeWhere((c) => c.isNullOrWhiteSpace);
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
    if (widget.note.lastEditedTime != null) {
      return formatter.format(widget.note.lastEditedTime!);
    }
    return formatter.format(widget.note.creationTime);
  }
  void _handleTap() {
    if (context.read<AppBarViewModel>().isSelectMode) {
      if (widget.note.id != null) {
        context.read<NotesViewModel>().toggleNoteSelection(widget.note.id!);
      }
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Material(child: EditNoteFormPage(note: widget.note)),
      ),
    );
  }
  void _handleCheck(bool? value) {
    if (widget.note.id != null) {
      context.read<NotesViewModel>().toggleNoteSelection(widget.note.id!);
    }
  }
  void _handleStarPress() async {
    await context.read<NotesViewModel>().toggleStarred(widget.note);
  }
  @override
  Widget build(BuildContext context) {
    final isChecked = widget.note.id != null &&
        context.watch<NotesViewModel>().selectedNoteIds.contains(widget.note.id!);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFFBFBF9),
            borderRadius: _borderRadius,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ResponsiveText(
                              _getNoteTitle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
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
                          ResponsiveText(
                            _formatCreationTime(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFA3A3A3),
                            ),
                          ),
                          Expanded(
                            child: ResponsiveText(
                              _getNoteContent(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFA3A3A3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                widget.isCheckBoxVisible
                    ? Checkbox(onChanged: _handleCheck, value: isChecked)
                    : IconButton(
                        icon: Icon(
                          widget.note.starred ? Icons.star : Icons.star_outline,
                          color: Colors.pink,
                        ),
                        onPressed: _handleStarPress,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
