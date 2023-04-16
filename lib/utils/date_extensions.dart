import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get niceDateTimeString {
    return DateFormat('dd MMM yyyy, hh:mm a').format(this);
  }
}
