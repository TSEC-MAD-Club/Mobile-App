import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/subject_model/subject_model.dart';
import 'package:tsec_app/services/subjects_service.dart';

final subjectsProvider =
    StateNotifierProvider<SubjectsProvider, SubjectModel>(((ref) {
  return SubjectsProvider(
      ref: ref, subjectService: ref.read(subjectsServiceProvider));
}));

class SubjectsProvider extends StateNotifier<SubjectModel> {
  SubjectsService subjectService;

  Ref ref;

  SubjectsProvider({required this.subjectService, required this.ref})
      : super(SubjectModel(dataMap: {}));

  Future fetchSubjects(StudentModel student) async {
    SubjectModel subModel = await subjectService.fetchSubjects(student);
    // debugPrint("in subjects provider ${subModel.toString()}");
    state = subModel;
  }
}
