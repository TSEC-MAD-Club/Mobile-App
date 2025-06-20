// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseAttendanceTotallects2025 {
//   Future<void> updateLectureAttended(String action, String subject) async {
//     try {
//       DocumentReference documentReference = FirebaseFirestore.instance
//           .collection('AttendanceTest')
//           .doc('document-test')
//           .collection('overallAttendance')
//           .doc('overall-attendance');

//       DocumentSnapshot documentSnapshot = await documentReference.get();

//       if (documentSnapshot.exists) {
//         Map<String, int> data = documentSnapshot.data() as Map<String, int>;

//         switch (action) {
//           case 'Abs':
//             data[subject] = data[subject] ?? 0 - 1;
//             break;
//           case 'Pre':
//             data[subject] = data[subject] ?? 0 + 1;
//             break;
//         }

//         documentReference.set(data);
//       } else {
//         Map<String, int> data = {};

//         switch (action) {
//           case 'Abs':
//             data[subject] = 0;
//             break;
//           case 'Pre':
//             data[subject] = 1;
//             break;
//         }

//         documentReference.set(data);
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
