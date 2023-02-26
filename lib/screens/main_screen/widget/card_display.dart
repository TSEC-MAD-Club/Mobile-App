import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/main_screen/widget/schedule_card.dart';
import 'package:tsec_app/utils/faculty_details.dart';
import '../../../models/timetable_model/timetable_model.dart';
import '../../../provider/timetable_provider.dart';
import '../../../utils/timetable_util.dart';

final dayProvider = StateProvider.autoDispose<String>((ref) {
  String day = getweekday(DateTime.now().weekday);
  return day;
});

class CardDisplay extends ConsumerStatefulWidget {
  const CardDisplay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardDisplayState();
}

class _CardDisplayState extends ConsumerState<CardDisplay> {
  static const colorList = [Colors.red, Colors.teal, Colors.blue];
  static const opacityList = [
    Color.fromRGBO(255, 0, 0, 0.2),
    Color.fromARGB(51, 0, 255, 225),
    Color.fromARGB(51, 0, 153, 255),
  ];

  Future<String> getFacultyImageUrl(String facultyName) async {
    final ref =
        FirebaseStorage.instance.ref().child("faculty/comps/$facultyName.jpg");
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(weekTimetableProvider);
    String day = ref.watch(dayProvider);
    return data.when(
        data: ((data) {
          if (data[day] == null) {
            return const SliverToBoxAdapter(
              child: Center(child: Text("No lectures Today ! ")),
            );
          } else {
            List<TimetableModel> timeTableDay = getTimetablebyDay(data, day);
            return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 2.0,
                ),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                  childCount: timeTableDay.length,
                  (context, index) {
                    var color = colorList[index % 3];
                    var opacity = opacityList[index % 3];
                    return ScheduleCard(
                      color,
                      opacity,
                      lectureEndTime: timeTableDay[index].lectureEndTime,
                      lectureName: timeTableDay[index].lectureName,
                      lectureStartTime: timeTableDay[index].lectureStartTime,
                      facultyImageurl: getFacultyImagebyName(
                          timeTableDay[index].lectureFacultyName),
                      facultyName: timeTableDay[index].lectureFacultyName,
                      lectureBatch: timeTableDay[index].lectureBatch,
                    );
                  },
                )));
          }
        }),
        error: ((error, stackTrace) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('Error Contact us and report problem')),
          );
        }),
        loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ));
  }

  List<TimetableModel> getTimetablebyDay(
      Map<String, dynamic> data, String day) {
    List<TimetableModel> timeTableDay = [];
    final daylist = data[day];
    for (final item in daylist) {
      StudentModel? studentModel = ref.watch(studentModelProvider);
      if (item['lectureBatch'] == studentModel!.batch.toString() ||
          item['lectureBatch'] == 'All')
        timeTableDay.add(TimetableModel.fromJson(item));
    }
    return timeTableDay;
  }
}
