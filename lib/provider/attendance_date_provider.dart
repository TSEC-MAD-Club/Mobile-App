import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final attendanceDateprovider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class AttendanceDateProvider extends StateNotifier<Map> {
  AttendanceDateProvider() : super({});

  void addEntry(String key, String value) {
    state = {
      ...state,
      key: value,
    };
  }

  void setState(Map data) {
    state = data;
  }

  void clearState() {
    state = {};
  }

  Map get currentState => state;
}

final dateTimetablePreAbsCanProvider =
    StateNotifierProvider<AttendanceDateProvider, Map>((ref) {
  return AttendanceDateProvider();
});

Future<Map<String, dynamic>?>? getLoggedAttendance (DateTime date) {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final snapshot =  firestore
      .collection("AttendanceTest")
      .doc(uid)
      .collection("dates")
      .doc(formattedDate)
      .get()
      .then((value) => value.data());
  return snapshot;

}
