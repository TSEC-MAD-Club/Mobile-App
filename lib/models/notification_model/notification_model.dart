import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String title, message;
  final List<String>? attachments;
  final String topic;

  @TimestampConverter()
  final DateTime notificationTime;

  NotificationModel(
      {required this.title,
      required this.message,
      required this.attachments,
      required this.notificationTime,
      required this.topic});

  factory NotificationModel.fromMessage(RemoteMessage message) =>
      NotificationModel(
        message: message.notification!.body!,
        title: message.notification!.title!,
        notificationTime: DateTime.parse(
          message.data["notificationTime"] ?? DateTime.now().toString(),
        ),
        attachments: message.data["attachments"] != null
            ? (jsonDecode(message.data["attachments"]) as List)
                .map((e) => e as String)
                .toList()
            : null,
        topic: '',
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.message == message &&
        listEquals(other.attachments, attachments) &&
        other.notificationTime == notificationTime;
  }

  @override
  int get hashCode =>
      message.hashCode ^ attachments.hashCode ^ notificationTime.hashCode;
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
