import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tsec_app/models/event_model/event_model.dart';
import 'package:tsec_app/new_ui/router.dart';
import 'package:tsec_app/new_ui/screens/home_screen/home_screen.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/notes_screen.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/railway_screen.dart';
import 'package:tsec_app/new_ui/screens/splash_screen/splash_screen.dart';
import 'package:tsec_app/new_ui/screens/main_screen/main_screen.dart';
import 'package:tsec_app/new_ui/screens/login_screen/login_screen.dart';
import "package:tsec_app/new_ui/screens/event_details_screen/event_details.dart";
import 'package:tsec_app/new_ui/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/screens/department_screen/department_screen.dart';
import 'package:tsec_app/screens/departmentlist_screen/department_list.dart';
import 'package:tsec_app/services/localnotificationservice.dart';
import 'package:tsec_app/services/sharedprefsfordot.dart';
import 'package:tsec_app/utils/department_enum.dart';
import 'provider/app_state_provider.dart';
import 'provider/shared_prefs_provider.dart';
import 'provider/theme_provider.dart';
import 'utils/init_get_it.dart';
import 'utils/themes.dart';
import 'firebase_options.example.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/models/user_model/user_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}


var debugprint = "////////////////////////////////////////////////////////////////////////////////////////////////////////TESTING/////////////////////////////////////////////////////////////////////////";





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SharedPreferencesForDot.initializeSharedPreferences();
  await SharedPreferencesForDot.setNewNotificationDot();

  await LocalNotificationService.localNotificationInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
  late FirebaseMessaging _firebaseMessaging;

  // @override
  // void initState() {
  //   super.initState();
  //
  //
  //
  //   _firebaseMessaging = FirebaseMessaging.instance;
  //
  //   // Request permissions for iOS
  //   _firebaseMessaging.requestPermission();
  //
  //   // Get the FCM token and save it to Firestore
  //   _firebaseMessaging.getToken().then((String? token) {
  //     assert(token != null);
  //     print("FCM Token: $token");
  //
  //     // Assume `userId` is the ID of the logged-in user in Firestore
  //     String? userId = FirebaseAuth.instance.currentUser?.uid; //<<<----------------------------------------------
  //     if(userId==null){
  //       userId="";
  //     }
  //
  //     // Save the token to Firestore
  //     FirebaseFirestore.instance
  //         .collection('Students ')
  //         .doc(userId)
  //         .update({'fcmToken': token});
  //   });
  //
  //
  //   // Handle messages when the app is in the foreground
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("Received a message while in the foreground!");
  //     print("Message data: ${message.data}");
  //
  //     if (message.notification != null) {
  //       print("Message also contained a notification: ${message.notification}");
  //     }
  //
  //     // Display the notification as a dialog or snackbar
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text(message.notification?.title ?? 'No Title'),
  //         content: Text(message.notification?.body ?? 'No Body'),
  //       ),
  //     );
  //   });
  //
  //   // Handle messages when the app is in the background but not terminated
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('Message clicked!');
  //     // Handle the notification click event
  //   });
  //
  //   // Get the FCM token and save it to Firestore
  //   _firebaseMessaging.getToken().then((String? token) {
  //     assert(token != null);
  //     print("FCM Token: $token");
  //
  //     // Save the token to Firestore
  //     // You need to write this part to save the token in the 'Students' collection
  //   });
  //
  //   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
  //     if (message != null) {
  //       print('Notification caused app to open from terminated state: ${message.data}');
  //       // Handle the notification click event
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _routes = routes;
  }

  @override
  Widget build(BuildContext context) {
    final _themeMode = ref.watch(themeProvider);
    return ShowCaseWidget(
      builder: (context) => Builder(
        builder: (context) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            builder: (context, child) =>
                MediaQuery(data: getTextScale(context), child: child!),
            routeInformationProvider: _routes.routeInformationProvider,
            routeInformationParser: _routes.routeInformationParser,
            routerDelegate: _routes.routerDelegate,
            title: 'TSEC App',
            themeMode: ThemeMode.dark,
            darkTheme: darkTheme,
          ),
      ),
    );
  }
}