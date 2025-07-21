import 'package:flutter/material.dart';
import 'package:quik_note/fill/custom_colors.dart';

class CreateNoteForm extends StatefulWidget {
  final void Function(String?) onTitleChange;
  final void Function(String?) onContentChange;

  const CreateNoteForm({
    super.key,
    required this.onTitleChange,
    required this.onContentChange,
  });

  @override
  State<StatefulWidget> createState() {
    return _CreateNoteFormState();
  }
}

class _CreateNoteFormState extends State<CreateNoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleTitleChange(String? value) {
    widget.onTitleChange(value);
  }

  void _handleContentChange(String? value) {
    widget.onContentChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
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
