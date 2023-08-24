import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/utils/notification_type.dart';

final timetableServiceProvider = Provider<TimeTableService>((ref) {
  // final data = ref.watch(notificationTypeProvider);
  // ref.listen<NotificationTypeC?>(notificationTypeProvider,
  //     (NotificationTypeC? previousC, NotificationTypeC? newC) {
  //   print('The counter changed ${newC!.yearBranchDivBatchTopic}');
  // });
  // print("over here, reloaded ${data?.yearBranchDivTopic}");
  return TimeTableService(ref.watch(firestoreProvider));
});

// final timetableServiceProvider =
//     Provider.family<TimeTableService, NotificationTypeC?>((ref, data) {
//   print("over here, reloaded ${data?.yearBranchDivTopic}");
//   return TimeTableService(ref.watch(firestoreProvider));
// });

class TimeTableService {
  final FirebaseFirestore _firestore;
  TimeTableService(FirebaseFirestore firestore) : _firestore = firestore;

  // Stream get timetableDocref => _firestore
  //     .collection('TimeTable')
  //     .doc(NotificationType.yearBranchDivTopic)
  //     .snapshots();

  Stream<Map<String, dynamic>?> getweekTimetable(String? data) {
    final d = data ?? NotificationType.yearBranchDivTopic;
    return _firestore
        .collection('TimeTable 2023')
        .doc(d)
        .snapshots()
        .map((doc) => doc.data());
  }
}
