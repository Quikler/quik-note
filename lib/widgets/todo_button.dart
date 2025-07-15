import 'package:flutter/material.dart';

class TodoButton extends StatefulWidget {
  const TodoButton({super.key});

  @override
  State<StatefulWidget> createState() => _TodoButtonState();
}

class _TodoButtonState extends State<TodoButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.white.withAlpha(80)),
        borderRadius: BorderRadius.all(Radius.circular(324)),
        gradient: LinearGradient(
          colors: [Color(0xFF3E15B9), Colors.white],
        ).withOpacity(0.12),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        ),
        child: const Text(
          "To Do",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
