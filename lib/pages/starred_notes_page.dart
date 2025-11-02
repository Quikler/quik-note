import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/viewmodels/notes_viewmodel.dart';
import 'package:quik_note/widgets/notes_list.dart';
import 'package:quik_note/wrappers/main_wrapper.dart';
import 'package:quik_note/wrappers/responsive_text.dart';
class StarredNotesPage extends StatefulWidget {
  const StarredNotesPage({super.key});
  @override
  State<StatefulWidget> createState() => _StarredNotesPageState();
}
class _StarredNotesPageState extends State<StarredNotesPage> {
  void _handleBackButtonPressed() {
    Navigator.maybePop(context);
  }
  void _handlePopOfPopScope(bool didPop, Object? result) {
    context.read<NotesViewModel>().loadNotes();
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesViewModel>().loadStarredNotes();
    });
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _handlePopOfPopScope,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          leading: BackButton(
            style: ButtonStyle(iconSize: WidgetStatePropertyAll(24)),
            onPressed: _handleBackButtonPressed,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff5E00FF), Color(0x59380099)],
              ),
            ),
          ),
          title: ResponsiveText("Starred notes"),
          foregroundColor: Colors.white,
        ),
        body: MainWrapper(
          child: Column(children: [Expanded(child: NotesList())]),
        ),
      ),
    );
  }
}
