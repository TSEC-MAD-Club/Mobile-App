import 'package:json_annotation/json_annotation.dart';

part 'about_department_model.g.dart';

@JsonSerializable()
class AboutDepartmentModel {
  AboutDepartmentModel(
    this.department,
    this.aboutDepartment,
    this.vision,
    this.mission,
  );

  final String department;
  final String aboutDepartment;
  final String vision;
  final String mission;

  factory AboutDepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$AboutDepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AboutDepartmentModelToJson(this);
}
