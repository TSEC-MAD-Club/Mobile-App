import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService
{
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final messaging = FirebaseMessaging.instance;

  static localNotificationInit()
  async{

    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var darwinInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings
    );


    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static showNotification()
  {

    RemoteMessage message2 = RemoteMessage(notification: RemoteNotification(title: "Sample Notification",body: "Sample Body"),);

    AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "High Importance Notification",
        importance: Importance.max
    );


    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        androidNotificationChannel.id,
        androidNotificationChannel.name,
        channelDescription: "This is Channel Description",
        importance: Importance.high,
        priority: Priority.high,
        ticker: "ticker"
    );

    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true,presentBadge: true,presentBanner: true,presentList: true,presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails,iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, ()=>{
      flutterLocalNotificationsPlugin.show(
          0,
          message2.notification!.title,
          message2.notification!.body,
          notificationDetails,)
    });
  }

}