/*
THE CONTAINER CARD DESIGN FOR SUBJECT ATTENDANCE

*/

import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/dummy_container_bottom.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/widgets/attendance_screen_2025_widgets.dart/dummy_container_top.dart';

class Dummycontainer extends StatefulWidget {
  final double height;
  final double width;

  const Dummycontainer({super.key, required this.height, required this.width});

  @override
  State<Dummycontainer> createState() => _DummycontainerState();
}

class _DummycontainerState extends State<Dummycontainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: widget.width * 0.8,
          height: widget.height * 0.15,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20)),
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
