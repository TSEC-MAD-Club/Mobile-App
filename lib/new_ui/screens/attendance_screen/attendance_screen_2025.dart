/*
ATTENDANCE SCREEN REVAMP UNDER THE 25 - 26 TENURE;
THE OLD ATTENDANCE SCREEN IS THE FILE NAMED 'attendance_screen.dart'
*/
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/date_header_2025.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/attendance_container.dart';

class AttendanceScreen2025 extends StatefulWidget {
  const AttendanceScreen2025({super.key});

  @override
  State<AttendanceScreen2025> createState() => _AttendanceScreen2025State();
}

class _AttendanceScreen2025State extends State<AttendanceScreen2025> {
  double height = 0;
  double width = 0;
  int activeStep = 2;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AttendanceHeader2025(
              //   height: height,
              //   width: width,
              // ),
              SizedBox(width: width, child: DateHeader2025(width: width)),
              TimelineTile(
                axis: TimelineAxis.vertical,
                alignment: TimelineAlign.start,
                isFirst: true,
                hasIndicator: true,
                indicatorStyle: IndicatorStyle(
                  color: Colors.green,
                  iconStyle: IconStyle(
                    iconData: Icons.check,
                    color: Colors.white,
                  ),
                ),
                endChild: AttendanceContainer(height: height, width: width),
                afterLineStyle: LineStyle(
                  color: Colors.green,
                  thickness: 2.0,
                ),
              ),
              TimelineTile(
                axis: TimelineAxis.vertical,
                alignment: TimelineAlign.start,
                hasIndicator: true,
                indicatorStyle: IndicatorStyle(
                  color: Colors.green,
                  iconStyle: IconStyle(
                    iconData: Icons.check,
                    color: Colors.white,
                  ),
                ),
                endChild: AttendanceContainer(height: height, width: width),
                afterLineStyle: LineStyle(
                  color: Colors.green,
                  thickness: 2.0,
                ),
                beforeLineStyle: LineStyle(
                  color: Colors.green,
                  thickness: 2.0,
                ),
              ),
              TimelineTile(
                axis: TimelineAxis.vertical,
                alignment: TimelineAlign.start,
                hasIndicator: true,
                isLast: true,
                indicatorStyle: IndicatorStyle(
                  color: Colors.green,
                  iconStyle: IconStyle(
                    iconData: Icons.check,
                    color: Colors.white,
                  ),
                ),
                endChild: AttendanceContainer(height: height, width: width),
                beforeLineStyle: LineStyle(
                  color: Colors.green,
                  thickness: 2.0,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
