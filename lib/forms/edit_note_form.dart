import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quik_note/fill/custom_colors.dart';
import 'package:quik_note/models/note.dart';

class EditNoteForm extends StatefulWidget {
  final void Function(String?) onTitleChange;
  final void Function(String?) onContentChange;
  final Note note;

  const EditNoteForm({
    super.key,
    required this.onTitleChange,
    required this.onContentChange,
    required this.note,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditNoteFormState();
  }
}

class _EditNoteFormState extends State<EditNoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _contentFocusNote = FocusNode();

  String? _title;
  String? _content;

  void _handleTitleChange(String? value) {
    widget.onTitleChange(value);
  }

  void _handleContentChange(String? value) {
    widget.onContentChange(value);
  }

  void _handleTitleSubmitted(String? value) {
    _contentFocusNote.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    _title = widget.note.title;
    _content = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
            inputFormatters: [FilteringTextInputFormatter.deny('\n')],
            textInputAction: TextInputAction.next,
            onFieldSubmitted: _handleTitleSubmitted,
            initialValue: _title,
            maxLines: null,
            autovalidateMode: AutovalidateMode.always,
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: CustomColors.purple70),
              border: InputBorder.none,
              hintText: "Untitiled",
            ),
            style: TextStyle(fontSize: 24, color: CustomColors.purple),
            onChanged: _handleTitleChange,
          ),
          TextFormField(
            initialValue: _content,
            decoration: const InputDecoration(
              hintText: "Note something here",
              hintStyle: TextStyle(color: CustomColors.purple70),
              border: InputBorder.none,
            ),
            style: TextStyle(color: CustomColors.purple),
            minLines: 6,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: _handleContentChange,
          ),
        ],
      ),
    );
  }
}
