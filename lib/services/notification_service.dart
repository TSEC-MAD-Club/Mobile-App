import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsec_app/models/notification_model/notification_model.dart';

import '../utils/notification_type.dart';

class NotificationService {
  final FirebaseFirestore _firebase;

  NotificationService([FirebaseFirestore? firebase])
      : _firebase = firebase ?? FirebaseFirestore.instance
          ..settings = const Settings(persistenceEnabled: true);

  Query<NotificationModel> get notificationQuery =>
      _firebase.collection("notifications").where("topic", whereIn: [
            NotificationType.yearTopic,
            NotificationType.yearBranchTopic,
            NotificationType.yearBranchDivTopic, 
            NotificationType.yearBranchDivBatchTopic
          ]).withConverter<NotificationModel>(
            fromFirestore: (snapshot, options) =>
                NotificationModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );
}
