import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/models/notifiers/current_page_model.dart';
import 'package:quik_note/pages/pages_enum.dart';
import 'package:quik_note/utils/widget_helpers.dart';
import 'package:quik_note/wrappers/responsive_text.dart';

class NoteButton extends StatefulWidget {
  const NoteButton({super.key});

  @override
  State<StatefulWidget> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton> {
  void _handleButtonPress() {
    context.read<CurrentPageModel>().changePage(PagesEnum.notes);
  }

  @override
  Widget build(BuildContext context) {
    final currentPageEnum = context
        .watch<CurrentPageModel>()
        .currentPage
        ?.pageEnum;

    final isNotePage = currentPageEnum == PagesEnum.notes;

    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(
          color: isNotePage ? Colors.red : Colors.white.withAlpha(80),
        ),
        borderRadius: BorderRadius.all(Radius.circular(324)),
        gradient: isNotePage
            ? LinearGradient(colors: [Color(0xFFFF3B3B), Color(0xFF992323)])
            : LinearGradient(
                colors: [Color(0xFF3E15B9), Colors.white],
              ).withOpacity(0.12),
      ),
      child: ElevatedButton(
        onPressed: _handleButtonPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            vertical: deviceHeight(context) * 0.02,
            horizontal: 12,
          ),
        ),
        child: const ResponsiveText(
          "Notes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
