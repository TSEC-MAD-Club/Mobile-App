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
      {super.key,
      required this.width,
      required this.height,
      required this.subjectName});

  @override
  State<Dummycontainertop> createState() => _DummycontainertopState();
}

class _DummycontainertopState extends State<Dummycontainertop> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xFF4A90E2),
          ),
          child: const Center(
            child: Text(
              "EG",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subjectName.isEmpty ? "EG ACAD" : widget.subjectName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Total Lec:3/3",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
