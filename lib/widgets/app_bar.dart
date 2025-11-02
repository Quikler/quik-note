import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/viewmodels/app_bar_viewmodel.dart';
import 'package:quik_note/viewmodels/notes_viewmodel.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/widgets/note_button.dart';
import 'package:quik_note/widgets/search_bar.dart';
import 'package:quik_note/widgets/todo_button.dart';
class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final appBarViewModel = context.watch<AppBarViewModel>();
    void handleSelectedNotesDelete() async {
      final notesViewModel = context.read<NotesViewModel>();
      final selectedIds = notesViewModel.selectedNoteIds.toList();
      if (selectedIds.isEmpty) {
        return;
      }
      final dialogTitle = selectedIds.length == 1
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
        await notesViewModel.deleteSelectedNotes();
        appBarViewModel.exitSelectMode();
      }
    }
    List<Widget> children = [];
    if (!appBarViewModel.isSelectMode) {
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
    } else {
      children = [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.close, size: 28),
              onPressed: () {
                final notesViewModel = context.read<NotesViewModel>();
                notesViewModel.clearSelection();
                context.read<AppBarViewModel>().exitSelectMode();
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
        top: deviceHeight(context) * 0.03 + deviceStatusBar(context),
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
