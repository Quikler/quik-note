import 'package:flutter/material.dart';
import 'package:quik_note/core/result.dart';
import 'package:quik_note/models/note.dart';
import 'package:quik_note/services/note_form_service.dart';
class NoteFormViewModel extends ChangeNotifier {
  final NoteFormService _service;
  NoteFormViewModel(this._service);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  String _appTitle = "Untitled";
  bool _isSaveButtonVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  Note? _originalNote;
  String? _initialTitle;
  String? _initialContent;
  TextEditingController get titleController => _titleController;
  TextEditingController get contentController => _contentController;
  FocusNode get titleFocusNode => _titleFocusNode;
  FocusNode get contentFocusNode => _contentFocusNode;
  String get appTitle => _appTitle;
  bool get isSaveButtonVisible => _isSaveButtonVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> initializeForEdit(Note note) async {
    _isLoading = true;
    notifyListeners();
    _originalNote = note;
    final noteToEdit = note.id != null
        ? await _service.loadNoteForEdit(note.id!) ?? note
        : note;
    _initialTitle = noteToEdit.title;
    _initialContent = noteToEdit.content;
    _titleController.text = noteToEdit.title ?? "";
    _contentController.text = noteToEdit.content ?? "";
    _appTitle = noteToEdit.title?.isNotEmpty == true
        ? noteToEdit.title!
        : "Untitled";
    _isSaveButtonVisible = _hasContent();
    _titleController.addListener(_onTitleChanged);
    _contentController.addListener(_onContentChanged);
    _isLoading = false;
    notifyListeners();
  }
  void initializeForCreate() {
    _originalNote = null;
    _initialTitle = null;
    _initialContent = null;
    _titleController.clear();
    _contentController.clear();
    _appTitle = "Untitled";
    _isSaveButtonVisible = false;
    _titleController.addListener(_onTitleChanged);
    _contentController.addListener(_onContentChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentFocusNode.requestFocus();
    });
    notifyListeners();
  }
  void _onTitleChanged() {
    final value = _titleController.text;
    if (value.isNotEmpty) {
      _isSaveButtonVisible = true;
      _appTitle = value;
    } else {
      _appTitle = "Untitled";
      if (_contentController.text.isEmpty) {
        _isSaveButtonVisible = false;
      }
    }
    notifyListeners();
    _cacheCurrentState();
  }
  void _onContentChanged() {
    final value = _contentController.text;
    if (value.isNotEmpty) {
      _isSaveButtonVisible = true;
    } else if (_titleController.text.isEmpty) {
      _isSaveButtonVisible = false;
    }
    notifyListeners();
    _cacheCurrentState();
  }
  bool _hasContent() {
    return _titleController.text.isNotEmpty ||
        _contentController.text.isNotEmpty;
  }
  bool _isNoteChanged() {
    return _initialTitle != _titleController.text ||
        _initialContent != _contentController.text;
  }
  Note _buildNote() {
    return Note(
      id: _originalNote?.id,
      title: _titleController.text,
      content: _contentController.text,
      creationTime: _originalNote?.creationTime ?? DateTime.now(),
      lastEditedTime: _originalNote != null ? DateTime.now() : null,
      starred: _originalNote?.starred ?? false,
    );
  }
  void _cacheCurrentState() {
    if (_originalNote?.id != null) {
      final currentNote = _buildNote();
      _service.cacheNoteDraft(currentNote);
    }
  }
  Future<bool> saveNote() async {
    if (!_isNoteChanged()) {
    }
    if (!_hasContent() && _originalNote?.id != null) {
      return await deleteNote();
    }
    if (!_hasContent()) {
      return false;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final note = _buildNote();
    final result = await _service.saveNote(note);
    _isLoading = false;
    return result.when(
      success: (_) {
        notifyListeners();
        return true;
      },
      failure: (error, _) {
        _errorMessage = 'Failed to save note: ${error.toString()}';
        notifyListeners();
        return false;
      },
    );
  }
  Future<bool> createNote() async {
    if (!_hasContent()) {
      return false;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final note = _buildNote();
    final result = await _service.createNote(note);
    _isLoading = false;
    return result.when(
      success: (_) {
        notifyListeners();
        return true;
      },
      failure: (error, _) {
        _errorMessage = 'Failed to create note: ${error.toString()}';
        notifyListeners();
        return false;
      },
    );
  }
  Future<bool> deleteNote() async {
    if (_originalNote?.id == null) {
      return false;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final result = await _service.deleteNote(_originalNote!.id!);
    _isLoading = false;
    return result.when(
      success: (deleted) {
        notifyListeners();
        return deleted;
      },
      failure: (error, _) {
        _errorMessage = 'Failed to delete note: ${error.toString()}';
        notifyListeners();
        return false;
      },
    );
  }
  String getContentForCopy() {
    return _contentController.text;
  }
  void pasteContent(String clipboardText) {
    final cursorPos = _contentController.selection.base.offset;
    final textBeforeCursor = _contentController.text.substring(0, cursorPos);
    final textAfterCursor = _contentController.text.substring(cursorPos);
    final textBeforeAndPasted = textBeforeCursor + clipboardText;
    final updatedText = textBeforeAndPasted + textAfterCursor;
    _contentController.value = _contentController.value.copyWith(
      text: updatedText,
      selection: TextSelection.collapsed(offset: textBeforeAndPasted.length),
    );
  }
  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _contentController.removeListener(_onContentChanged);
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }
}
