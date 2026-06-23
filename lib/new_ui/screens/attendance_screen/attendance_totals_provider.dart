import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_attendance_totalLects_2025.dart';

final fetchedAttendanceTotalsProvider = StateProvider<AttendanceTotals>((ref) {
  return AttendanceTotals(attended: {}, total: {});
});

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
      
      int att = results[0];
      int tot = results[1];
      
      if (att > tot) {
        tot = att;
      }
      
      state = AsyncValue.data(AttendanceData(attended: att, total: tot));
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
    await Future.delayed(const Duration(seconds: 2));
    await loadData(); // Should fetch new values from Firebase
  }
}

final attendanceTotalsPerLectureProvider = StateNotifierProvider.family<AttendanceNotifier, AsyncValue<AttendanceData>, String>(
      (ref, subjectName) => AttendanceNotifier(subjectName),
);


class AttendanceTotals {
  final Map<String, int> attended;
  final Map<String, int> total;

  AttendanceTotals({required this.attended, required this.total});
}

class AttendanceTotalsNotifier extends StateNotifier<AsyncValue<AttendanceTotals>> {
  AttendanceTotalsNotifier() : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      final attended = await getTotalAttended();
      final total = await getTotalLectures();
      
      bool needsRepair = false;
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      
      // Sanitize data: if attended > total due to previous race conditions, fix it
      for (final key in attended.keys) {
        int att = attended[key] ?? 0;
        int tot = total[key] ?? 0;
        
        if (att > tot) {
          total[key] = att;
          needsRepair = true;
        }
      }
      
      // Write the repaired total back to Firestore to fix the corruption permanently
      if (needsRepair && uid != null) {
        await FirebaseFirestore.instance
            .collection('AttendanceTest')
            .doc(uid)
            .collection('overallAttendance')
            .doc('totalAttendance')
            .set(total);
      }

      state = AsyncValue.data(AttendanceTotals(attended: attended, total: total));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }


  Future<Map<String, int>> getTotalAttended() async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid ?? "default-uid";
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc(uid)
          .collection('overallAttendance')
          .doc('overall-attendance');

      DocumentSnapshot documentSnapshot = await documentReference.get();

      return documentSnapshot.exists
          ? Map<String, int>.from(documentSnapshot.data() as Map)
          : {};
    }
    catch (e) {
      throw Exception("Failed to fetch total attended lectures: $e");
    }
  }

  Future<Map<String, int>> getTotalLectures() async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid ??
          "default-uid";
      DocumentReference totalReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc(uid)
          .collection('overallAttendance')
          .doc('totalAttendance');

      DocumentSnapshot totalSnapshot = await totalReference.get();

      return totalSnapshot.exists
          ? Map<String, int>.from(totalSnapshot.data() as Map)
          : {};
    } catch (e) {
      throw Exception("Failed to fetch total lectures: $e");
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading(); // Reset loading state
    await Future.delayed(const Duration(seconds: 2));
    await loadData(); // Fetch new values from Firebase
  }
}

final attendanceTotalsProvider = StateNotifierProvider<AttendanceTotalsNotifier, AsyncValue<AttendanceTotals>>(
  (ref) => AttendanceTotalsNotifier(),
);