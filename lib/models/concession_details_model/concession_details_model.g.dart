// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concession_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConcessionDetailsModel _$ConcessionDetailsModelFromJson(
        Map<String, dynamic> json) =>
    ConcessionDetailsModel(
      ageMonths: json['ageMonths'] as int,
      ageYears: json['ageYears'] as int,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      branch: json['branch'] as String,
      type: json['class'] as String,
      dob: json['dob'] as Timestamp,
      duration: json['duration'] as String,
      to: json['to'] as String,
      from: json['from'] as String,
      address: json['address'] as String,
      gradyear: json['gradyear'] as String,
      gender: json['gender'] as String,
      phoneNum: json['phoneNum'] as int,
      idCardURL: json['idCardURL'] as String,
      previousPassURL: json['previousPassURL'] as String,
      travelLane: json['travelLane'] as String,
      status: json['status'] as String,
      statusMessage: json['statusMessage'] as String,
      lastPassIssued: json['lastPassIssued'] as Timestamp?,
    );

Map<String, dynamic> _$ConcessionDetailsModelToJson(
        ConcessionDetailsModel instance) =>
    <String, dynamic>{
      'ageMonths': instance.ageMonths,
      'ageYears': instance.ageYears,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'branch': instance.branch,
      'class': instance.type,
      'dob': instance.dob,
      'duration': instance.duration,
      'to': instance.to,
      'from': instance.from,
      'address': instance.address,
      'gradyear': instance.gradyear,
      'gender': instance.gender,
      'phoneNum': instance.phoneNum,
      'idCardURL': instance.idCardURL,
      'previousPassURL': instance.previousPassURL,
      'travelLane': instance.travelLane,
      'lastPassIssued': instance.lastPassIssued,
      'status': instance.status,
      'statusMessage': instance.statusMessage,
    };
