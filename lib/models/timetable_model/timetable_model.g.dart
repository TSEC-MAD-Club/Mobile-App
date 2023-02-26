// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableModel _$TimetableModelFromJson(Map<String, dynamic> json) =>
    TimetableModel(
      lectureName: json['lectureName'] as String,
      lectureStartTime: json['lectureStartTime'] as String,
      lectureEndTime: json['lectureEndTime'] as String,
      lectureFacultyName: json['lectureFacultyName'] as String,
      lectureBatch: json['lectureBatch'] as String,
    );

Map<String, dynamic> _$TimetableModelToJson(TimetableModel instance) =>
    <String, dynamic>{
      'lectureName': instance.lectureName,
      'lectureStartTime': instance.lectureStartTime,
      'lectureEndTime': instance.lectureEndTime,
      'lectureFacultyName': instance.lectureFacultyName,
      'lectureBatch': instance.lectureBatch,
    };
