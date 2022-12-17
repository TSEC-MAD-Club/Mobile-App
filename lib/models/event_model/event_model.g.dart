// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      json['Event Name'] as String,
      json['Event Time'] as String,
      json['Event date'] as String,
      json['Event description'] as String,
      json['Event registration url'] as String,
      json['Image url '] as String,
      json['Event Location'] as String,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'Event Name': instance.eventName,
      'Event Time': instance.eventTime,
      'Event date': instance.eventDate,
      'Event description': instance.eventDescription,
      'Event registration url': instance.eventRegistrationUrl,
      'Image url ': instance.imageUrl,
      'Event Location': instance.eventLocation,
    };
