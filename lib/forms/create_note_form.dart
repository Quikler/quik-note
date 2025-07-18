import 'package:flutter/material.dart';

import '../data/db.dart';
import '../main.dart';
import '../models/note.dart';

class CreateNoteForm extends StatefulWidget {
  const CreateNoteForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateNoteFormState();
  }
}

class _CreateNoteFormState extends State<CreateNoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isCreateNoteButtonDisabled = true;
  String? _title;
  String? _content;

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final newNote = Note(null, _title!, _content, DateTime.now());
      final newNoteId = await insertNote(newNote);
      final newNoteWithId = Note(
        newNoteId,
        newNote.title,
        newNote.content,
        newNote.creationTime,
      );

      MyApp.homePageStateKey.currentState?.setState(() {
        MyApp.homePageStateKey.currentState?.notes.add(newNoteWithId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 14,
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            decoration: const InputDecoration(
              hintText: "Note title",
              border: OutlineInputBorder(),
            ),
            onChanged: (String? value) {
              setState(() {
                _title = value;
                _isCreateNoteButtonDisabled = value == null || value.isEmpty;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Note title is required';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Note content",
              border: OutlineInputBorder(),
            ),
            minLines: 6,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (String? value) {
              _content = value;
            },
          ),
          FilledButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                return _isCreateNoteButtonDisabled
                    ? Colors.blue.withValues(alpha: 0.5)
                    : Colors.blue;
              }),
            ),
            onPressed: _isCreateNoteButtonDisabled ? null : _handleSubmit,
            child: const Text("Create note"),
          ),
        ],
      ),
    );
  }
}
