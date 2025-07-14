import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../svgs/common.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff5E00FF), Color(0x80380099)],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            padding: EdgeInsets.only(left: 48, right: 16),
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.white.withAlpha(50)),
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
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Note",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.red,
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
        ],
      ),
      //title: Text(widget.title),
    );
  }
}
