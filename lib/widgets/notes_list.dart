import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/fill/custom_colors.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/utils/helpers.dart';
import 'package:quik_note/utils/huminizer.dart';
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
    //context.read<NotesListModel>().initTest();
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
              children: context
                  .watch<NotesListModel>()
                  .notes
                  .groupBy(
                    (n) => getHuminizedDate(n.lastEditedTime ?? n.creationTime),
                  )
                  .entries
                  .map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            color: CustomColors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
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
                                  (n) => NoteCard(
                                    note: n,
                                    onNoteDelete: _handleDeleteNote,
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
