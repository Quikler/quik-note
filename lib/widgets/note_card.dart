import 'package:flutter/material.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({super.key});

  @override
  State<StatefulWidget> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFFBFBF9),
        borderRadius: BorderRadius.all(Radius.circular(48)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.cyan,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: Color(0xFFFBFBF9),
                size: 64,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Shoping List For August",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF380099),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text("Aug 21, 2021", style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
