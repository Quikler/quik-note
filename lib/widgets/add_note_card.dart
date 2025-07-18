import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quik_note/svgs/common.dart';

class AddNoteCard extends StatefulWidget {
  final double maxHeight;

  const AddNoteCard({super.key, this.maxHeight = 200});

  @override
  State<StatefulWidget> createState() => _AddNoteCardState();
}

class _AddNoteCardState extends State<AddNoteCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0x80FBFBF9),
        borderRadius: BorderRadius.all(Radius.circular(48)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Container(
            alignment: Alignment.center,
            child: SvgPicture.string(plusCircleSvg, width: 48),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                textAlign: TextAlign.center,
                "Add note",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
