// class SubjectModel {
//   late List<String> subjects;
//
//   SubjectModel({required this.subjects});
// }

import 'package:equatable/equatable.dart';

class SubjectModel extends Equatable {
  Map<String, SemesterData> dataMap;

  SubjectModel({required this.dataMap});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    final Map<String, SemesterData> dataMap = {};

    json.forEach((key, value) {
      dataMap[key] = SemesterData.fromJson(value);
    });

    return SubjectModel(dataMap: dataMap);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    dataMap.forEach((key, value) {
      json[key] = value.toJson();
    });

    return json;
  }

  @override
  List<Object?> get props => [
        dataMap,
      ];
}

class SemesterData {
  List<String> even_sem;
  List<String> odd_sem;

  SemesterData({required this.even_sem, required this.odd_sem});

  factory SemesterData.fromJson(Map<String, dynamic> json) {
    return SemesterData(
      even_sem: List<String>.from(json['even_sem']),
      odd_sem: List<String>.from(json['odd_sem']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'even_sem': even_sem,
      'odd_sem': odd_sem,
    };
  }
}
