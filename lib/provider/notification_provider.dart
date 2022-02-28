import 'package:flutter_riverpod/flutter_riverpod.dart';

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
