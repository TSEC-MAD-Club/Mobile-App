import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsec_app/models/notification_model/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firebase;

  NotificationService([FirebaseFirestore? firebase])
      : _firebase = firebase ?? FirebaseFirestore.instance
          ..settings = const Settings(persistenceEnabled: true);

  CollectionReference<NotificationModel> get notificationQuery =>
      _firebase.collection("notifications").withConverter<NotificationModel>(
            fromFirestore: (snapshot, options) =>
                NotificationModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );
}
