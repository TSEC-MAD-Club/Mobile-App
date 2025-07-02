import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/attendance_totals_provider.dart';

class AttendanceDetailsScreen extends ConsumerStatefulWidget {
  const AttendanceDetailsScreen({super.key});

  @override
  ConsumerState<AttendanceDetailsScreen> createState() => _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends ConsumerState<AttendanceDetailsScreen> {

  late final AttendanceTotals totals;

  @override
  void initState() {
    totals = ref.read(fetchedAttendanceTotalsProvider);
    super.initState();
  }

  Map<String, double> getAttendedMap() {
    return totals.attended.map((key, value) => MapEntry(key, value.toDouble()));
  }

  Map<String, double> getTotalMap() {
    return totals.total.map((key, value) => MapEntry(key, value.toDouble()));
  }

  @override
  Widget build(BuildContext context) {
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
          child: getAttendedMap().isEmpty && getTotalMap().isEmpty
              ? Center(
                  child: Text(
                    "No attendance data available",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              :
          SingleChildScrollView(
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
                          const SizedBox(height: 16,),
                          PieChart(
                            dataMap: getAttendedMap(),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValues: false
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
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
                          const SizedBox(height: 16,),
                          PieChart(
                            dataMap: getTotalMap(),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValues: false
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
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
                          const SizedBox(height: 8,),
                          ListView.builder(itemBuilder: (context, index) {
                            String subject = totals.attended.keys.elementAt(index);
                            int attended = totals.attended[subject] ?? 0;
                            int total = totals.total[subject] ?? 0;
              
                            return Column(
                              children: [
                                attendanceItem(subject, attended, total),
                                if (index < totals.attended.length - 1)
                                  Divider(color: Colors.grey[700]),

                              ],
                            );
                          },
                            itemCount: totals.attended.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )

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
