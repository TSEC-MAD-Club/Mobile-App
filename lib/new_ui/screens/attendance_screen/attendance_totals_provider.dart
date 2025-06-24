import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_attendance_totalLects_2025.dart';

class AttendanceData {
  final int attended;
  final int total;

  AttendanceData({required this.attended, required this.total});
}

class AttendanceNotifier extends StateNotifier<AsyncValue<AttendanceData>> {
  AttendanceNotifier(this.subjectName) : super(const AsyncValue.loading()) {
    loadData();
  }

  final String subjectName;

  Future<void> loadData() async {
    try {
      final results = await Future.wait([
        FirebaseAttendanceTotallects2025.getAttendedLectures(subjectName),
        FirebaseAttendanceTotallects2025.getTotalLectures(subjectName),
      ]);
      state = AsyncValue.data(AttendanceData(attended: results[0], total: results[1]));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void incrementAttended() {
    state = state.whenData((data) => AttendanceData(attended: data.attended + 1, total: data.total));
  }

  void decrementAttended() {
    state = state.whenData((data) => AttendanceData(attended: data.attended - 1, total: data.total));
  }

  void incrementTotal() {
    state = state.whenData((data) => AttendanceData(attended: data.attended, total: data.total + 1));
  }

  void decrementTotal() {
    state = state.whenData((data) => AttendanceData(attended: data.attended, total: data.total - 1));
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading(); // Make sure to reset loading state
    await loadData(); // Should fetch new values from Firebase
  }
}

final attendanceTotalsProvider = StateNotifierProvider.family<AttendanceNotifier, AsyncValue<AttendanceData>, String>(
      (ref, subjectName) => AttendanceNotifier(subjectName),
);
