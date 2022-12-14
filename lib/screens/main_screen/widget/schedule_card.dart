import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
   const ScheduleCard(this.color, this.opacityColor, {Key? key, 
  required this.lectureStartTime, required this.lectureEndTime, 
  required this.lectureName, required this.facultyName,
   required this.facultyImageurl})
      : super(key: key);
  final Color? color;
  final Color? opacityColor;
  final String lectureStartTime;
  final String lectureEndTime;
  final String lectureName;
  final String facultyName;
  final String facultyImageurl;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(
        bottom: 30.0,
      ),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        child: Container(
          height: _size.height * 0.16,
          decoration: BoxDecoration(
            color: _theme.primaryColor,
            borderRadius: BorderRadius.circular(
              15.0,
            ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        lectureEndTime,
                        style: TextStyle(
                          color: _theme.textTheme.headline1!.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
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
                    // Text(
                    //   'Lorem ipsum is placeholder text commonly used ,...',
                    //   style: TextStyle(
                    //     color: _theme.textTheme.headline1!.color,
                    //     fontSize: 13.5,
                    //     letterSpacing: 1.0,
                    //     fontWeight: FontWeight.w300,
                    //   ),
                    //),
                    const SizedBox(
                      height: 6.0,
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
                    )
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
