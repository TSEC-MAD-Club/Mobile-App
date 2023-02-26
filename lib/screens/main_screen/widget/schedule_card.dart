import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(this.color, this.opacityColor,
      {Key? key,
      required this.lectureStartTime,
      required this.lectureEndTime,
      required this.lectureName,
      required this.facultyName,
      required this.facultyImageurl,
      required this.lectureBatch})
      : super(key: key);
  final Color? color;
  final Color? opacityColor;
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
    return Card(
      margin: const EdgeInsets.only(
        bottom: 30.0,
        left: 10.0,
        right: 10.0,
      ),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: _theme.primaryColor,
            borderRadius: BorderRadius.circular(
              15.0,
            ),
            boxShadow: [
              _boxshadow,
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 12.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(
                      15.0,
                    ),
                  ),
                ),
              ),
              Container(
                width: 85.0,
                decoration: BoxDecoration(
                  color: opacityColor,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        lectureStartTime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _theme.textTheme.headline1!.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                          wordSpacing: 3.0,
                        ),
                      ),
                      Text(
                        'to',
                        style: TextStyle(
                          color: _theme.textTheme.headline1!.color,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        lectureEndTime,
                        style: TextStyle(
                          color: _theme.textTheme.headline1!.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              ),
              Container(
                width: _size.width * 0.56,
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 8.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lectureName,
                      style: TextStyle(
                        color: _theme.textTheme.headline1!.color,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Batch : $lectureBatch',
                        style: TextStyle(
                          color: _theme.textTheme.headline2!.color,
                          fontWeight: FontWeight.w300,
                          fontSize: 17.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14.0,
                          backgroundImage: NetworkImage(facultyImageurl),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          facultyName,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
