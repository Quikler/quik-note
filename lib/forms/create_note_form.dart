import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quik_note/fill/custom_colors.dart';
import 'package:quik_note/utils/widget_helpers.dart';
class CreateNoteForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final FocusNode contentFocusNode;
  const CreateNoteForm({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.contentFocusNode,
  });
  @override
  State<StatefulWidget> createState() {
    return _CreateNoteFormState();
  }
}
class _CreateNoteFormState extends State<CreateNoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _handleTitleSubmitted(String? value) {
    widget.contentFocusNode.requestFocus();
  }
  @override
  void initState() {
    super.initState();
    widget.contentFocusNode.requestFocus();
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
            style: TextStyle(fontSize: 24, color: CustomColors.purple),
          ),
          TextFormField(
            controller: widget.contentController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: "Note something here",
              hintStyle: TextStyle(color: CustomColors.purple70),
              border: InputBorder.none,
            ),
            focusNode: widget.contentFocusNode,
            style: TextStyle(color: CustomColors.purple),
            minLines: linesByLineHeight(context, 0.6),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
