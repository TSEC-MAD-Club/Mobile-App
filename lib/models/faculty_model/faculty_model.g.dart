// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faculty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacultyModel _$FacultyModelFromJson(Map<String, dynamic> json) => FacultyModel(
      json['area_of_specialization'] as String,
      json['designation'] as String,
      json['email'] as String,
      json['experience'] as String,
      json['image'] as String,
      json['name'] as String,
      json['phd_guide'] as String,
      json['qualification'] as String,
    );

Map<String, dynamic> _$FacultyModelToJson(FacultyModel instance) =>
    <String, dynamic>{
      'area_of_specialization': instance.area_of_specialization,
      'designation': instance.designation,
      'email': instance.email,
      'experience': instance.experience,
      'image': instance.image,
      'name': instance.name,
      'phd_guide': instance.phd_guide,
      'qualification': instance.qualification,
    };
