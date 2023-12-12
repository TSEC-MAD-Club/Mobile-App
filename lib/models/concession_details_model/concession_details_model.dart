// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'concession_details_model.g.dart';

@JsonSerializable()
class ConcessionDetailsModel {
  @JsonKey(name: "address")
  final String address;
  @JsonKey(name: "ageMonths")
  final int ageMonths;
  @JsonKey(name: "ageYears")
  final int ageYears;
  @JsonKey(name: "firstName")
  final String firstName;
  @JsonKey(name: "middleName")
  final String middleName;
  @JsonKey(name: "lastName")
  final String lastName;
  @JsonKey(name: "branch")
  final String branch;
  @JsonKey(name: "class")
  final String type;
  @JsonKey(name: "dob")
  final Timestamp dob;
  @JsonKey(name: "duration")
  final String duration;
  @JsonKey(name: "to")
  final String to;
  @JsonKey(name: "from")
  final String from;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "gradyear")
  final String gradyear;
  @JsonKey(name: "phoneNum")
  final int phoneNum;
  @JsonKey(name: "idCardURL")
  String idCardURL;
  @JsonKey(name: "previousPassURL")
  String previousPassURL;
  @JsonKey(name: "travelLane")
  final String travelLane;
  @JsonKey(name: "lastPassIssued")
  final Timestamp? lastPassIssued;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "statusMessage")
  String statusMessage;
  ConcessionDetailsModel({
    required this.status,
    required this.statusMessage,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.ageMonths,
    required this.ageYears,
    required this.duration,
    required this.address,
    required this.branch,
    required this.type,
    required this.dob,
    required this.from,
    required this.gender,
    required this.gradyear,
    required this.idCardURL,
    this.lastPassIssued,
    required this.phoneNum,
    required this.previousPassURL,
    required this.to,
    required this.travelLane,
  });

  factory ConcessionDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ConcessionDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConcessionDetailsModelToJson(this);
}
