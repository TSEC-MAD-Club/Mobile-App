import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/new_ui/screens/home_screen/home_screen.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/occasion_provider.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';
import 'package:tsec_app/screens/departmentlist_screen/department_list.dart';
import 'package:tsec_app/screens/main_screen/widget/card_display.dart';
import 'package:tsec_app/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/utils/notification_type.dart';
import 'package:tsec_app/utils/timetable_util.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import '../../models/event_model/event_model.dart';
// import '../../provider/event_provider.dart';
// import '../../utils/image_assets.dart';

// import '../../utils/launch_url.dart';
// import '../../utils/themes.dart';
// import '../../widgets/custom_scaffold.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  static const colorList = [Colors.red, Colors.teal, Colors.blue];
  static const opacityList = [
    Color.fromRGBO(255, 0, 0, 0.2),
    Color.fromARGB(51, 0, 255, 225),
    Color.fromARGB(51, 0, 153, 255),
  ];

  static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int currentBottomNavPage = 0;
  int currentPage = 0;

  late List<Widget> pages;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      HomeScreen(
        currentBottomNavPage: currentBottomNavPage,
        changeCurrentBottomNavPage: (int index) {
          setState(() {
            currentBottomNavPage = index;
          });
        },
      ),
      Container(child: Text("TPC")),
      Container(child: Text("Commi")),
      Container(),
      Container(),
      // ProfilePage(
      //   justLoggedIn: false,
      // ),
    ];
    final _size = MediaQuery.of(context).size;
    var _theme = Theme.of(context);
    var _boxshadow = BoxShadow(
      color: _theme.primaryColorDark,
      spreadRadius: 1,
      blurRadius: 2,
      offset: const Offset(0, 1),
    );
    StudentModel? data = ref.watch(studentModelProvider);

    if (data != null) {
      NotificationType.makeTopic(ref, data);

      // String studentYear = data.gradyear.toString();
      // String studentBranch = data.branch.toString();
      // String studentDiv = data.div.toString();
      // String studentBatch = data.batch.toString();
      // ref.read(notificationTypeProvider.notifier).state = NotificationTypeC(
      //     notification: "All",
      //     yearTopic: studentYear,
      //     yearBranchTopic: "$studentYear-$studentBranch",
      //     yearBranchDivTopic: "$studentYear-$studentBranch-$studentDiv",
      //     yearBranchDivBatchTopic:
      //         "$studentYear-$studentBranch-$studentDiv-$studentBatch");
    }
    Uint8List? profilePic = ref.watch(profilePicProvider);
    StudentModel? studentDetails = ref.watch(studentModelProvider);

    bool concessionOpen = ref.watch(railwayConcessionOpenProvider);
    // debugPrint("concession status is $concessionOpen");
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: currentBottomNavPage != 3 || !concessionOpen
            ? AppBar(
                shadowColor: Colors.transparent,
                backgroundColor: currentBottomNavPage != 4
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.primary,
                toolbarHeight: 80,
                leadingWidth: 100,
                leading: currentBottomNavPage != 4
                    ? Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          profilePic != null
                              ? GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: MemoryImage(profilePic),
                                    // backgroundImage: MemoryImage(_image!),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: AssetImage(
                                        "assets/images/pfpholder.jpg"),
                                  ),
                                ),
                        ],
                      )
                    : Container(),
                title: Text(
                  currentBottomNavPage == 0
                      ? "Home"
                      : currentBottomNavPage == 3
                          ? "Railway Concession"
                          : "",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontSize: 34),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: Colors.white, // White background color
                        shape: CircleBorder(), // Circular shape
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.note,
                          color: Colors.black, // Black icon color
                        ),
                        onPressed: () {
                          // Handle button click
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: Colors.white, // White background color
                        shape: CircleBorder(), // Circular shape
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.event_note,
                          color: Colors.black, // Black icon color
                        ),
                        onPressed: () {
                          // Handle button click
                        },
                      ),
                    ),
                  )
                ],
              )
            : null,
        drawer: !concessionOpen
            ? Drawer(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                backgroundColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profilePic != null
                          ? CircleAvatar(
                              radius: 35,
                              backgroundImage: MemoryImage(profilePic),
                              // backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  AssetImage("assets/images/pfpholder.jpg"),
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        studentDetails != null
                            ? studentDetails.name
                            : "Tsecite",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontSize: 30),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Home',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 22,
                                color: currentPage == 0
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Colors.white,
                              ),
                        ),
                        onTap: () {
                          setState(() {
                            currentPage = 0;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'TPC',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 22,
                                color: currentPage == 1
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Colors.white,
                              ),
                        ),
                        onTap: () {
                          setState(() {
                            currentPage = 1;
                          });

                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Committees and Events',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 22,
                                color: currentPage == 2
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Colors.white,
                              ),
                        ),
                        onTap: () {
                          setState(() {
                            currentPage = 2;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Departments',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 22,
                                color: currentPage == 3
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Colors.white,
                              ),
                        ),
                        onTap: () {
                          setState(() {
                            currentPage = 3;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Contact Us',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 22,
                                color: currentPage == 4
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Colors.white,
                              ),
                        ),
                        onTap: () {
                          setState(() {
                            currentPage = 4;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      // ListTile(
                      //   contentPadding: EdgeInsets.zero,
                      //   title: Text(
                      //     'Profile',
                      //     style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      //           fontSize: 22,
                      //           color: currentPage == 5
                      //               ? Theme.of(context).colorScheme.onBackground
                      //               : Colors.white,
                      //         ),
                      //   ),
                      //   onTap: () {
                      //     setState(() {
                      //       currentPage = 5;
                      //     });
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              data != null ? 'Logout' : 'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontSize: 22,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                            onTap: () {
                              if (data != null) {
                                final _messaging = FirebaseMessaging.instance;

                                ref
                                    .read(studentModelProvider.notifier)
                                    .update((state) => null);
                                ref
                                    .read(profilePicProvider.notifier)
                                    .update((state) => null);
                                _messaging.unsubscribeFromTopic(
                                    NotificationType.notification);
                                _messaging.unsubscribeFromTopic(
                                    NotificationType.yearBranchDivBatchTopic);
                                _messaging.unsubscribeFromTopic(
                                    NotificationType.yearBranchDivTopic);
                                _messaging.unsubscribeFromTopic(
                                    NotificationType.yearBranchTopic);
                                _messaging.unsubscribeFromTopic(
                                    NotificationType.yearTopic);
                                ref.watch(authProvider.notifier).signout();
                                GoRouter.of(context).go('/login');
                                // Navigator.pop(context);
                              } else {
                                GoRouter.of(context).go('/login');
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : null,
        body: pages[currentPage],
      ),
    );
  }
}
