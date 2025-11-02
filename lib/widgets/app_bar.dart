import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/viewmodels/app_bar_viewmodel.dart';
import 'package:quik_note/viewmodels/navigation_viewmodel.dart';
import 'package:quik_note/viewmodels/notes_viewmodel.dart';
import 'package:quik_note/viewmodels/todos_viewmodel.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/widgets/note_button.dart';
import 'package:quik_note/widgets/search_bar.dart';
import 'package:quik_note/widgets/todo_button.dart';
class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final appBarViewModel = context.watch<AppBarViewModel>();
    final navigationViewModel = context.watch<NavigationViewModel>();

    void handleSelectedItemsDelete() async {
      final isNotesPage = navigationViewModel.isNotesPage;
      final selectedIds = isNotesPage
          ? context.read<NotesViewModel>().selectedNoteIds.toList()
          : context.read<TodosViewModel>().selectedTodoIds.toList();

      if (selectedIds.isEmpty) {
        return;
      }

      final itemType = isNotesPage ? "note" : "todo";
      final dialogTitle = selectedIds.length == 1
          ? "Delete selected $itemType?"
          : "Delete selected ${itemType}s?";
      final dialogContent = isNotesPage
          ? "These notes will be permanently deleted. Do you want to proceed?"
          : "These todos will be permanently deleted. Do you want to proceed?";

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
        if (isNotesPage) {
          await context.read<NotesViewModel>().deleteSelectedNotes();
        } else {
          await context.read<TodosViewModel>().deleteSelectedTodos();
        }
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
                if (navigationViewModel.isNotesPage) {
                  context.read<NotesViewModel>().clearSelection();
                } else {
                  context.read<TodosViewModel>().clearSelection();
                }
                context.read<AppBarViewModel>().exitSelectMode();
              },
            ),
            IconButton(
              color: Colors.white,
              onPressed: handleSelectedItemsDelete,
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
