import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/occassion_model/occasion_model.dart';

import '../models/student_model/student_model.dart';
import '../models/timetable_model/timetable_model.dart';
import '../provider/auth_provider.dart';

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

List<TimetableModel> getTimetablebyDay(Map<String, dynamic> data, String day,List<String> respectiveRoomNo, WidgetRef ref) {
  List<TimetableModel> timeTableDay = [];
  final daylist = data[day];
  for (final item in daylist) {
    StudentModel? studentModel = ref.watch(userModelProvider)?.studentModel;

    if (item['lectureBatch'] == studentModel!.batch.toString() || item['lectureBatch'] == 'All') {
      if (item['lectureFacultyName'] != null) {
        timeTableDay.add(TimetableModel.fromJson(item));
      } else {
        item['lectureFacultyName'] = " ";
        timeTableDay.add(TimetableModel.fromJson(item));
      }
      if(item["lectureRoomNo"]!=null){
        respectiveRoomNo.add(item["lectureRoomNo"]);
      }else{
        respectiveRoomNo.add("");
      }
    }
  }
  return timeTableDay;
}

bool checkLabs(String lectureName) {
  if (lectureName.toLowerCase().endsWith('labs') || lectureName.toLowerCase().endsWith('lab')) {
    return true;
  }
  return false;
}

bool checkTimetable(String lectureFacultyName) {
  if (lectureFacultyName.isEmpty || lectureFacultyName == " ") return true;
  return true;
}



