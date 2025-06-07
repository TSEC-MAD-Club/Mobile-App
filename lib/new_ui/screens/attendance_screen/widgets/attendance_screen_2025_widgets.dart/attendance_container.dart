/*
THE CONTAINER CARD DESIGN FOR SUBJECT ATTENDANCE

*/

import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/dummy_container_bottom.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/dummy_container_top.dart';

class AttendanceContainer extends StatefulWidget {
  final double height;
  final double width;

  const AttendanceContainer({super.key, required this.height, required this.width});

  @override
  State<AttendanceContainer> createState() => _AttendanceContainerState();
}

class _AttendanceContainerState extends State<AttendanceContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SizedBox(
        width: widget.width,
        height: widget.height * 0.15,
        child: Card(
          color: Color.fromRGBO(38, 38, 38, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Dummycontainertop(
                height: widget.height,
                width: widget.width,
              ),
              DummyContainerBottom(width: widget.width, height: widget.height)
            ],
          ),
        ),
      ),
    );
  }
}
