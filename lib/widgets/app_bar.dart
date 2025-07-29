import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/notifiers/app_bar_model.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/widgets/note_button.dart';
import 'package:quik_note/widgets/search_bar.dart';
import 'package:quik_note/widgets/todo_button.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarContext = context.watch<AppBarModel>();

    void handleSelectedNotesDelete() async {
      final notesContext = context.read<NotesListModel>();
      final ids = notesContext.selectedNotes.keys.toList();
      if (ids.isEmpty) {
        return;
      }

      final dialogTitle = ids.length == 1
          ? "Delete selected note?"
          : "Delete selected notes?";
      final dialogContent =
          "This notes will be permanently deleted. Wanna proceed?";

      final dialogResult = await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Delete'),
              child: const Text("Delete", style: TextStyle(color: Colors.pink)),
            ),
          ],
        ),
      );

      if (dialogResult == 'Delete') {
        final count = await deleteNotes(ids);

        if (count > 0) {
          notesContext.clearSelected();
          notesContext.deleteNotes(ids);
          appBarContext.toggleMode(AppBarMode.initial);
        }
      }
    }

    List<Widget> children = [];
    if (appBarContext.mode == AppBarMode.initial) {
      final notesContext = context.read<NotesListModel>();
      notesContext.selectedNotes.clear();
      children = [
        SearchBarWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 24,
          children: [
            Expanded(child: NoteButton()),
            Expanded(child: TodoButton()),
          ],
        ),
      ];
    } else if (appBarContext.mode == AppBarMode.select) {
      children = [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.close, size: 28),
              onPressed: () {
                context.read<AppBarModel>().toggleMode(AppBarMode.initial);
              },
            ),
            IconButton(
              color: Colors.white,
              onPressed: handleSelectedNotesDelete,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ];
    }

    return Container(
      padding: EdgeInsets.only(
        // MediaQuery.of(context).padding.top indicates height of status bar in android and ios
        top: deviceHeight(context) * 0.03 + MediaQuery.of(context).padding.top,
        bottom: deviceHeight(context) * 0.03,
        left: deviceWidth(context) * 0.05,
        right: deviceWidth(context) * 0.05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff5E00FF), Color(0x59380099)],
        ),
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
