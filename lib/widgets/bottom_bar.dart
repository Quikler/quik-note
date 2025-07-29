import 'package:flutter/material.dart';
import 'package:quik_note/pages/starred_notes_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<StatefulWidget> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  void _handleOnStarPress() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Material(child: StarredNotesPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        spacing: 8,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.folder)),
          IconButton(onPressed: _handleOnStarPress, icon: Icon(Icons.star)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          IconButton(onPressed: () {}, icon: Icon(Icons.login)),
        ],
      ),
    );
  }
}
