import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/forms/edit_note_form.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/utils/helpers.dart';

import 'package:quik_note/wrappers/main_wrapper.dart';
import 'package:quik_note/wrappers/main_wrapper_margin.dart';

class EditNoteFormPage extends StatefulWidget {
  final Note note;

  const EditNoteFormPage({super.key, required this.note});

  @override
  State<StatefulWidget> createState() => _EditNoteFormPageState();
}

class _EditNoteFormPageState extends State<EditNoteFormPage> {
  static const String _untitled = "Untitled";

  String? _initialTitle;
  String? _initialContent;

  String? _title;
  String? _content;

  bool _isNoteChanged() =>
      _initialTitle != _title || _initialContent != _content;

  bool _isSaveButtonVisible() {
    return !_title.isNullOrWhiteSpace || !_content.isNullOrWhiteSpace;
  }

  String _getAppTitle() {
    return !_title.isNullOrWhiteSpace ? _title! : _untitled;
  }

  void _handleTitleChange(String? value) {
    setState(() {
      _title = value;
    });
  }

  void _handleContentChange(String? value) {
    setState(() {
      _content = value;
    });
  }

  void _handleBackButtonPressed() {
    _pop();
  }

  void _handleSaveButtonPressed() {
    _pop();
  }

  void _handlePopOfPopScope(bool didPop, Object? result) async {
    await _updateNoteWithPop();
  }

  void _pop() {
    Navigator.maybePop(context);
  }

  Future<void> _updateNote() async {
    if (!_isNoteChanged()) {
      return;
    }

    // if title and content is null it means no info will be saved so delete it
    if (_title.isNullOrWhiteSpace && _content.isNullOrWhiteSpace) {
      final deletionCount = await deleteNote(widget.note.id!);
      if (mounted && deletionCount > 0) {
        context.read<NotesListModel>().deleteNote(widget.note.id!);
      }
      return;
    }

    final noteToUpdate = Note(
      widget.note.id,
      _title,
      _content,
      widget.note.creationTime,
      DateTime.now(),
    );

    final count = await updateNote(noteToUpdate);

    if (mounted && count > 0) {
      context.read<NotesListModel>().deleteAndInsertStartNote(noteToUpdate);
    }
  }

  Future<void> _updateNoteWithPop() async {
    await _updateNote();
    _pop();
  }

  @override
  void initState() {
    super.initState();
    _initialTitle = widget.note.title;
    _initialContent = widget.note.content;

    _title = widget.note.title;
    _content = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _handlePopOfPopScope,
      child: Scaffold(
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
          title: Text(_getAppTitle()),
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
      ),
    );
  }
}
