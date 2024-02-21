import 'package:intl/intl.dart';

DateTime dmyDate(DateTime date) {
  int day = date.day;
  int month = date.month;
  int year = date.year;

  DateTime customDateTime = DateTime(year, month, day);
  return customDateTime;
}

String formatDate(DateTime date) {
  String formattedDate = DateFormat('d MMMM y').format(date);
  return formattedDate;
}
