// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutDepartmentModel _$AboutDepartmentModelFromJson(
        Map<String, dynamic> json) =>
    AboutDepartmentModel(
      json['department'] as String,
      json['aboutDepartment'] as String,
      json['vision'] as String,
      json['mission'] as String,
    );

Map<String, dynamic> _$AboutDepartmentModelToJson(
        AboutDepartmentModel instance) =>
    <String, dynamic>{
      'department': instance.department,
      'aboutDepartment': instance.aboutDepartment,
      'vision': instance.vision,
      'mission': instance.mission,
    };
