import 'package:json_annotation/json_annotation.dart';

part 'faculty_model.g.dart';

@JsonSerializable()
class FacultyModel {
  @JsonKey(name: 'area_of_specialization')
  final String areaOfSpecialization;
  final String designation;
  final String email;
  final String experience;
  String image;
  final String name;
  @JsonKey(name: 'phd_guide')
  final String phdGuide;
  final String qualification;

  FacultyModel(
    this.areaOfSpecialization,
    this.designation,
    this.email,
    this.experience,
    this.image,
    this.name,
    this.phdGuide,
    this.qualification,
  );

  factory FacultyModel.fromJson(Map<String, dynamic> json) =>
      _$FacultyModelFromJson(json);

  Map<String, dynamic> toJson() => _$FacultyModelToJson(this);
}
