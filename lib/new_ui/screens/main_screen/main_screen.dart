import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/home_screen/home_screen.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';
import 'package:tsec_app/new_ui/screens/committees_screen/committees_screen.dart';
import 'package:tsec_app/screens/department_screen/department_screen.dart';
import 'package:tsec_app/screens/departmentlist_screen/department_list.dart';
import 'package:tsec_app/screens/tpc_screen.dart';
import 'package:tsec_app/utils/image_assets.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
      // Container(child: Text("TPC")),
      const TPCScreen(),
      const CommitteesScreen(),
      // Container(child: Text("Commi")),
      // Container(),
      const DepartmentListScreen(),
      Container(),
      // ProfilePage(
      //   justLoggedIn: false,
      // ),
    ];

    UserModel? data = ref.watch(userModelProvider);

    // if (data != null) {
    //   NotificationType.makeTopic(ref, data);
    // }
    Uint8List? profilePic = ref.watch(profilePicProvider);
    UserModel? userDetails = ref.watch(userModelProvider);

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
                leadingWidth: MediaQuery.of(context).size.width * 0.7,
                leading: currentBottomNavPage != 4
                    ? Row(
                        children: [
                          const SizedBox(
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
                                  child: const CircleAvatar(
                                    radius: 35,
                                    backgroundImage: AssetImage(
                                        "assets/images/pfpholder.jpg"),
                                  ),
                                ),
                        ],
                      )
                    : Container(),
                // title: ,
                actions: userDetails != null
                    ? [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.white, // White background color
                              shape: CircleBorder(), // Circular shape
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.note,
                                color: Colors.black, // Black icon color
                              ),
                              onPressed: () {
                                GoRouter.of(context).push('/notes');
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.white, // White background color
                              shape: CircleBorder(), // Circular shape
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.event_note,
                                color: Colors.black, // Black icon color
                              ),
                              onPressed: () {
                                // Handle button click
                              },
                            ),
                          ),
                        )
                      ]
                    : [],
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
                          : const CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  AssetImage("assets/images/pfpholder.jpg"),
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        userDetails != null
                            ? (userDetails.isStudent
                                ? userDetails.studentModel!.name
                                : userDetails.facultyModel!.name)
                            : "Tsecite",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontSize: 30),
                      ),
                      const SizedBox(
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
                              .headlineSmall!
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
                              .headlineSmall!
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
                      Link(
                        uri: Uri.parse("mailto:devsclubtsec@gmail.com"),
                        builder: (context, followLink) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Contact Us',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  fontSize: 22,
                                  color: currentPage == 4
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                      : Colors.white,
                                ),
                          ),
                          onTap: () => followLink?.call(),
                        ),
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
