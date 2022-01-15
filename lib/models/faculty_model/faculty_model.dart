import 'package:json_annotation/json_annotation.dart';

part 'faculty_model.g.dart';

@JsonSerializable()
class FacultyModel {
  FacultyModel(
      this.area_of_specialization,
      this.designation,
      this.email,
      this.experience,
      this.image,
      this.name,
      this.phd_guide,
      this.qualification);

  final String area_of_specialization;
  final String designation;
  final String email;
  final String experience;
  final String image;
  final String name;
  final String phd_guide;
  final String qualification;

  factory FacultyModel.fromJson(Map<String, dynamic> json) =>
      _$FacultyModelFromJson(json);

  Map<String, dynamic> toJson() => _$FacultyModelToJson(this);
}
