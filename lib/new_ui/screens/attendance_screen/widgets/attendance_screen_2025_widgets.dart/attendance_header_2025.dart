/*
HEADER FOR THE NEW ATTENDANCE SCREEN,
HEADER CONTAINS THE MONTH NAME, AT THE VERY LEFT,
FUNCTIONALITY BUTTONS ON THE VERY RIGHT.

FORMAT: ROW WITH 3 ELEMENTS-> 
TEXT(LEFT), EXPANDED, ROW(RIGHT,FOR FUNCTIONALITY BUTTONS)

*/

import 'package:flutter/material.dart';

class AttendanceHeader2025 extends StatefulWidget {
  final double height;
  final double width;

  const AttendanceHeader2025(
      {super.key, required this.height, required this.width});

  @override
  State<AttendanceHeader2025> createState() => _AttendanceHeader2025State();
}

class _AttendanceHeader2025State extends State<AttendanceHeader2025> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.width * 0.2,
          height: widget.height * 0.05,
          child: Center(
              child: Text(
            "June",
            style: TextStyle(color: Colors.white, fontSize: 22),
          )),
        ),
        Expanded(
            child: SizedBox(
          height: widget.height * 0.05,
        )),
        SizedBox(
          height: widget.height * 0.05,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
            ],
          ),
        )
      ],
    );
  }
}
