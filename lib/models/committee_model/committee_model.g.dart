// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommitteeModel _$CommitteeModelFromJson(Map<String, dynamic> json) {
  return CommitteeModel(
    json['name'] as String,
    json['image'] as String,
    json['description'] as String,
  );
}

Map<String, dynamic> _$CommitteeModelToJson(CommitteeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
    };
