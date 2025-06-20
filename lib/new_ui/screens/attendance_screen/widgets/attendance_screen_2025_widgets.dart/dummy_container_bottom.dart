/*
BOTTOM DESIGN PART FOR CONTAINER BEING THE ATTENDANCE SCREEN

CONTAINS THREE BUTTONS -> CAN (CANCEL), PRE(PRESENT), ABS(ABSENT)

*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/firebase_attendance_button_pressed_2025.dart';
import 'package:tsec_app/provider/attendance_date_provider.dart';

class DummyContainerBottom extends ConsumerStatefulWidget {
  final double width;
  final double height;
  final String lectureName;

  const DummyContainerBottom({
    super.key,
    required this.width,
    required this.height,
    required this.lectureName,
  });

  @override
  ConsumerState<DummyContainerBottom> createState() =>
      _DummyContainerBottomState();
}

class _DummyContainerBottomState extends ConsumerState<DummyContainerBottom> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    ref.watch(attendanceDateprovider);
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                setState(() {
                  selected = 0;
                });
                FirebaseAttendance2025().pressedCancelled(
                    ref.read(attendanceDateprovider), widget.lectureName);
              },
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                    color: selected == 0
                        ? const Color.fromARGB(44, 180, 180, 180)
                        : Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.error_outline_outlined,
                      color: Colors.white,
                    ),
                    Text("Can")
                  ],
                ),
              )),
          GestureDetector(
              onTap: () {
                setState(() {
                  selected = 1;
                });
                FirebaseAttendance2025().pressedPresent(
                    ref.read(attendanceDateprovider), widget.lectureName);
              },
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                  color: selected == 1
                      ? const Color.fromARGB(44, 180, 180, 180)
                      : Colors.transparent,
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text("Pre")
                  ],
                ),
              )),
          GestureDetector(
              onTap: () {
                setState(() {
                  selected = 2;
                });
                FirebaseAttendance2025().pressedAbsent(
                    ref.read(attendanceDateprovider), widget.lectureName);
              },
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                    color: selected == 2
                        ? const Color.fromARGB(44, 180, 180, 180)
                        : Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    Text("Abs")
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
