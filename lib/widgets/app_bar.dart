import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/widgets/note_button.dart';
import 'package:quik_note/widgets/todo_button.dart';

import '../svgs/common.dart';

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
          Container(
            width: deviceWidth(context) / 1.5,
            padding: EdgeInsets.only(left: 48, right: 16),
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.white.withAlpha(80)),
              borderRadius: BorderRadius.all(Radius.circular(324)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFF3E15B9)],
              ).withOpacity(0.12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Note",
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: SvgPicture.string(
                    width: 20,
                    magnifierGlassSvg,
                    semanticsLabel: 'Magnifier glass',
                  ),
                ),
              ],
            ),
          ),
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
