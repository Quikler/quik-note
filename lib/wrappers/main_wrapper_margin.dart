import 'package:flutter/material.dart';
import 'package:quik_note/utils/widget_helpers.dart';

class MainWrapperMargin extends StatelessWidget {
  final Widget child;

  const MainWrapperMargin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: deviceHeight(context) * 0.03,
        bottom: deviceHeight(context) * 0.03,
        left: deviceWidth(context) * 0.04,
        right: deviceWidth(context) * 0.04,
      ),
      child: child,
    );
  }
}
