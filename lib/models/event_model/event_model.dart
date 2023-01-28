// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  EventModel(
      this.eventName,
      this.eventTime,
      this.eventDate,
      this.eventDescription,
      this.eventRegistrationUrl,
      this.imageUrl,
      this.eventLocation,
      this.committeeName
      );

  @JsonKey(name: 'Event Name')
  final String eventName;
  @JsonKey(name: 'Event Time')
  final String eventTime;
  @JsonKey(name: 'Event date')
  final String eventDate;
  @JsonKey(name: 'Event description')
  final String eventDescription;
  @JsonKey(name: 'Event registration url')
  final String eventRegistrationUrl;
  @JsonKey(name: 'Image url ')
  final String imageUrl;
  @JsonKey(name: 'Event Location')
  final String eventLocation;
  @JsonKey(name: 'Committee Name')
  final String committeeName; 

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
