import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/forms/edit_note_form.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/utils/helpers.dart';

import '../wrappers/main_wrapper.dart';
import '../wrappers/main_wrapper_margin.dart';

class EditNoteFormPage extends StatefulWidget {
  final Note note;

  const EditNoteFormPage({super.key, required this.note});

  @override
  State<StatefulWidget> createState() => _EditNoteFormPageState();
}

class _EditNoteFormPageState extends State<EditNoteFormPage> {
  static const String _untitled = "Untitled";
  String _appTitle = _untitled;

  String? _title;
  String? _content;

  bool _isSaveButtonVisible() {
    return !isNullOrEmpty(_title) || !isNullOrEmpty(_content);
  }

  void _handleTitleChange(String? value) {
    setState(() {
      _title = value;
      if (!isNullOrEmpty(value)) {
        _appTitle = value!;
      } else {
        _appTitle = _untitled;
      }
    });
  }

  void _handleContentChange(String? value) {
    setState(() {
      _content = value;
    });
  }

  void _handleBackButtonPressed() async {
    await _updateNoteWithPop();
  }

  void _handleSaveButtonPressed() async {
    await _updateNoteWithPop();
  }

  Future<void> _updateNote() async {
    if (_title != null) {
      final noteToUpdate = Note(
        widget.note.id,
        _title!,
        _content,
        widget.note.creationTime,
      );

      final count = await updateNote(noteToUpdate);

      if (mounted && count > 0) {
        context.read<NotesListModel>().updateNote(noteToUpdate);
      }
    }
  }

  Future<void> _updateNoteWithPop() async {
    await _updateNote();

    if (mounted) {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        actions: [
          // The rightest button in actions
          Visibility(
            visible: _isSaveButtonVisible(),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                iconSize: 24,
                onPressed: _handleSaveButtonPressed,
                icon: Icon(Icons.check),
              ),
            ),
          ),
        ],
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
        title: Text(_appTitle),
        foregroundColor: Colors.white,
      ),
      body: MainWrapper(
        child: SingleChildScrollView(
          child: MainWrapperMargin(
            child: EditNoteForm(
              note: widget.note,
              onTitleChange: _handleTitleChange,
              onContentChange: _handleContentChange,
            ),
          ),
        ),
      ),
    );
  }
}
