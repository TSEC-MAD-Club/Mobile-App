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
  final int index;

  const DummyContainerBottom({
    super.key,
    required this.width,
    required this.height,
    required this.lectureName,
    required this.index,
  });

  @override
  ConsumerState<DummyContainerBottom> createState() =>
      _DummyContainerBottomState();
}

class _DummyContainerBottomState extends ConsumerState<DummyContainerBottom> {
  // int selected = -1;
  Map selected = {};
  @override
  Widget build(BuildContext context) {
    ref.watch(attendanceDateprovider);
    selected = ref.watch(dateTimetablePreAbsCanProvider);

    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                ref
                    .read(dateTimetablePreAbsCanProvider.notifier)
                    .addEntry(widget.lectureName, 'Can');
                FirebaseAttendance2025().pressedCancelled(
                    ref.read(attendanceDateprovider), widget.lectureName);
              },
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                    color: selected[widget.lectureName] == 'Can'
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
                // setState(() {
                //   selected = 1;
                // });
                ref
                    .read(dateTimetablePreAbsCanProvider.notifier)
                    .addEntry(widget.lectureName, 'Pre');
                FirebaseAttendance2025().pressedPresent(
                    ref.read(attendanceDateprovider), widget.lectureName);
              },
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                  color: selected[widget.lectureName] == 'Pre'
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
                // setState(() {
                //   selected = 2;
                // });
                ref
                    .read(dateTimetablePreAbsCanProvider.notifier)
                    .addEntry(widget.lectureName, 'Abs');
                FirebaseAttendance2025().pressedAbsent(
                    ref.read(attendanceDateprovider), widget.lectureName);
              },
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                    color: selected[widget.lectureName] == 'Abs'
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
