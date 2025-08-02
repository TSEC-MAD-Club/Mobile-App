/*
ATTENDANCE SCREEN REVAMP UNDER THE 25 - 26 TENURE;
THE OLD ATTENDANCE SCREEN IS THE FILE NAMED 'attendance_screen.dart'
*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/add_subject_dialog.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/date_header_2025.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/attendance_container.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/overall_attendance_container.dart';
import 'package:tsec_app/provider/attendance_date_provider.dart';
import 'package:tsec_app/provider/attendance_provider_overall_local.dart';
import 'package:tsec_app/provider/attendance_provider_total_local.dart';
import 'package:tsec_app/services/timetable_service.dart';

import '../../../models/occassion_model/occasion_model.dart';
import '../../../models/timetable_model/timetable_model.dart';
import '../../../provider/occasion_provider.dart';
import '../../../provider/timetable_provider.dart';
import '../../../screens/main_screen/widget/card_display.dart';
import '../../../utils/timetable_util.dart';
import 'attendance_details_screen.dart';

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


  Future<void> loadLocalData() async{

    //setting overall attendance provider
    Map<String,int> data = await loadPreAbsCanDataOverall();
    ref.read(attendanceOverallLocalProvider.notifier).setState(data);

    //setting total attendance provider
    Map<String,int> data1 = await loadPreAbsCanDataTotal();
    ref.read(attendanceTotalLocalProvider.notifier).setState(data1);
  }


  @override
  void initState(){
    super.initState();
    getTimeTablePreAbsCan(DateFormat('yyyy-MM-dd').format(DateTime.now()), ref);
    loadLocalData();
  }

  void callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;

    final data = ref.watch(counterStreamProvider);
    DateTime day = ref.watch(dayProvider);
    String dayStr = getweekday(day.weekday);
    fetchOccasionDetails();

    return Padding(
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
                  return const SizedBox();
                } else if (checkOccasion(day, occasionList) != "") {
                  return Center(
                      child: Text(
                          "Happy ${checkOccasion(day, occasionList)}!",
                          style: TextStyle(color: Colors.greenAccent)));
                } else {
                  List<String> respectiveRoomNo = [];
                  List<TimetableModel> timeTableDay =
                      getTimetablebyDay(data, dayStr, respectiveRoomNo, ref);
                  Future<Map<String, dynamic>?>? savedAttendance = getLoggedAttendance(day);
                  if (timeTableDay.isEmpty) {
                    return Column(
                      children: [
                        const Center(
                          child: Text("No lectures Today ! "),
                        ), 
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(future: savedAttendance, builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                print("Loading historical attendance data...");
                                return Column(
                                  children: makeTimetableWidgets(timeTableDay),
                                );
                              } else if (snapshot.hasError) {
                                print("Error fetching historical attendance data: ${snapshot.error}");
                                return Column(
                                  children: makeTimetableWidgets(timeTableDay),
                                );
                              } else if (snapshot.hasData && snapshot.data != null) {
                                final savedData = snapshot.data!;
                                print("Historical attendance data fetched successfully: $savedData");
                                for (final key in savedData.keys) {
                                  print(key);
                                  final alreadyExists = timeTableDay.any((item) => item.lectureName == key);
                                  if (!alreadyExists){
                                    timeTableDay.add(
                                        TimetableModel(lectureName: key, lectureStartTime: "lectureStartTime", lectureEndTime: "lectureEndTime", lectureFacultyName: "lectureFacultyName", lectureBatch: "lectureBatch")
                                    );
                                  }
                                }
                                print("Final timetable for the day: $timeTableDay");
                                return Column(
                                  children: makeTimetableWidgets(timeTableDay),
                                );
                              }
                              return Column(
                                children: makeTimetableWidgets(timeTableDay),
                              );
                            }),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ],
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
          
          SizedBox(
            height: 20,
          ),
          
          TextButton(onPressed: (){
            showDialog(context: context, builder:
            (BuildContext context) {
                return AddSubjectDialog(f: callSetState,);
              });
          }, child:
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  "Lecture not displayed?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "OVERALL ATTENDANCE",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                IconButton(onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AttendanceDetailsScreen())
                  );
                }, icon: Icon(Icons.arrow_forward_ios))
              ],
            ),
          ),
          OverallAttendance(width: width),
          SizedBox(
            height: 20,
          )
                    ],
                  ),
        ),
      );
  }
  List<Widget> makeTimetableWidgets(List<TimetableModel> timeTableDay) {
    print("--------------------------------------------------------");
    List<Widget> widgets = [];
    print("Number of lectures for the day: ${timeTableDay.length}");
    for (int i = 0; i < timeTableDay.length; i++) {
      widgets.add(
        AttendanceContainer(
          height: height,
          width: width,
          timetable: timeTableDay[i],
          isFirst: i == 0,
          isLast: i == timeTableDay.length - 1,
          index: i,
        ),
      );
    }
    return widgets;
  }
}
