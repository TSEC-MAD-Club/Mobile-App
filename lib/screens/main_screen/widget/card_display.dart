import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/screens/main_screen/widget/schedule_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(weekTimetableProvider);
    String day = ref.watch(dayProvider);
    return data.when(
        data: ((data) {
          if (day == 'Saturday' || day == 'Sunday') {
            return const SliverToBoxAdapter(
              child: Center(child: Text("No lectures Today ! ")),
            );
          } else {
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
                          timeTableDay[index].lectureFacultyImageurl,
                      facultyName: timeTableDay[index].lectureFacultyName,
                    );
                  },
                ),
              ),
            );
          }
        }),
        error: ((error, stackTrace) => const SliverToBoxAdapter(
              child: Text('Error'),
            )),
        loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ));
  }

  List<TimetableModel> getTimetablebyDay(
      Map<String, dynamic> data, String day) {
    List<TimetableModel> timeTableDay = [];
    final daylist = data[day];
    for (final item in daylist) {
      timeTableDay.add(TimetableModel.fromJson(item));
    }
    return timeTableDay;
  }
}
