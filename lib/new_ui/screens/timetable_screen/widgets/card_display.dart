import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/occassion_model/occasion_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/schedule_card_modified.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/occasion_provider.dart';
import 'package:tsec_app/new_ui/screens/timetable_screen/widgets/schedule_card.dart';

import 'package:tsec_app/utils/faculty_details.dart';
import 'package:tsec_app/utils/notification_type.dart';
import 'package:tsec_app/models/timetable_model/timetable_model.dart';
import 'package:tsec_app/provider/timetable_provider.dart';
import 'package:tsec_app/utils/timetable_util.dart';

final dayProvider = StateProvider.autoDispose<DateTime>((ref) {
  DateTime day = DateTime.now();
  return day;
});

class CardDisplay extends ConsumerStatefulWidget {
  const CardDisplay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardDisplayState();
}

class _CardDisplayState extends ConsumerState<CardDisplay> {
  static const colorList = [Colors.red, Colors.teal];
  static const opacityList = [
    Color.fromRGBO(255, 0, 0, 0.2),
    Color.fromARGB(51, 0, 255, 225),
  ];

  Future<String> getFacultyImageUrl(String facultyName) async {
    final ref = FirebaseStorage.instance.ref().child("faculty/comps/$facultyName.jpg");
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }

  List<OccasionModel> occasionList = [];

  void fetchOccasionDetails() {
    ref.watch(occasionListProvider).when(
        data: ((data) {
          occasionList.addAll(data ?? []);
        }),
        loading: () {
          const CircularProgressIndicator();
        },
        error: (Object error, StackTrace? stackTrace) {});
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(counterStreamProvider);
    DateTime day = ref.watch(dayProvider);
    String dayStr = getweekday(day.weekday);
    var _theme = Theme.of(context);

    fetchOccasionDetails();

    final dat = ref.watch(notificationTypeProvider);
    debugPrint("time table batch details: ${dat?.yearBranchDivTopic}");
    return data.when(
        data: ((data) {
          if (data == null) {
            return const Center(
              child: Text(
                "Unable to fetch timetable. Please check if you have entered your details correctly in the profile section.",
                textAlign: TextAlign.center,
              ),
            );
          }
          if (data[dayStr] == null) {
            return const Center(child: Text("Happy Weekend !",style: TextStyle(color: Colors.greenAccent)));
          } else if (checkOccasion(day, occasionList) != "") {
            return Center(child: Text("Happy ${checkOccasion(day, occasionList)}!",style: TextStyle(color: Colors.greenAccent)));
          } else {
            List<TimetableModel> timeTableDay = getTimetablebyDay(data, dayStr);
            if (timeTableDay.isEmpty) {
              return const Center(child: Text("No lectures Today ! "));
            } else {
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: timeTableDay.map((timetableModel) {
                    final lectureFacultyname = timetableModel.lectureFacultyName;
                    return ScheduleCardModified(
                      lectureEndTime: timetableModel.lectureEndTime,
                      lectureName: timetableModel.lectureName,
                      lectureStartTime: timetableModel.lectureStartTime,
                      facultyName: !checkTimetable(lectureFacultyname) ? "---------" : lectureFacultyname,
                      facultyImageurl: checkTimetable(lectureFacultyname) ? getFacultyImagebyName(lectureFacultyname) : "",
                      lectureBatch: timetableModel.lectureBatch,
                    );
                  }).toList(),
                ),
              );
            }
          }
        }),
        error: ((error, stackTrace) {
          return Center(child: Text(error.toString(),));
        }),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  List<TimetableModel> getTimetablebyDay(Map<String, dynamic> data, String day) {
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
}
