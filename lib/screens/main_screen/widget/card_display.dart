import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/screens/main_screen/widget/schedule_card.dart';
import '../../../provider/timetable_provider.dart';

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
    var timeTableDay = ref.watch(timetableProvider);
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
  }
}
