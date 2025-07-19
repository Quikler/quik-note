import 'package:flutter/material.dart';
import 'package:quik_note/forms/create_note_form.dart';
import 'package:quik_note/utils/helpers.dart';

import '../wrappers/main_wrapper.dart';
import '../wrappers/main_wrapper_margin.dart';

class CreateNoteFormPage extends StatefulWidget {
  const CreateNoteFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateNoteFormPageState();
}

class _CreateNoteFormPageState extends State<CreateNoteFormPage> {
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

  void _handleBackButtonPressed() {
    Navigator.maybePop(context);
  }

  void _handleSaveButtonPressed() {}

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
            child: CreateNoteForm(
              onTitleChange: _handleTitleChange,
              onContentChange: _handleContentChange,
            ),
          ),
        ),
      ),
    );
  }
}
