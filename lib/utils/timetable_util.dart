import 'package:flutter/material.dart';
import 'package:tsec_app/models/occassion_model/occasion_model.dart';

String getweekday(int num) {
  switch (num) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Monday';
  }
}

String checkOccasion(DateTime day, List<OccasionModel> occasions) {
  for (final occasion in occasions) {
    if (DateTime.parse(occasion.occasionDate) == DateUtils.dateOnly(day)) {
      return occasion.occasionName;
    }
  }
  return "";
}
