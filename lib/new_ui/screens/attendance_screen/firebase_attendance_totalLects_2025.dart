import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAttendanceTotallects2025 {
  Future<void> updateLectureAttended(String action, String subject) async {
    print("Updating lecture attended for $subject with action $action");
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid ?? "default-uid";
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc(uid)
          .collection('overallAttendance')
          .doc('overall-attendance');

      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        Map data = documentSnapshot.data() as Map;
        switch (action) {
          case 'Abs':
            data[subject] = (data[subject] ?? 0);
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

        documentReference.set(data);}
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTotalAttendance(String subject) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid ?? "default-uid";
      DocumentReference totalReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc(uid)
          .collection('overallAttendance')
          .doc('totalAttendance');

      DocumentSnapshot totalSnapshot = await totalReference.get();

      if (totalSnapshot.exists) {
        Map data = totalSnapshot.data() as Map;
        data[subject] = (data[subject] ?? 0) + 1;
        totalReference.set(data);
      } else {
        Map<String, int> data = {};
            data[subject] = 1;
          totalReference.set(data);
        }
      } catch (e) {
      rethrow;
    }
  }

  static Future<int> getTotalLectures(String subject) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid ?? "default-uid";
      DocumentReference totalReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc(uid)
          .collection('overallAttendance')
          .doc('totalAttendance');

      DocumentSnapshot totalSnapshot = await totalReference.get();

      if (totalSnapshot.exists) {
        Map data = totalSnapshot.data() as Map;
        return data[subject] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> getAttendedLectures(String subject) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid ??
          "default-uid";
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc(uid)
          .collection('overallAttendance')
          .doc('overall-attendance');
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        Map data = documentSnapshot.data() as Map;
        return data[subject] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> decrementTotalAttendance(String subject) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid ??
          "default-uid";
      DocumentReference totalReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc(uid)
          .collection('overallAttendance')
          .doc('totalAttendance');
      DocumentSnapshot totalSnapshot = await totalReference.get();
      if (totalSnapshot.exists) {
        Map data = totalSnapshot.data() as Map;
        if (data.containsKey(subject)) {
          data[subject] = (data[subject] ?? 0) - 1;
          if (data[subject] < 0) {
            data[subject] = 0; // Ensure it doesn't go below zero
          }
          await totalReference.set(data);
        }
        else {
          data[subject] = 0; // Initialize if not present
          await totalReference.set(data);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> decrementAttended (String subject) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid ??
          "default-uid";
      DocumentReference totalReference = FirebaseFirestore.instance
          .collection('AttendanceTest')
          .doc(uid)
          .collection('overallAttendance')
          .doc('overall-attendance');
      DocumentSnapshot totalSnapshot = await totalReference.get();
      if (totalSnapshot.exists) {
        Map data = totalSnapshot.data() as Map;
        if (data.containsKey(subject)) {
          data[subject] = (data[subject] ?? 0) - 1;
          if (data[subject] < 0) {
            data[subject] = 0; // Ensure it doesn't go below zero
          }
          await totalReference.set(data);
        }
        else {
          data[subject] = 0; // Initialize if not present
          await totalReference.set(data);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
