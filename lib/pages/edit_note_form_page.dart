import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/fill/custom_colors.dart';
import 'package:quik_note/forms/edit_note_form.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/utils/helpers.dart';
import 'package:quik_note/utils/widget_helpers.dart';

import 'package:quik_note/wrappers/main_wrapper.dart';
import 'package:quik_note/wrappers/note_form_wrapper.dart';
import 'package:quik_note/wrappers/responsive_text.dart';

class EditNoteFormPage extends StatefulWidget {
  final Note note;

  const EditNoteFormPage({super.key, required this.note});

  @override
  State<StatefulWidget> createState() => _EditNoteFormPageState();
}

class _EditNoteFormPageState extends State<EditNoteFormPage> {
  static const String _untitled = "Untitled";
  String _appTitle = _untitled;
  bool _isSaveButtonVisible = false;

  String? _initialTitle;
  String? _initialContent;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();

  bool _isNoteChanged() =>
      _initialTitle != _titleController.text ||
      _initialContent != _contentController.text;

  void _handleBackButtonPressed() => _pop();

  void _handleSaveButtonPressed() => _pop();

  void _handlePopOfPopScope(bool didPop, Object? result) async =>
      await _updateNoteWithPop();

  void _pop() => Navigator.maybePop(context);

  Future<void> _updateNote() async {
    if (!_isNoteChanged()) {
      return;
    }

    // if title and content is null it means no info will be saved so delete it
    if (_titleController.text.isNullOrWhiteSpace &&
        _contentController.text.isNullOrWhiteSpace) {
      final deletionCount = await deleteNote(widget.note.id!);
      if (mounted && deletionCount > 0) {
        context.read<NotesListModel>().deleteNote(widget.note.id!);
      }
      return;
    }

    final noteToUpdate = Note(
      widget.note.id,
      _titleController.text,
      _contentController.text,
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
  void initState() {
    super.initState();
    _initialTitle = widget.note.title;
    _initialContent = widget.note.content;

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

    _titleController.text = widget.note.title ?? "";
    _contentController.text = widget.note.content ?? "";

    final noteContext = context.read<NotesListModel>();

    // Determines if note context is in search mode
    if (noteContext.isInSearchMode) {
      if (noteContext.titleIndexes.containsKey(widget.note.id)) {
        final titleSelection = noteContext.titleIndexes[widget.note.id];
        _titleController.value = _titleController.value.copyWith(
          selection: TextSelection.collapsed(offset: titleSelection!),
        );

        titleFocusNode.requestFocus();
      } else if (noteContext.contentIndexes.containsKey(widget.note.id)) {
        final contentSelection = noteContext.contentIndexes[widget.note.id];
        _contentController.value = _contentController.value.copyWith(
          selection: TextSelection.collapsed(offset: contentSelection!),
        );

        contentFocusNode.requestFocus();
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _handlePopOfPopScope,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: noteFormPageAppBarHeight(),
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
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: NoteFormWrapper(
                child: EditNoteForm(
                  note: widget.note,
                  titleController: _titleController,
                  contentController: _contentController,
                  titleFocusNode: titleFocusNode,
                  contentFocusNode: contentFocusNode,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
