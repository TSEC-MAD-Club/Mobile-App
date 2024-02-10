
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) =>
    ClassModel(
      branch: json['branch'] as String,
      year: json['year'] as String,
      // attachments: (json['attachments'] as List<dynamic>?)
      //     ?.map((e) => e as String)
      //     .toList(),
      division: json['division'] as String,
    );

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'branch': instance.branch,
      'year': instance.year,
      'division': instance.division,
    };
