import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/subject_model/subject_model.dart';
import 'package:tsec_app/utils/profile_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final subjectsServiceProvider = Provider((ref) {
  return SubjectsService(
    FirebaseFirestore.instance,
  );
});

class SubjectsService {
  final FirebaseFirestore firebaseFirestore;
  SubjectsService(this.firebaseFirestore);
  CollectionReference<Map<String, dynamic>> subjectsCollection =
      FirebaseFirestore.instance.collection('Subjects');

  Future<SubjectModel> fetchSubjects(StudentModel student) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await subjectsCollection.get();

      Map<String, SemesterData> dataMap = {};

      querySnapshot.docs.forEach((doc) {
        final String documentId = doc.id;
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        dataMap[documentId] = SemesterData.fromJson(data);
      });

      SubjectModel firebaseData = SubjectModel(dataMap: dataMap);

      return firebaseData;
    } catch (error) {
      debugPrint("error is ${error}");
      return SubjectModel(dataMap: {});
    }
  }
}
