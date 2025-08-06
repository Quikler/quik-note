import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/fill/custom_colors.dart';
import 'package:quik_note/forms/create_note_form.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/utils/helpers.dart';
import 'package:quik_note/wrappers/note_form_wrapper.dart';
import 'package:quik_note/wrappers/responsive_text.dart';

import 'package:quik_note/wrappers/main_wrapper.dart';

class CreateNoteFormPage extends StatefulWidget {
  const CreateNoteFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateNoteFormPageState();
}

class _CreateNoteFormPageState extends State<CreateNoteFormPage> {
  static const String _untitled = "Untitled";
  String _appTitle = _untitled;
  bool _isSaveButtonVisible = false;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final FocusNode contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Listen for title change
    _titleController.addListener(() {
      final value = _titleController.text;
      setState(() {
        if (!value.isNullOrWhiteSpace) {
          _isSaveButtonVisible = true;
          _appTitle = value;
        } else {
          _appTitle = _untitled;
          if (_contentController.text.isNullOrWhiteSpace) {
            _isSaveButtonVisible = false;
          }
        }
      });
    });

    // Listen for content change
    _contentController.addListener(() {
      final value = _contentController.text;
      setState(() {
        if (!value.isNullOrWhiteSpace) {
          _isSaveButtonVisible = true;
        } else if (_titleController.text.isNullOrWhiteSpace) {
          _isSaveButtonVisible = false;
        }
      });
    });
  }

  void _handleBackButtonPressed() {
    _pop();
  }

  void _handleSaveButtonPressed() {
    _pop();
  }

  void _handlePopOfPopScope(bool didPop, Object? result) async {
    await _insertNewNoteWithPop();
  }

  void _pop() {
    Navigator.maybePop(context);
  }

  Future<void> _insertNewNote() async {
    final title = _titleController.text, content = _contentController.text;
    if (title.isNullOrWhiteSpace && content.isNullOrWhiteSpace) {
      return;
    }

    final newNote = Note(null, title, content, DateTime.now(), null);
    final newNoteId = await insertNote(newNote);

    final newNoteWithId = Note(
      newNoteId,
      newNote.title,
      newNote.content,
      newNote.creationTime,
      null,
    );

    if (mounted) {
      context.read<NotesListModel>().insertStartNote(newNoteWithId);
    }
  }

  Future<void> _insertNewNoteWithPop() async {
    await _insertNewNote();
    _pop();
  }

  void _showMoreMenu(TapDownDetails details) async {
    final posOffset = details.globalPosition;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(posOffset.dx, posOffset.dy, 0, 0),
      items: [
        PopupMenuItem(
          child: GestureDetector(
            onTap: _handleCopy,
            child: Row(
              spacing: 12,
              children: [Icon(Icons.copy), const Text("Copy")],
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: _handlePaste,
            child: Row(
              spacing: 12,
              children: [Icon(Icons.paste), const Text("Paste")],
            ),
          ),
        ),
      ],
    );
  }

  void _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: _contentController.text));
    if (mounted) {
      contentFocusNode.requestFocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Content successfully copied to clipboard",
            style: TextStyle(color: CustomColors.purple),
          ),
        ),
      );
    }
  }

  void _handlePaste() async {
    final clipboardData = await Clipboard.getData("text/plain");
    if (clipboardData != null) {
      final cursorPos = _contentController.selection.base.offset;

      final textBeforeCursor = _contentController.text.substring(0, cursorPos);
      final textAfterCursor = _contentController.text.substring(cursorPos);

      final textBeforeAndPasted = textBeforeCursor + clipboardData.text!;
      final updatedText = textBeforeAndPasted + textAfterCursor;

      _contentController.value = _contentController.value.copyWith(
        text: updatedText,
        selection: TextSelection.collapsed(offset: textBeforeAndPasted.length),
      );
    }

    if (mounted) {
      contentFocusNode.requestFocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Clipboard text successfully pasted into content",
            style: TextStyle(color: CustomColors.purple),
          ),
        ),
      );
    }
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
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(432)),
                onTapDown: _showMoreMenu,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.more_vert),
                ),
              ),
            ),
            Visibility(
              visible: _isSaveButtonVisible,
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
          title: ResponsiveText(_appTitle),
          foregroundColor: Colors.white,
        ),
        body: MainWrapper(
          child: SingleChildScrollView(
            child: NoteFormWrapper(
              child: CreateNoteForm(
                titleController: _titleController,
                contentController: _contentController,
                contentFocusNode: contentFocusNode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
