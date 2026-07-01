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
import 'package:tsec_app/services/timetable_service.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/firebase_attendance_button_pressed_2025.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/attendance_totals_provider.dart';

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

  @override
  void initState() {
    super.initState();
    getTimeTablePreAbsCan(DateFormat('yyyy-MM-dd').format(DateTime.now()), ref);
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
          
          // ─── Apply Changes Button ───
          _buildApplyChangesButton(),

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

  /// Builds the "Apply Changes" button, only visible when there are pending changes.
  Widget _buildApplyChangesButton() {
    final pendingChanges = ref.watch(pendingAttendanceProvider);
    final isSubmitting = ref.watch(isSubmittingAttendanceProvider);

    if (pendingChanges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: isSubmitting
              ? null
              : () async {
                  ref.read(isSubmittingAttendanceProvider.notifier).state = true;

                  try {
                    final date = ref.read(attendanceDateprovider);
                    final changes =
                        Map<String, String>.from(ref.read(pendingAttendanceProvider));

                    await FirebaseAttendance2025()
                        .applyAllChanges(date, changes);

                    // Update local committed state with the new changes
                    for (final entry in changes.entries) {
                      ref
                          .read(dateTimetablePreAbsCanProvider.notifier)
                          .addEntry(entry.key, entry.value);
                    }

                    // Refresh per-lecture totals for each changed subject
                    for (final subject in changes.keys) {
                      ref
                          .read(attendanceTotalsPerLectureProvider(subject)
                              .notifier)
                          .refresh();
                    }
                    // Refresh overall totals
                    ref.read(attendanceTotalsProvider.notifier).refresh();

                    // Clear pending changes
                    ref.read(pendingAttendanceProvider.notifier).clearAll();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Attendance saved successfully!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to save: $e'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  } finally {
                    ref.read(isSubmittingAttendanceProvider.notifier).state =
                        false;
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: isSubmitting
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Apply Changes (${pendingChanges.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
