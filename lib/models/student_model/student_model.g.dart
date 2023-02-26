// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
      batch: json['Batch'] as String,
      branch: json['Branch'] as String,
      name: json['Name'] as String,
      email: json['email'] as String,
      gradyear: json['gradyear'] as String,
      phoneNum: json['phoneNo'] as String,
      div: json['div'] as String,
    );

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'Batch': instance.batch,
      'Branch': instance.branch,
      'Name': instance.name,
      'email': instance.email,
      'gradyear': instance.gradyear,
      'phoneNo': instance.phoneNum,
      'div': instance.div,
    };
