import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quik_note/fill/custom_colors.dart';
import 'package:quik_note/models/note.dart';

class EditNoteForm extends StatefulWidget {
  final Note note;

  final TextEditingController titleController;
  final TextEditingController contentController;
  final FocusNode titleFocusNode;
  final FocusNode contentFocusNode;

  const EditNoteForm({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.note,
    required this.contentFocusNode,
    required this.titleFocusNode,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditNoteFormState();
  }
}

class _EditNoteFormState extends State<EditNoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleTitleSubmitted(String? value) {
    widget.contentFocusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
            controller: widget.titleController,
            inputFormatters: [FilteringTextInputFormatter.deny('\n')],
            textInputAction: TextInputAction.next,
            onFieldSubmitted: _handleTitleSubmitted,
            maxLines: null,
            autovalidateMode: AutovalidateMode.always,
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: CustomColors.purple70),
              border: InputBorder.none,
              hintText: "Untitiled",
            ),
            focusNode: widget.titleFocusNode,
            style: TextStyle(fontSize: 24, color: CustomColors.purple),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: widget.contentController,
            decoration: const InputDecoration(
              hintText: "Note something here",
              hintStyle: TextStyle(color: CustomColors.purple70),
              border: InputBorder.none,
            ),
            focusNode: widget.contentFocusNode,
            style: TextStyle(color: CustomColors.purple),
            minLines: 6,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
