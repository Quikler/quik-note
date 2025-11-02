import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/viewmodels/notes_viewmodel.dart';
import 'package:quik_note/svgs/common.dart';
import 'package:quik_note/utils/widget_helpers.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<StatefulWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  void _handleChange(String? value) {
    final notesViewModel = context.read<NotesViewModel>();

    if (value == null || value.isEmpty) {
      notesViewModel.clearSearch();
    } else {
      notesViewModel.searchNotes(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              onChanged: _handleChange,
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
    );
  }
}
