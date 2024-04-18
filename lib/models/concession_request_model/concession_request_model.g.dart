// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concession_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConcessionRequestModel _$ConcessionRequestModelFromJson(
        Map<String, dynamic> json) =>
    ConcessionRequestModel(
      passNum: json['passNum'] as int?,
      status: json['status'] as String,
      statusMessage: json['statusMessage'] as String,
      // time: json['time'] as Timestamp,
      time: const TimestampConverter()
          .fromJson(json['time'] as Timestamp),
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$ConcessionRequestModelToJson(
        ConcessionRequestModel instance) =>
    <String, dynamic>{
      'passNum': instance.passNum,
      'status': instance.status,
      'statusMessage': instance.statusMessage,
      'time': instance.time,
      'uid': instance.uid,
      'notificationTime': const TimestampConverter().toJson(instance.time),
    };
