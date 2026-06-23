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

/// Tracks local-only pending attendance changes before they are submitted.
/// Key = subject name, Value = action ("Pre", "Abs", "Can").
class PendingAttendanceNotifier extends StateNotifier<Map<String, String>> {
  PendingAttendanceNotifier() : super({});

  void setPending(String subject, String action) {
    state = {...state, subject: action};
  }

  void removePending(String subject) {
    if (!state.containsKey(subject)) return;
    final newState = Map<String, String>.from(state);
    newState.remove(subject);
    state = newState;
  }

  void clearAll() {
    state = {};
  }

  bool get hasPendingChanges => state.isNotEmpty;
}

final pendingAttendanceProvider =
    StateNotifierProvider<PendingAttendanceNotifier, Map<String, String>>(
        (ref) => PendingAttendanceNotifier());

/// Loading flag while the batch apply is in progress.
final isSubmittingAttendanceProvider = StateProvider<bool>((ref) => false);
