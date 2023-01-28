import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/utils/notification_type.dart';

final timetableServiceProvider = Provider<TimeTableService>((ref) {
  return TimeTableService(ref.watch(firestoreProvider));
});

class TimeTableService {
  final FirebaseFirestore _firestore;
  TimeTableService(FirebaseFirestore firestore) : _firestore = firestore;

  Stream get timetableDocref =>
      _firestore.collection('TimeTable')
      .doc(NotificationType.yearBranchDivTopic)
      .snapshots();

  Stream<Map<String, dynamic>> getweekTimetable() {
    return timetableDocref.map((doc) => doc.data());
  }
}
