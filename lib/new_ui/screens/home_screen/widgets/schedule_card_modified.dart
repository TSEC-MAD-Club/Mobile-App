import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/home_screen/home_screen_shimmer_loader.dart';

class ScheduleCardModified extends StatelessWidget {
  const ScheduleCardModified(
    this.color,
    this.opacityColor, {
    Key? key,
    required this.lectureStartTime,
    required this.lectureEndTime,
    required this.lectureName,
    required this.facultyName,
    required this.facultyImageurl,
    required this.lectureBatch,
    required this.lectureRoomNo,
  }) : super(key: key);
  final Color? color;
  final Color? opacityColor;
  final String lectureStartTime;
  final String lectureEndTime;
  final String lectureName;
  final String facultyName;
  final String facultyImageurl;
  final String lectureBatch;
  final String lectureRoomNo;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _theme = Theme.of(context);
    var _boxshadow = BoxShadow(
      color: Colors.black,
      spreadRadius: 0.2,
      blurRadius: 4,
      offset: const Offset(0, 3),
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
            color: commonbgLightblack,
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
                width: 90.0,
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
                          color: _theme.textTheme.headlineMedium!.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                          wordSpacing: 3.0,
                        ),
                      ),
                      Text(
                        'to',
                        style: TextStyle(
                          color: _theme.textTheme.headlineMedium!.color,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        lectureEndTime,
                        style: TextStyle(
                          color: _theme.textTheme.headlineMedium!.color,
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: _theme.textTheme.headlineMedium!.color,
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
                      child: Row(
                        children: [
                          Text(
                            'Batch: $lectureBatch',
                            style: TextStyle(
                              color: _theme.textTheme.headlineMedium!.color,
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          lectureRoomNo != ""
                              ? Text(
                                  'Room: $lectureRoomNo',
                                  style: TextStyle(
                                    color:
                                        _theme.textTheme.headlineMedium!.color,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    letterSpacing: 1.0,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: facultyImageurl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const ImageShimmer(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          facultyName,
                          style: const TextStyle(
                            color: Colors.white,
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
