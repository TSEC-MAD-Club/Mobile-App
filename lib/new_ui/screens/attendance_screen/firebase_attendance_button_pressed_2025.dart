/*
CONTAINS 4 FUNCTIONS.

ONE HELPER FUNCTION -> UPDATEDATECOLLECTION.
3 ONPRESSED FUNCTION-> 
* pressedCancelled, pressedAbsent, pressedPresent


exact same function, only change is the action argument to helper function
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/firebase_attendance_totalLects_2025.dart';
import 'package:tsec_app/provider/attendance_provider_overall_local.dart';
import 'package:tsec_app/provider/attendance_provider_total_local.dart';

class FirebaseAttendance2025 {
  final Ref _ref;

  FirebaseAttendance2025(this._ref);

  // METHOD DOCUMENTATION : UPDATE DATE COLLECTION
  // UPDATES THE DATE DOCUMENT INSIDE "DATES" SUB COLLECTION IN FIRE,
  //CREATES DATE DOCUMENT IF FIRST TIME CLICKING ON THE DATE
  // ACCORDINGLY CALLS THE FUNCTION IF ATTENDANCE HAS TO BE SUBTRACTED, ADDED ETC.
  Future<void> updateDateCollection(CollectionReference docref, String date,
      String subjectName, String action) async {
    DocumentSnapshot doc;

    String actionTemp = "";

    try {
      doc = await docref.doc(date).get();
      if (doc.exists) {
        Map data = doc.data() as Map<String, dynamic>;

        actionTemp = data[subjectName] ?? ""; // Storing prev action stored
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
      FirebaseAttendanceTotallects2025()
          .updateLectureAttended(action, subjectName);
      if (action != "Can") {
        FirebaseAttendanceTotallects2025().updateTotalAttendance(subjectName);
      }
      return;
    }
    final from = actionTemp;
    final to = action;
    final attendanceService = FirebaseAttendanceTotallects2025();

    // From Pre
    if (from == "Pre" && to == "Abs") {
      _ref
          .read(attendanceOverallLocalProvider.notifier)
          .updateValue(subjectName, "-");

      attendanceService.decrementAttended(subjectName); // attended--
    } else if (from == "Pre" && to == "Can") {
      _ref
          .read(attendanceOverallLocalProvider.notifier)
          .updateValue(subjectName, "-");

      _ref
          .read(attendanceTotalLocalProvider.notifier)
          .updateValue(subjectName, "-");

      attendanceService.decrementTotalAttendance(subjectName); // total--
      attendanceService.decrementAttended(subjectName); // attended--
    }

    // From Abs
    else if (from == "Abs" && to == "Pre") {
      _ref
          .read(attendanceOverallLocalProvider.notifier)
          .updateValue(subjectName, "+");

      attendanceService.updateLectureAttended("Pre", subjectName); // attended++
    } else if (from == "Abs" && to == "Can") {
      _ref
          .read(attendanceTotalLocalProvider.notifier)
          .updateValue(subjectName, "-");

      attendanceService.decrementTotalAttendance(subjectName); // total--
    }

    // From Can
    else if (from == "Can" && to == "Pre") {
      _ref
          .read(attendanceOverallLocalProvider.notifier)
          .updateValue(subjectName, "+");

      _ref
          .read(attendanceTotalLocalProvider.notifier)
          .updateValue(subjectName, "+");

      attendanceService.updateTotalAttendance(subjectName); // total++
      attendanceService.updateLectureAttended("Pre", subjectName); // attended++
    } else if (from == "Can" && to == "Abs") {
      _ref
          .read(attendanceTotalLocalProvider.notifier)
          .updateValue(subjectName, "+");

      attendanceService.updateTotalAttendance(subjectName); // total++
    }
  }

  Future<void> pressedCancelled(DateTime date, String subjectName) async {
    try {
      CollectionReference attendanceTest =
          FirebaseFirestore.instance.collection("AttendanceTest");

      final String? uid =
          FirebaseAuth.instance.currentUser?.uid ?? "default-uid";

      DocumentReference userDoc = attendanceTest.doc(uid);

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

      final String? uid =
          FirebaseAuth.instance.currentUser?.uid ?? "default-uid";
      DocumentReference userDoc = attendanceTest.doc(uid);
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

      final String? uid =
          FirebaseAuth.instance.currentUser?.uid ?? "default-uid";
      DocumentReference userDoc = attendanceTest.doc(uid);
      CollectionReference dates = userDoc.collection('dates');

      await updateDateCollection(
          dates, DateFormat('yyyy-MM-dd').format(date), subjectName, "Abs");
    } catch (e) {
      rethrow;
    }
  }
}
