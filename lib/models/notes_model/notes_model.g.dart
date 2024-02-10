// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotesModel _$NotesModelFromJson(Map<String, dynamic> json) => NotesModel(
      title: json['title'] as String,
      description: json['description'] as String,
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      targetClasses: (json['target_classes'] as List<dynamic>)
          .map((e) => e as ClassModel)
          .toList(),
      time: TimestampConverter().fromJson(json['time'] as Timestamp),
      subject: json['subject'] as String,
      professorName: json['professor_name'] as String,
    );

Map<String, dynamic> _$NotesModelToJson(NotesModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'attachments': instance.attachments,
      'target_classes': instance.targetClasses.map((e) => e.toJson()).toList(),
      'time': const TimestampConverter().toJson(instance.time),
      'subject': instance.subject,
      'professor_name': instance.professorName,
    };
