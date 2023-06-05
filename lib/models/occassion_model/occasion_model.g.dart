part of 'occasion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OccasionModel _$OccasionModelFromJson(Map<String, dynamic> json) =>
    OccasionModel(
      json['Occasion Name'] as String,
      json['Occasion Date'] as String,
    );

Map<String, dynamic> _$OccasionModelToJson(OccasionModel instance) =>
    <String, dynamic>{
      'Occasion Name': instance.occasionName,
      'Occasion Date': instance.occasionDate,
    };
