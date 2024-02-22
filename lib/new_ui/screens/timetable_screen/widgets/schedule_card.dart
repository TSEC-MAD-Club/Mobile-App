// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      // this.color, this.opacityColor,
      {Key? key,
      required this.lectureStartTime,
      required this.lectureEndTime,
      required this.lectureName,
      required this.facultyName,
      required this.facultyImageurl,
      required this.lectureBatch})
      : super(key: key);
  // final Color? color;
  // final Color? opacityColor;
  final String lectureStartTime;
  final String lectureEndTime;
  final String lectureName;
  final String facultyName;
  final String facultyImageurl;
  final String lectureBatch;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _theme = Theme.of(context);
    var _boxshadow = BoxShadow(
      color: _theme.primaryColorDark,
      spreadRadius: 1,
      blurRadius: 2,
      offset: const Offset(0, 1),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 5),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 250.0,
              height: 74.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: _theme.colorScheme.onSecondary,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                  right: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "$lectureStartTime-$lectureEndTime",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                        child: Text(
                          lectureName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 10, 5),
                        child: Text(
                          facultyName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
