import 'package:flutter/material.dart';

double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

// MediaQuery.of(context).padding.top indicates height of status bar in android and ios
double deviceStatusBar(BuildContext context) =>
    MediaQuery.of(context).padding.top;

double noteFormPageAppBarHeight() => 75;

int linesByLineHeight(
  BuildContext context,
  double screenPercent, {
  double lineHeight = 24.0,
}) {
  return (deviceHeight(context) * 0.6 / lineHeight).floor();
}
