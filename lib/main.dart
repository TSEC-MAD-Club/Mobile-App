import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsec_app/screens/event_detail_screen/event_details.dart';
import 'firebase_options.dart';
import 'models/notification_model/notification_model.dart';
import 'provider/app_state_provider.dart';
import 'provider/notification_provider.dart';
import 'provider/shared_prefs_provider.dart';
import 'provider/theme_provider.dart';
import 'screens/committees_screen.dart';
import 'screens/departmentlist_screen/department_list.dart';
import 'screens/department_screen/department_screen.dart';
import 'screens/main_screen/main_screen.dart';
import 'screens/notification_screen/notification_screen.dart';
import 'screens/theme_screen/theme_screen.dart';
import 'screens/tpc_screen.dart';
import 'utils/department_enum.dart';
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

  //if (kDebugMode) _setupEmulators();

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
  late final GoRouter _routes;

  @override
  void initState() {
    super.initState();
    _setupFCMNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _routes = GoRouter(
      urlPathStrategy: UrlPathStrategy.path,
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => const MainScreen(),
          redirect: (_) {
            if (ref.read(appStateProvider).isFirstOpen) return "/theme";
            return null;
          },
        ),
        GoRoute(
          path: "/notifications",
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: "/theme",
          builder: (context, state) => const ThemeScreen(),
        ),
        GoRoute(
          path: "/committee",
          builder: (context, state) => const CommitteesScreen(),
        ),
        GoRoute(
          path: "/tpc",
          builder: (context, state) => const TPCScreen(),
        ),
        GoRoute(
          path: "/details_page",
          builder: (context, state) => const EventDetail(),
        ),
        GoRoute(
          path: "/department",
          builder: (context, state) {
            final department = DepartmentEnum
                .values[int.parse(state.queryParams["department"] as String)];
            return DepartmentScreen(department: department);
          },
        ),
        GoRoute(
          path: "/department-list",
          builder: (context, state) => const DepartmentListScreen(),
        ),
      ],
      refreshListenable: ref.watch(appStateProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      routeInformationParser: _routes.routeInformationParser,
      routerDelegate: _routes.routerDelegate,
      title: 'TSEC App',
      themeMode: _themeMode,
      theme: theme,
      darkTheme: darkTheme,
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
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
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
      ref.read(notificationProvider.state).state = NotificationProvider(
        notificationModel: NotificationModel.fromMessage(message),
        isForeground: false,
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (message.from == NotificationType.notification.addTopicsPrefix) {
      ref.read(notificationProvider.state).state = NotificationProvider(
        notificationModel: NotificationModel.fromMessage(message),
        isForeground: true,
      );
    }
  }
}

void _setupEmulators() {
  FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
  FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
}
