import 'package:intl/intl.dart';
import 'package:quik_note/utils/helpers.dart';

String getHuminizedDate(DateTime dateTime) {
  final now = DateTime.now();

  if (dateTime.isToday) {
    return "Today";
  } else if (dateTime.isYesterday) {
    return "Yesterday";
  } else if (dateTime.isBetween(now.subtract(const Duration(days: 7)), now)) {
    return "Previous 7 days";
  } else if (dateTime.isBetween(now.subtract(const Duration(days: 30)), now)) {
    return "Previous 30 days";
  } else if (dateTime.year == now.year) {
    return DateFormat.MMMM().format(dateTime);
  } else {
    return dateTime.year.toString();
  }
}
