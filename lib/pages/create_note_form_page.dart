import 'package:flutter/material.dart';
import 'package:quik_note/forms/create_note_form.dart';

import '../wrappers/main_wrapper.dart';
import '../wrappers/main_wrapper_margin.dart';

class CreateNoteFormPage extends StatelessWidget {
  const CreateNoteFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff5E00FF), Color(0x59380099)],
            ),
          ),
        ),
        title: const Text("Create Note"),
        foregroundColor: Colors.white,
      ),
      body: MainWrapper(child: MainWrapperMargin(child: CreateNoteForm())),
    );
  }
}
