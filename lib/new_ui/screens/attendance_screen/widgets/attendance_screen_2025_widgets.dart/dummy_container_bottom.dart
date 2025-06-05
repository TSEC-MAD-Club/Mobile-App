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
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              child: Container(
            width: widget.width * 0.2,
            height: 30,
            decoration: BoxDecoration(
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
              child: Container(
            width: widget.width * 0.2,
            height: 30,
            decoration: BoxDecoration(
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
              child: Container(
            width: widget.width * 0.2,
            height: 30,
            decoration: BoxDecoration(
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
