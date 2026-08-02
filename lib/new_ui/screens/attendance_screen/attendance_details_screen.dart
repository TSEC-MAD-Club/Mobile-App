import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/attendance_totals_provider.dart';
import 'package:tsec_app/models/subject_model/subject_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/subjects_provider.dart';
import 'package:tsec_app/utils/profile_details.dart';
class AttendanceDetailsScreen extends ConsumerWidget {
  const AttendanceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceTotalsProvider);

    SubjectModel subjects = ref.watch(subjectsProvider);
    UserModel? user = ref.watch(userModelProvider);
    List<String> validSubjects = [];
    if (user != null && user.studentModel != null) {
      SemesterData semData = subjects.dataMap[
          "${calcGradYear(user.studentModel?.gradyear)}_${user.studentModel?.branch}"] ??
          SemesterData(even_sem: [], odd_sem: []);
      validSubjects = evenOrOddSem() == "even_sem" ? semData.even_sem : semData.odd_sem;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: commonbgLightblack,
        title: Text(
          "Attendance Details",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: attendanceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              "Error loading attendance",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
          data: (totals) {
            // Also update the cached provider so other consumers stay in sync
            Future(() {
              ref.read(fetchedAttendanceTotalsProvider.notifier).state = totals;
            });

            final filteredAttended = totals.attended.entries.where((e) => validSubjects.isEmpty || validSubjects.contains(e.key));
            final filteredTotal = totals.total.entries.where((e) => validSubjects.isEmpty || validSubjects.contains(e.key));

            final attendedMap = Map.fromEntries(filteredAttended
                .map((e) => MapEntry(e.key, e.value.toDouble())));
            final totalMap = Map.fromEntries(filteredTotal
                .map((e) => MapEntry(e.key, e.value.toDouble())));

            if (attendedMap.isEmpty && totalMap.isEmpty) {
              return Center(
                child: Text(
                  "No attendance data available",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      color: const Color(0xFF2D2D2D),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Attended: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            PieChart(
                              dataMap: attendedMap,
                              chartValuesOptions: ChartValuesOptions(
                                showChartValues: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: const Color(0xFF2D2D2D),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Total Lectures: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            PieChart(
                              dataMap: totalMap,
                              chartValuesOptions: ChartValuesOptions(
                                showChartValues: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: const Color(0xFF2D2D2D),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Attendance insights: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Builder(builder: (context) {
                              List<String> filteredSubjectKeys = validSubjects.isEmpty 
                                  ? totals.attended.keys.toList() 
                                  : totals.attended.keys.where((k) => validSubjects.contains(k)).toList();

                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  String subject = filteredSubjectKeys[index];
                                  int attended = totals.attended[subject] ?? 0;
                                  int total = totals.total[subject] ?? 0;

                                  return Column(
                                    children: [
                                      attendanceItem(subject, attended, total),
                                      if (index < filteredSubjectKeys.length - 1)
                                        Divider(color: Colors.grey[700]),
                                    ],
                                  );
                                },
                                itemCount: filteredSubjectKeys.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              );
                            }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

int lecturesNeededToReach75(int attended, int total) {
  if (attended >= 0.75 * total) {
    return 0;
  }

  int lecturesNeeded = 0;
  int currentAttended = attended;
  int currentTotal = total;

  while ((currentAttended / currentTotal) < 0.75) {
    lecturesNeeded++;
    currentAttended++;
    currentTotal++;
  }

  return lecturesNeeded;
}

Widget attendanceItem (String name, int attended, int total) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              "$attended/$total",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: total > 0 ? attended / total : 0.0,
          backgroundColor: Colors.grey[800],
          color: Colors.blue,
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(
              attended / total <= 0.75 ?
              "Lectures needed to reach 75%: ${lecturesNeededToReach75(attended, total)}"
              : "You are above 75%, keep it up!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
