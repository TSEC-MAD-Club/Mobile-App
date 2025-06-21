/*
CONTAINS 4 FUNCTIONS.

ONE HELPER FUNCTION -> UPDATEDATECOLLECTION.
3 ONPRESSED FUNCTION-> 
* pressedCancelled, pressedAbsent, pressedPresent


exact same function, only change is the action argument to helper function
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/firebase_attendance_totalLects_2025.dart';

class FirebaseAttendance2025 {
  Future<void> updateDateCollection(CollectionReference docref, String date,
      String subjectName, String action) async {
    DocumentSnapshot doc;

    String actionTemp = "";

    try {
      doc = await docref.doc(date).get();
      if (doc.exists) {
        Map data = doc.data() as Map<String, dynamic>;

        actionTemp = data[subjectName] ?? "ded"; // Storing prev action stored
        data[subjectName] = action; // New action

        await docref.doc(date).set(data);
      } else {
        await docref.doc(date).set({subjectName: action});
      }
    } catch (e) {
      rethrow;
    }

    if (actionTemp == "") {
      // FIRST TIME CLICKING
      if (action == "Pre") {
        FirebaseAttendanceTotallects2025()
            .updateLectureAttended("Pre", subjectName);
      }
    } else if (action == 'Pre' && actionTemp != 'Pre') {
      FirebaseAttendanceTotallects2025()
          .updateLectureAttended("Pre", subjectName);
    } else if ((action == 'Abs' || action == 'Can') && actionTemp == 'Pre') {
      FirebaseAttendanceTotallects2025()
          .updateLectureAttended("Abs", subjectName);
    }
  }

  Future<void> pressedCancelled(DateTime date, String subjectName) async {
    try {
      CollectionReference attendanceTest =
          FirebaseFirestore.instance.collection("AttendanceTest");

      DocumentReference userDoc = attendanceTest.doc('document-test');

      CollectionReference dates = userDoc.collection('dates');

      await updateDateCollection(
          dates, DateFormat('yyyy-MM-dd').format(date), subjectName, "Can");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pressedPresent(DateTime date, String subjectName) async {
    try {
      CollectionReference attendanceTest =
          FirebaseFirestore.instance.collection("AttendanceTest");

      DocumentReference userDoc = attendanceTest.doc('document-test');
      CollectionReference dates = userDoc.collection('dates');

      await updateDateCollection(
          dates, DateFormat('yyyy-MM-dd').format(date), subjectName, "Pre");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pressedAbsent(DateTime date, String subjectName) async {
    try {
      CollectionReference attendanceTest =
          FirebaseFirestore.instance.collection("AttendanceTest");

      DocumentReference userDoc = attendanceTest.doc('document-test');
      CollectionReference dates = userDoc.collection('dates');

      await updateDateCollection(
          dates, DateFormat('yyyy-MM-dd').format(date), subjectName, "Abs");
    } catch (e) {
      rethrow;
    }
  }
}
