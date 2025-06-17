/*
BOTTOM DESIGN PART FOR CONTAINER BEING THE ATTENDANCE SCREEN

CONTAINS THREE BUTTONS -> CAN (CANCEL), PRE(PRESENT), ABS(ABSENT)

*/

import 'package:flutter/material.dart';

class DummyContainerBottom extends StatefulWidget {
  final double width;
  final double height;

  const DummyContainerBottom(
      {super.key, required this.width, required this.height});

  @override
  State<DummyContainerBottom> createState() => _DummyContainerBottomState();
}

class _DummyContainerBottomState extends State<DummyContainerBottom> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    child: Container(
                  width: widget.width * 0.2,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(234, 25, 25, 26),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(
                        size: 18,
                        Icons.error_outline_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        "Can",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )),
                GestureDetector(
                    child: Container(
                  width: widget.width * 0.2,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(234, 25, 25, 26),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(
                        size: 18,
                        Icons.check,
                        color: Colors.white,
                      ),
                      Text(
                        "Pre",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )),
                GestureDetector(
                    child: Container(
                  width: widget.width * 0.2,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(234, 25, 25, 26),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(
                        size: 18,
                        Icons.cancel_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        "Abs",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
          //use this conditionally !
          // LastAttendedBadge(width: widget.width)
        ],
      ),
    );
  }
}

class LastAttendedBadge extends StatefulWidget {
  final double width;
  const LastAttendedBadge({super.key, required this.width});

  @override
  State<LastAttendedBadge> createState() => _LastAttendedBadgeState();
}

class _LastAttendedBadgeState extends State<LastAttendedBadge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.65,
      height: 30,
      decoration: BoxDecoration(
          color: const Color.fromARGB(234, 25, 25, 26),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Icon(
            size: 18,
            Icons.calendar_month,
            color: Colors.white,
          ),
          Text(
            "Last Attended : 16:15 on 22.07.2024",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
          )
        ],
      ),
    );
  }
}
