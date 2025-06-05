/*
ATTENDANCE SCREEN REVAMP UNDER THE 25 - 26 TENURE;
THE OLD ATTENDANCE SCREEN IS THE FILE NAMED 'attendance_screen.dart'
*/

import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/attendance_header_2025.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/date_header_2025.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/dummyContainer.dart';

class AttendanceScreen2025 extends StatefulWidget {
  const AttendanceScreen2025({super.key});

  @override
  State<AttendanceScreen2025> createState() => _AttendanceScreen2025State();
}

class _AttendanceScreen2025State extends State<AttendanceScreen2025> {
  double height = 0;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Column(
        children: [
          AttendanceHeader2025(
            height: height,
            width: width,
          ),
          SizedBox(width: width, child: DateHeader2025(width: width)),
          Dummycontainer(height: height, width: width)
        ],
      ),
    );
  }
}
