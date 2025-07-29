import 'package:flutter/material.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/widgets/note_button.dart';
import 'package:quik_note/widgets/search_bar.dart';
import 'package:quik_note/widgets/todo_button.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        // MediaQuery.of(context).padding.top indicates height of status bar in android and ios
        top: deviceHeight(context) * 0.03 + MediaQuery.of(context).padding.top,
        bottom: deviceHeight(context) * 0.03,
        left: deviceWidth(context) * 0.05,
        right: deviceWidth(context) * 0.05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff5E00FF), Color(0x59380099)],
        ),
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 24,
            children: [
              Expanded(child: NoteButton()),
              Expanded(child: TodoButton()),
            ],
          ),
        ],
      ),
    );
  }
}
