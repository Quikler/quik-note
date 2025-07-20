import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/widgets/add_note_card.dart';
import 'package:quik_note/widgets/note_card.dart';
import 'package:quik_note/wrappers/main_wrapper_margin.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<StatefulWidget> createState() => _NoteListState();
}

class _NoteListState extends State<NotesList> {
  void _loadNotes() async {
    await context.read<NotesListModel>().assignFromDb();
  }

  void _handleDeleteNote(int? id) {
    if (id != null) {
      context.read<NotesListModel>().deleteNote(id);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MainWrapperMargin(
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 16,
              children: context.watch<NotesListModel>().notes.map((n) {
                return IntrinsicHeight(
                  child: NoteCard(
                    id: n.id,
                    title: n.title,
                    content: n.content,
                    creationTime: n.creationTime,
                    onNoteDelete: _handleDeleteNote,
                  ),
                );
              }).toList(),
            ),
            IntrinsicHeight(child: AddNoteCard()),
          ],
        ),
        //child: StaggeredGrid.count(
        //crossAxisCount: 2,
        //mainAxisSpacing: 16,
        //crossAxisSpacing: 24, // add some space
        //children: widgetNotes,
        //),
      ),
    );
  }
}
