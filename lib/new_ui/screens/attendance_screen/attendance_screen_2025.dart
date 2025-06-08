/*
ATTENDANCE SCREEN REVAMP UNDER THE 25 - 26 TENURE;
THE OLD ATTENDANCE SCREEN IS THE FILE NAMED 'attendance_screen.dart'
*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/date_header_2025.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/attendance_container.dart';

import '../../../models/occassion_model/occasion_model.dart';
import '../../../models/timetable_model/timetable_model.dart';
import '../../../provider/occasion_provider.dart';
import '../../../provider/timetable_provider.dart';
import '../../../screens/main_screen/widget/card_display.dart';
import '../../../utils/timetable_util.dart';

class AttendanceScreen2025 extends ConsumerStatefulWidget {
  const AttendanceScreen2025({super.key});

  @override
  ConsumerState<AttendanceScreen2025> createState() =>
      _AttendanceScreen2025State();
}

class _AttendanceScreen2025State extends ConsumerState<AttendanceScreen2025> {
  double height = 0;
  double width = 0;
  int activeStep = 2;
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
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    final data = ref.watch(counterStreamProvider);
    DateTime day = ref.watch(dayProvider);
    String dayStr = getweekday(day.weekday);
    fetchOccasionDetails();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
              children: [
                DateHeader2025(width: width),
                data.when(
                    data: (data) {
                      if (data == null) {
                        return const Center(
                          child: Text(
                            "Unable to fetch timetable. Please check if you have entered your details correctly in the profile section.",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      if (data[dayStr] == null) {
                        return const Center(
                            child: Text("Happy Weekend !",
                                style: TextStyle(color: Colors.greenAccent)));
                      } else if (checkOccasion(day, occasionList) != "") {
                        return Center(
                            child: Text(
                                "Happy ${checkOccasion(day, occasionList)}!",
                                style: TextStyle(color: Colors.greenAccent)));
                      } else {
                        List<String> respectiveRoomNo = [];
                        List<TimetableModel> timeTableDay =
                            getTimetablebyDay(data, dayStr, respectiveRoomNo, ref);
                        if (timeTableDay.isEmpty) {
                          return const Center(child: Text("No lectures Today ! "));
                        }
                        else {
                          return SingleChildScrollView(
                            child: Column(
                              children: makeTimetableWidgets(timeTableDay)
                            ),
                          );
                        }
                      }
                    },
                    error: ((error, stackTrace) {
                      return Center(
                          child: Text(
                        error.toString(),
                      ));
                    }),
                    loading: () =>
                        const Center(child: CircularProgressIndicator())),
              ],
            )),
      ),
    );
  }
  
  List<Widget> makeTimetableWidgets(List<TimetableModel> timeTableDay) {
    List<Widget> widgets = [];
    for (int i = 0; i < timeTableDay.length; i++) {
      widgets.add(
        AttendanceContainer(
          height: height,
          width: width,
          timetable: timeTableDay[i],
          isFirst: i == 0,
          isLast: i == timeTableDay.length - 1,
        ),
      );
    }
    return widgets;
  }
}
