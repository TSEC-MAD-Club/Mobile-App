import 'package:json_annotation/json_annotation.dart';
part 'timetable_model.g.dart';

@JsonSerializable()
class TimetableModel {
  final String lectureName;
  final String lectureStartTime;
  final String lectureEndTime;

  final String lectureFacultyName;
  final String lectureBatch;

  TimetableModel({
    required this.lectureName,
    required this.lectureStartTime,
    required this.lectureEndTime,
 
    required this.lectureFacultyName,
    required this.lectureBatch,
  });

  factory TimetableModel.fromJson(Map<String, dynamic> json) =>
      _$TimetableModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimetableModelToJson(this);
}
