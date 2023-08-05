// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'occasion_model.g.dart';

@JsonSerializable()
class OccasionModel {
  OccasionModel(
    this.occasionName,
    this.occasionDate,
  );

  @JsonKey(name: 'Occasion Name')
  final String occasionName;
  @JsonKey(name: 'Occasion Date')
  final String occasionDate;

  factory OccasionModel.fromJson(Map<String, dynamic> json) =>
      _$OccasionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionModelToJson(this);
}
