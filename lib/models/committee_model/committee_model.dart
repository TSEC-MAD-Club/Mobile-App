import 'package:json_annotation/json_annotation.dart';
part 'committee_model.g.dart';

@JsonSerializable()
class CommitteeModel {
  CommitteeModel(this.name, this.image, this.description);

  final String name;
  final String image;
  final String description;

  factory CommitteeModel.fromJson(Map<String, dynamic> json) =>
      _$CommitteeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommitteeModelToJson(this);
}
