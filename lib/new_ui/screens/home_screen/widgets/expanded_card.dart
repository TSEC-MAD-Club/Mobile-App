// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/occassion_model/occasion_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/timetable_model/timetable_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/schedule_card.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/timetable_provider.dart';
import 'package:tsec_app/provider/occasion_provider.dart';
import 'package:tsec_app/screens/main_screen/widget/schedule_card.dart';

import 'package:tsec_app/utils/faculty_details.dart';
import 'package:tsec_app/utils/notification_type.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/time_container.dart';
import 'package:tsec_app/utils/timetable_util.dart';

final dayProvider = StateProvider.autoDispose<DateTime>((ref) {
  DateTime day = DateTime.now();
  return day;
});

class ExpandedCard extends ConsumerStatefulWidget {
  const ExpandedCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpandedCardState();
}

class _ExpandedCardState extends ConsumerState<ExpandedCard> {
  bool isExpanded = false;

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
          error: (Object error, StackTrace? stackTrace) {},
        );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(counterStreamProvider);
    DateTime day = ref.watch(dayProvider);
    String dayStr = getweekday(day.weekday);

    fetchOccasionDetails();
    var _theme = Theme.of(context);

    final dat = ref.watch(notificationTypeProvider);
    debugPrint("time table batch details: ${dat?.yearBranchDivTopic}");
    return data.when(
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
          return Center(
              child: Text(
            "Happy Weekend !",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 25),
          ));
        } else if (checkOccasion(day, occasionList) != "") {
          return Center(child: Text("Happy ${checkOccasion(day, occasionList)}!"));
        } else {
          List<TimetableModel> timeTableDay = getTimetablebyDay(data, dayStr);
          if (timeTableDay.isEmpty) {
            return const Center(child: Text("No lectures Today ! "));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: isExpanded ? 490.0 : 130.0,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: _theme.colorScheme.tertiary,

                        borderRadius: BorderRadius.circular(15.0), // Adjust the radius to control the roundness
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Adjust the shadow color and opacity
                            spreadRadius: 2, // Adjust the spread radius
                            blurRadius: 5, // Adjust the blur radius
                            offset: const Offset(0, 3), // Adjust the shadow offset
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Today’s Schedule",
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 20, color: _theme.colorScheme.onPrimary),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (isExpanded)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TimeContainer(),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: timeTableDay.length,
                                          itemBuilder: (context, index) {
                                            final lectureFacultyname = timeTableDay[index].lectureFacultyName;
                                            return scheduleCard(
                                              lectureEndTime: timeTableDay[index].lectureEndTime,
                                              lectureName: timeTableDay[index].lectureName,
                                              lectureStartTime: timeTableDay[index].lectureStartTime,
                                              facultyImageurl: getFacultyImagebyName(lectureFacultyname),
                                              facultyName: !checkTimetable(lectureFacultyname) ? "" : lectureFacultyname,
                                              lectureBatch: timeTableDay[index].lectureBatch,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TimeContainer(),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            final lectureFacultyname = timeTableDay[index].lectureFacultyName;
                                            return scheduleCard(
                                              lectureEndTime: timeTableDay[index].lectureEndTime,
                                              lectureName: timeTableDay[index].lectureName,
                                              lectureStartTime: timeTableDay[index].lectureStartTime,
                                              facultyImageurl: getFacultyImagebyName(lectureFacultyname),
                                              facultyName: !checkTimetable(lectureFacultyname) ? "" : lectureFacultyname,
                                              lectureBatch: timeTableDay[index].lectureBatch,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
      error: (error, stackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  List<TimetableModel> getTimetablebyDay(Map<String, dynamic> data, String day) {
    List<TimetableModel> timeTableDay = [];
    final daylist = data[day];
    for (final item in daylist) {
      UserModel? userModel = ref.watch(userModelProvider);
      if (item['lectureBatch'] == userModel!.studentModel?.batch.toString() || item['lectureBatch'] == 'All') {
        timeTableDay.add(TimetableModel.fromJson(item));
      }
    }
    return timeTableDay;
  }

  bool checkLabs(String lectureName) {
    return lectureName.toLowerCase().endsWith('labs') || lectureName.toLowerCase().endsWith('lab');
  }

  bool checkTimetable(String lectureFacultyName) {
    return lectureFacultyName.isEmpty || lectureFacultyName == " ";
  }
}
