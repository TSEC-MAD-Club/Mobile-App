import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/screens/main_screen/widget/schedule_card.dart';
import '../../../models/timetable_model/timetable_model.dart';
import '../../../provider/timetable_provider.dart';

final dayProvider = StateProvider<String>((ref) {
  return 'Monday';
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

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(weekTimetableProvider);
    String day = ref.watch(dayProvider);
    return data.when(
        data: ((data) {
          List<TimetableModel> timeTableDay = getTimetablebyDay(data, day);
          return SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 2.0,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: timeTableDay.length,
                (context, index) {
                  var color = colorList[index];
                  var opacity = opacityList[index];
                  return ScheduleCard(
                    color,
                    opacity,
                    lectureEndTime: timeTableDay[index].lectureEndTime,
                    lectureName: timeTableDay[index].lectureName,
                    lectureStartTime: timeTableDay[index].lectureStartTime,
                    facultyImageurl:
                        "https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/faculty%2Fcomps%2Fdarakhshankhan.jpg?alt=media&token=18e920bc-a67c-4208-b838-45d9a7845a85",
                    facultyName: timeTableDay[index].lectureFacultyName,
                  );
                },
              ),
            ),
          );
        }),
        error: ((error, stackTrace) => const Text('error')),
        loading: () => const SliverToBoxAdapter(
              child: CircularProgressIndicator(),
            ));
  }

  List<TimetableModel> getTimetablebyDay(
    Map<String, dynamic> data, String day) {
    List<TimetableModel> timeTableDay = [];
    var daylist = data[day];
    for (var item in daylist) {
      var a = TimetableModel.fromJson(item);
      timeTableDay.add(a);
    }
    return timeTableDay;
  }
}
