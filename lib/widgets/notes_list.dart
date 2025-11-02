import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/fill/custom_colors.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/viewmodels/app_bar_viewmodel.dart';
import 'package:quik_note/viewmodels/notes_viewmodel.dart';
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
    final notesViewModel = context.read<NotesViewModel>();
    await notesViewModel.loadNotes();
  }

  void _handleDeleteNote(int? id) {
    if (id != null) {
      context.read<NotesViewModel>().deleteNote(id);
    }
  }

  void _handleLongPress(Note note) {
    final appBarViewModel = context.read<AppBarViewModel>();
    appBarViewModel.enterSelectMode();

    if (note.id != null) {
      context.read<NotesViewModel>().toggleNoteSelection(note.id!);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarViewModel = context.watch<AppBarViewModel>();
    final notesViewModel = context.watch<NotesViewModel>();

    final children = notesViewModel.displayedNotes;

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
                                          appBarViewModel.isSelectMode,
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
