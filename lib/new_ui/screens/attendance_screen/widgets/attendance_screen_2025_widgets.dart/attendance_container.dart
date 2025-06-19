/*
THE CONTAINER CARD DESIGN FOR SUBJECT ATTENDANCE

*/

import 'package:flutter/material.dart';
import 'package:tsec_app/models/timetable_model/timetable_model.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/dummy_container_bottom.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/dummy_container_top.dart';

class AttendanceContainer extends StatefulWidget {
  final double height;
  final double width;
  final TimetableModel timetable;
  final bool? isFirst;
  final bool? isLast;

  const AttendanceContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.timetable,
      this.isFirst,
      this.isLast});

  @override
  State<AttendanceContainer> createState() => _AttendanceContainerState();
}

class _AttendanceContainerState extends State<AttendanceContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dummycontainertop(
                height: widget.height,
                width: widget.width,
                subjectName: widget.timetable.lectureName,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: const Text(
                      "Can miss up to 1 lec(s).",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              DummyContainerBottom(
                width: widget.width,
                height: widget.height,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
