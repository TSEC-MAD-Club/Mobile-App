// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'student_model.g.dart';

@JsonSerializable()
class StudentModel {
  @JsonKey(name: "Batch")
  final String batch;
  @JsonKey(name: "Branch")
  final String branch;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "gradyear")
  final int gradyear;
  @JsonKey(name: "phoneNo")
  final String phoneNum;
  StudentModel({
    required this.batch,
    required this.branch,
    required this.name,
    required this.email,
    required this.gradyear,
    required this.phoneNum,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);

  @override
  String toString() {
    return 'StudentModel(batch: $batch, branch: $branch, name: $name, email: $email, gradyear: $gradyear, phoneNum: $phoneNum)';
  }
}
