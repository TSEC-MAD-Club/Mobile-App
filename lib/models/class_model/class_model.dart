// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
part 'class_model.g.dart';

@JsonSerializable()
class ClassModel {
  @JsonKey(name: "branch")
  final String branch;
  @JsonKey(name: "year")
  final String year;
  @JsonKey(name: "division")
  final String division;

  ClassModel({
    required this.branch,
    required this.division,
    required this.year,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
}
