import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/fill/custom_colors.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/models/notifiers/app_bar_model.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/utils/helpers.dart';
import 'package:quik_note/utils/huminizer.dart';
import 'package:quik_note/widgets/add_note_card.dart';
import 'package:quik_note/widgets/note_card.dart';
import 'package:quik_note/wrappers/main_wrapper_margin.dart';
import 'package:quik_note/wrappers/responsive_text.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<StatefulWidget> createState() => _NoteListState();
}

class _NoteListState extends State<NotesList> {
  void _loadNotes() async {
    final notesContext = context.read<NotesListModel>();
    if (notesContext.isInStarMode) {
      await notesContext.getStarredFromDb();
      return;
    }

    await notesContext.getFromDb();
  }

  void _handleDeleteNote(int? id) {
    if (id != null) {
      context.read<NotesListModel>().deleteNote(id);
    }
  }

  void _handleLongPress(Note note) {
    final appBarContext = context.read<AppBarModel>();
    appBarContext.toggleMode(AppBarMode.select);

    context.read<NotesListModel>().selectedNotes[note.id!] = note;
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final appBarMode = context.watch<AppBarModel>().mode;

    final notesContext = context.watch<NotesListModel>();

    List<Note> children;
    if (notesContext.isInStarMode) {
      children = notesContext.starredNotes;
    } else {
      children = notesContext.notes;
    }

    return SingleChildScrollView(
      child: MainWrapperMargin(
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 16,
              children: children
                  .groupBy(
                    (n) => getHuminizedDate(n.lastEditedTime ?? n.creationTime),
                  )
                  .entries
                  .map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        ResponsiveText(
                          entry.key,
                          style: TextStyle(
                            color: CustomColors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFBFBF9),
                            border: BoxBorder.all(color: CustomColors.purple),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            children: entry.value
                                .map(
                                  (n) => GestureDetector(
                                    onLongPress: () => _handleLongPress(n),
                                    child: NoteCard(
                                      isCheckBoxVisible:
                                          appBarMode == AppBarMode.select,
                                      note: n,
                                      onNoteDelete: _handleDeleteNote,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    );
                  })
                  .toList(),
            ),
            AddNoteCard(),
          ],
        ),
      ),
    );
  }
}
