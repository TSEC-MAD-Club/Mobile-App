// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    title: json['title'] as String,
    message: json['message'] as String,
    attachments: (json['attachments'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    notificationTime: const TimestampConverter()
        .fromJson(json['notificationTime'] as Timestamp),
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
      'attachments': instance.attachments,
      'notificationTime':
          const TimestampConverter().toJson(instance.notificationTime),
    };
