// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
      batch: json['Batch'] as String?,
      branch: json['Branch'] as String,
      name: json['Name'] as String,
      email: json['email'] as String,
      address: json['address'] as String?,
      homeStation: json['homeStation'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gradyear: json['gradyear'] as String,
      phoneNum: json['phoneNo'] as String?,
      div: json['div'] as String?,
      updateCount: json['updateCount'] as int?,
    );

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'Batch': instance.batch,
      'Branch': instance.branch,
      'Name': instance.name,
      'email': instance.email,
      'address': instance.address,
      'homeStation': instance.homeStation,
      'dateOfBirth': instance.dateOfBirth,
      'gradyear': instance.gradyear,
      'phoneNo': instance.phoneNum,
      'div': instance.div,
      'updateCount': instance.updateCount,
    };
