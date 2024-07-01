import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/erp_screen/erp_screen.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/home_widget.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/railway_screen.dart';
import 'package:tsec_app/new_ui/screens/timetable_screen/timetable_screen.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/new_ui/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  String currentBottomNavPage;
  Function changeCurrentBottomNavPage;
  HomeScreen(
      {required this.currentBottomNavPage,
        required this.changeCurrentBottomNavPage,
        super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late String currentPage;
  late FirebaseMessaging _firebaseMessaging;

  late Map<String, Widget> widgetMap;

  @override
  void initState() {
    super.initState();
    UserModel? user = ref.read(userModelProvider);

    _firebaseMessaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    _firebaseMessaging.requestPermission();

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message while in the foreground!");
      print("Message data: ${message.data}");

      if (message.notification != null) {
        print("Message also contained a notification: ${message.notification}");
      }

      // Display the notification as a dialog or snackbar
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message.notification?.title ?? 'No Title'),
          content: Text(message.notification?.body ?? 'No Body'),
        ),
      );
    });

    // Handle messages when the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      // Handle the notification click event
    });

    // Get the FCM token and save it to Firestore
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("FCM Token: $token");

      // Save the token to Firestore
      // You need to write this part to save the token in the 'Students' collection
    });

    if (user != null && user.isStudent) {
      widgetMap = {
        "home": HomeWidget(
          changeCurrentPage: (page, index) {
            setState(() {
              widget.changeCurrentBottomNavPage(page);
            });
          },
        ),
        "attendance": ERPScreen(),
        "timetable": const TimeTable(),
        "concession": const RailwayConcessionScreen(),
        "profile": ProfilePage(
          justLoggedIn: false,
        )
      };
    } else {
      widgetMap = {
        "home": HomeWidget(
          changeCurrentPage: (page, index) {
            setState(() {
              widget.changeCurrentBottomNavPage(page);
            });
          },
        ),
        "attendance": ERPScreen(),
        "profile": ProfilePage(
          justLoggedIn: false,
        )
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userModelProvider);
    currentPage = widget.currentBottomNavPage;
    bool concessionOpen = ref.watch(railwayConcessionOpenProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: user != null && !concessionOpen
          ? BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people_rounded),
            label: "Library",
          ),
          if (user.isStudent) ...[
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              activeIcon: Icon(Icons.calendar_today),
              icon: Icon(Icons.calendar_today_outlined),
              label: "Time Table",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.directions_railway_outlined),
              activeIcon: Icon(Icons.directions_railway_filled),
              label: "Railway",
            ),
          ],
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: widgetMap.keys.toList().indexOf(currentPage),
        onTap: (index) {
          widget.changeCurrentBottomNavPage(
              widgetMap.keys.toList()[index]);
        },
      )
          : null,
      body: widgetMap[currentPage],
    );
  }
}
