import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/widgets/add_note_card.dart';
import 'package:quik_note/widgets/note_card.dart';
import 'package:quik_note/wrappers/main_wrapper_margin.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<StatefulWidget> createState() => _NoteListState();
}

class _NoteListState extends State<NotesList> {
  List<Note> notes = [];

  List<IntrinsicHeight> widgetNotes = [];

  void _loadNotes() async {
    final notesFromDb = await getNotes();
    notes = notesFromDb;

    setState(() {
      //notes = [
      //Note(1, "Shoping List For August", "test", DateTime.now()),
      //Note(2, "Random notes when iam boring", "test2", DateTime.now()),
      //Note(3, "List music", "test3", DateTime.now()),
      //];

      widgetNotes = notes.map((n) {
        return IntrinsicHeight(
          child: NoteCard(
            id: n.id,
            title: n.title,
            content: n.content,
            creationTime: n.creationTime,
            onNoteDelete: (n) {},
          ),
        );
      }).toList();

      widgetNotes.add(IntrinsicHeight(child: AddNoteCard()));
      //this.notes = notes;
    });
  }

  Future<void> _handleDeleteNote(int? id) async {
    if (id != null) {
      setState(() {
        notes.removeWhere((n) => n.id == id);
      });

      await deleteNote(id);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return MainWrapperMargin(
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 24, // add some space
        children: widgetNotes,
      ),
    );
  }
}
