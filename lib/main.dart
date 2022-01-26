import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsec_app/screens/department_screen/department_screen.dart';
import 'firebase_options.dart';
import 'models/notification_model/notification_model.dart';
import 'provider/shared_prefs_provider.dart';
import 'provider/theme_provider.dart';
import 'screens/notification_screen/widgets/notification_dialog.dart';
import 'utils/init_get_it.dart';
import 'utils/notification_type.dart';
import 'utils/themes.dart';

// To handle all the background messages
// Currently not used but wont work if not present
Future<void> _handleBackgroundMessage(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

  initGetIt();

  WidgetsFlutterBinding.ensureInitialized();
  final _sharedPrefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(SharedPrefsProvider(_sharedPrefs))
      ],
      child: const TSECApp(),
    ),
  );
}

class TSECApp extends ConsumerStatefulWidget {
  const TSECApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TSECAppState();
}

class _TSECAppState extends ConsumerState<TSECApp> {
  @override
  void initState() {
    super.initState();
    _setupFCMNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final _themeMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'TSEC App',
      themeMode: _themeMode,
      theme: theme,
      darkTheme: darkTheme,
      home: const DepartmentScreen(
          departmentName: "Electronics &\nTelecommunication"),
    );
  }

  Future<void> _setupFCMNotifications() async {
    final _messaging = FirebaseMessaging.instance;
    final _permission = await _messaging.requestPermission(provisional: true);

    if ([
      AuthorizationStatus.authorized,
      AuthorizationStatus.provisional,
    ].contains(_permission.authorizationStatus)) {
      _messaging.subscribeToTopic(NotificationType.notification);
      _setupInteractedMessage();
      _messageOnForeground();
    }
  }

  void _messageOnForeground() {
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  Future<void> _setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // from - if message is sent from notification topic
    if (message.from == NotificationType.notification.addTopicsPrefix) {
      showDialog(
        context: context,
        builder: (context) => NotificationDialog(
          notificationModel: NotificationModel(
            message: message.notification!.body!,
            title: message.notification!.title!,
            notificationTime: DateTime.parse(
              message.data["notificationTime"] ?? DateTime.now().toString(),
            ),
            attachments: (message.data["attachments"] as List?)
                ?.map((e) => e as String)
                .toList(),
          ),
        ),
      );
    }
  }
}
