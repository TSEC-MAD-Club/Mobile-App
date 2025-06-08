/*

THE CONTAINER IS DIVIDED IN 2 PARTS, THIS IS THE TOP PART,
WHICH HAS THE  LECTURE ICON,LECTURE NAME, PERCENT INDICATOR

*/

import 'package:flutter/material.dart';

class Dummycontainertop extends StatefulWidget {
  final double width;
  final double height;
  final String subjectName;

  const Dummycontainertop(
      {super.key, required this.width, required this.height, required this.subjectName});

  @override
  State<Dummycontainertop> createState() => _DummycontainertopState();
}

class _DummycontainertopState extends State<Dummycontainertop> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        SizedBox(
          width: widget.width * 0.15,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: widget.width * 0.1,
              width: widget.width * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), color: Colors.blue),
              child: Center(
                  child: Text(
                "L",
                style: TextStyle(fontSize: 14, color: Colors.white),
              )),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.subjectName,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Attend at least 2 more Lec(s)",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: widget.width * 0.15,
          child: Stack(
            alignment: Alignment.center, // This aligns children to center
            children: [
              CircularProgressIndicator(
                value: 0.5,
                color: Colors.blue,
              ),
              Text(
                "50%",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }
}
