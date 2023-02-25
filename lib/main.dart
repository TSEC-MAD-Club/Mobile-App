import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsec_app/models/event_model/event_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/screens/event_detail_screen/event_details.dart';
import 'package:tsec_app/screens/login_screen/login_screen.dart';
import 'package:tsec_app/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'models/student_model/student_model.dart';
import 'provider/app_state_provider.dart';
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

  final _sharedPrefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ProviderScope(
        overrides: [
          sharedPrefsProvider
              .overrideWithValue(SharedPrefsProvider(_sharedPrefs))
        ],
        child: const TSECApp(),
      ),
    );
  });
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _routes = GoRouter(
      urlPathStrategy: UrlPathStrategy.path,
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          name: "main",
          path: "/main",
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: "/splash",
          builder: (context, state) => const SplashScreen(),
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
          name: "details_page",
          path: "/details_page",
          builder: (context, state) {
            EventModel eventModel = EventModel(
                state.queryParams["Event Name"]!,
                state.queryParams["Event Time"]!,
                state.queryParams["Event Date"]!,
                state.queryParams["Event decription"]!,
                state.queryParams["Event registration url"]!,
                state.queryParams["Event Image Url"]!,
                state.queryParams["Event Location"]!,
                state.queryParams["Committee Name"]!);

            return EventDetail(
              eventModel: eventModel,
            );
          },
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

  getuserData(String email) async {
    if (ref.watch(firebaseAuthProvider).currentUser?.uid != null) {
      StudentModel? studentModel = await ref
          .watch(authProvider.notifier)
          .fetchStudentDetails(email, context);
      ref.watch(studentModelProvider.notifier).update((state) => studentModel);
      log(studentModel.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(firebaseAuthProvider).currentUser?.uid != null) {
      getuserData(FirebaseAuth.instance.currentUser!.email.toString());
    }

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
}
