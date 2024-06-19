import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/utils/notification_type.dart';

import '../models/notification_model/notification_model.dart';

final notificationProvider = StateProvider<NotificationProvider?>((_) {
  return null;
});

class NotificationProvider {
  final NotificationModel? notificationModel;
  final bool isForeground;

  NotificationProvider({
    this.notificationModel,
    this.isForeground = false,
  });
}

final notificationListProvider = StreamProvider<QuerySnapshot>((ref){
  return FirebaseFirestore.instance
      .collection('notifications')
      .orderBy('notificationTime', descending: true)
      .where("topic", whereIn: [
    NotificationType.notification,
    NotificationType.yearTopic,
    NotificationType.yearBranchTopic,
    NotificationType.yearBranchDivTopic,
    NotificationType.yearBranchDivBatchTopic
  ])
      .snapshots();
});
