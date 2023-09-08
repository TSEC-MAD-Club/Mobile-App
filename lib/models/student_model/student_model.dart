// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'student_model.g.dart';

@JsonSerializable()
class StudentModel {
  @JsonKey(name: "updateCount")
  int? updateCount;
  @JsonKey(name: "Batch")
  final String? batch;
  @JsonKey(name: "Branch")
  final String branch;
  @JsonKey(name: "Name")
  final String name;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "homeStation")
  final String? homeStation;
  @JsonKey(name: "dateOfBirth")
  final String? dateOfBirth;
  @JsonKey(name: "gradyear")
  final String gradyear;
  @JsonKey(name: "phoneNo")
  final String? phoneNum;
  final String? div;
  StudentModel({
    required this.batch,
    required this.branch,
    required this.name,
    required this.email,
    required this.address,
    required this.homeStation,
    required this.dateOfBirth,
    required this.gradyear,
    required this.phoneNum,
    required this.div,
    required this.updateCount,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
}
