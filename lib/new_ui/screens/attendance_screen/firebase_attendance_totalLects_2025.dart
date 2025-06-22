import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAttendanceTotallects2025 {
  Future<void> updateLectureAttended(String action, String subject) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc('document-test')
          .collection('overallAttendance')
          .doc('overall-attendance');

      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        Map data = documentSnapshot.data() as Map;
        switch (action) {
          case 'Abs':
            data[subject] = (data[subject] ?? 1) - 1;
            break;
          case 'Pre':
            data[subject] = (data[subject] ?? 0) + 1;
            break;
        }

        documentReference.set(data);
      } else {
        Map<String, int> data = {};

        switch (action) {
          case 'Abs':
            data[subject] = 0;
            break;
          case 'Pre':
            data[subject] = 1;
            break;
        }

        documentReference.set(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTotalLects(String action, String subject) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('AttendanceTest')
        .doc('document-test')
        .collection('totalLects')
        .doc('total-lects');

    DocumentSnapshot documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      Map data = documentSnapshot.data() as Map;
      switch (action) {
        case 'Can':
          data[subject] = (data[subject] ?? 1) - 1;
          break;

        default:
          data[subject] = (data[subject] ?? 0) + 1;
          break;
      }

      documentReference.set(data);
    } else {
      Map<String, int> data = {};

      switch (action) {
        case 'Can':
          data[subject] = 0;
          break;
        default:
          data[subject] = 1;
          break;
      }

      documentReference.set(data);
    }
  }
}
