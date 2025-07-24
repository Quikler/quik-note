import 'package:flutter/material.dart';

class NoteFormWrapper extends StatelessWidget {
  final Widget child;

  const NoteFormWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 40, left: 32, right: 32),
      child: child,
    );
  }
}
