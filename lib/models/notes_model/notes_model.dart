// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsec_app/models/class_model/class_model.dart';
part 'notes_model.g.dart';

@JsonSerializable()
class NotesModel {
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "attachments")
  final List<String> attachments;
  @JsonKey(name: "time")
  final DateTime time;
  @JsonKey(name: "target_classes")
  final List<ClassModel> targetClasses;
  @JsonKey(name: "subject")
  final String subject;
  @JsonKey(name: "professor_name")
  final String professorName;

  NotesModel({
    required this.title,
    required this.description,
    required this.attachments,
    required this.time,
    required this.targetClasses,
    required this.subject,
    required this.professorName,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) =>
      _$NotesModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotesModelToJson(this);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
