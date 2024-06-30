import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/bug_report_screen/bug_report_screen.dart';
import 'package:tsec_app/new_ui/screens/coming_soon_screen/coming_soon.dart';
import 'package:tsec_app/new_ui/screens/about_us_screen/about_us.dart';
import 'package:tsec_app/new_ui/screens/erp_screen/erp_screen.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/home_widget.dart';
import 'package:tsec_app/new_ui/screens/main_screen/widgets/main_bottom_nav_bar.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/notes_screen.dart';
import 'package:tsec_app/new_ui/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/railway_screen.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/railwayform.dart';
import 'package:tsec_app/new_ui/screens/timetable_screen/timetable_screen.dart';
import 'package:tsec_app/provider/appbar_title_provider.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';
import 'package:tsec_app/new_ui/screens/committees_screen/committees_screen.dart';
import 'package:tsec_app/screens/departmentlist_screen/department_list.dart';
import 'package:tsec_app/screens/notification_screen/notification_screen.dart';
import 'package:tsec_app/new_ui/screens/committees_screen/old_committees_screen.dart';
import 'package:tsec_app/screens/tpc_screen.dart';
import 'package:url_launcher/link.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String currentBottomNavPage = "home";
  int currentPage = 0;
  int currentDrawerPage = 0;

  void _getIndex(int index) {
    setState(() {
      print(index.toString());
      currentPage = index;
    });
  }

  late List<Widget> pages;
  late Map<String, Widget> widgetMap;

  @override
  void initState() {
    UserModel? user = ref.read(userModelProvider);


      if (user != null && user.isStudent) {
      widgetMap = {
        "home": HomeWidget(
          changeCurrentPage: (page, index) {
            setState(() {
              currentPage = index;
              currentBottomNavPage = page;
            });
          },
        ),
        "notes": const NotesScreen(),
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
              currentPage = index;
              currentBottomNavPage = page;
            });
          },
        ),
        "notes": const NotesScreen(),
        "profile": ProfilePage(
          justLoggedIn: false,
        )
      };
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;


    UserModel? data = ref.watch(userModelProvider);

    if(data!=null && data.facultyModel!=null){
      pages = [
        HomeWidget(
          changeCurrentPage: (page, index) {
            setState(() {
              currentPage = index;
              currentBottomNavPage = page;
            });
          },
        ),
        const NotesScreen(),
        ProfilePage(justLoggedIn: false),
        const RailwayConcessionScreen(),
        const TPCScreen(),
        const CommitteesScreen(),
        const DepartmentListScreen(),
        Container(),
        // ProfilePage(
        //   justLoggedIn: false,
        // ),
      ];
    }else{
    pages = [
      //for User login
      HomeWidget(
        changeCurrentPage: (page, index) {
          setState(() {
            currentPage = index;
            currentBottomNavPage = page;
          });
        },
      ),
      const NotesScreen(),
      const RailwayConcessionScreen(),
      ProfilePage(justLoggedIn: false),
      const TPCScreen(),
      const CommitteesScreen(),
      const DepartmentListScreen(),
      Container(),
      // ProfilePage(
      //   justLoggedIn: false,
      // ),
    ];
    }


    // if (data != null) {
    //   NotificationType.makeTopic(ref, data);
    // }
    Uint8List? profilePic = ref.watch(profilePicProvider);
    UserModel? userDetails = ref.watch(userModelProvider);

    bool concessionOpen = ref.watch(railwayConcessionOpenProvider);
    // debugPrint("concession status is $concessionOpen");
    // debugPrint("current page ${currentBottomNavPage} ${concessionOpen}");
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        // appBar: currentBottomNavPage != "concession" || !concessionOpen
        //     ? AppBar(
        //         shadowColor: Colors.transparent,
        //         backgroundColor: currentBottomNavPage != "profile"
        //             ? Colors.transparent
        //             : Theme.of(context).colorScheme.primary,
        //         toolbarHeight: 80,
        //         //leadingWidth: MediaQuery.of(context).size.width * 0.7,
        //         title: Text(
        //           currentPage < 5
        //               ? (currentBottomNavPage == "home"
        //                   ? "Home"
        //                   : currentBottomNavPage == "attendance"
        //                       ? "ERP"
        //                       : currentBottomNavPage == "notes"
        //                           ? "Notes"
        //                           : currentBottomNavPage == "concession"
        //                               ? "Railway Concession"
        //                               : "")
        //               : currentPage == 5
        //                   ? "TPC"
        //                   : currentPage == 6
        //                       ? "Committees"
        //                       : "Departments",
        //           style: Theme.of(context)
        //               .textTheme
        //               .headlineLarge!
        //               .copyWith(fontSize: 15, color: Colors.white),
        //           maxLines: 1,
        //           overflow: TextOverflow.fade,
        //         ),
        //         centerTitle: true,
        //         leading: currentBottomNavPage != "profile"
        //             ? profilePic != null
        //                 ? GestureDetector(
        //                     onTap: () {
        //                       _scaffoldKey.currentState?.openDrawer();
        //                     },
        //                     child: CircleAvatar(
        //                       radius: 20,
        //                       backgroundImage: MemoryImage(profilePic),
        //                       // backgroundImage: MemoryImage(_image!),
        //                     ),
        //                   )
        //                 : InkWell(
        //                     onTap: () {
        //                       _scaffoldKey.currentState?.openDrawer();
        //                     },
        //                     child: CircleAvatar(radius: 15,backgroundColor: Colors.blue.shade400,child: Icon(Icons.menu,color: Colors.white,)),
        //                   )
        //
        //             // SingleChildScrollView(
        //             //   scrollDirection: Axis.horizontal,
        //             //   child: Container(
        //             //   padding: EdgeInsets.only(left: 10),
        //             //     width: MediaQuery.of(context).size.width * .8,
        //             //     child: Text(
        //             //       currentPage == 0
        //             //           ? (currentBottomNavPage == "home"
        //             //               ? "Home"
        //             //               : currentBottomNavPage == "attendance"
        //             //                   ? "ERP"
        //             //                   : currentBottomNavPage ==
        //             //                           "timetable"
        //             //                       ? "Schedule"
        //             //                       : currentBottomNavPage ==
        //             //                               "concession"
        //             //                           ? "Railway Concession"
        //             //                           : "")
        //             //           : currentPage == 1
        //             //               ? "TPC"
        //             //               : currentPage == 2
        //             //                   ? "Committees"
        //             //                   : "Departments",
        //             //       style: Theme.of(context)
        //             //           .textTheme
        //             //           .headlineLarge!
        //             //           .copyWith(fontSize: 30),
        //             //       maxLines: 1,
        //             //       overflow: TextOverflow.fade,
        //             //     ),
        //             //   ),
        //             // )
        //             : Container(),
        //         // title: Text("Yyay"),
        //         actions: userDetails != null
        //             ? [
        //                 InkWell(
        //                   child: CircleAvatar(
        //                     backgroundColor: Colors.blue.shade400,
        //                     child: Icon(Icons.notifications,color: Colors.white,),
        //                   ),
        //                   onTap: () {
        //                     //Add the Notification Screen here
        //                     //GoRouter.of(context).push('/notes');
        //                     Navigator.push(context,MaterialPageRoute(builder: (context)=> NotificationScreen(),),);
        //                   },
        //                 ),
        //                 SizedBox(
        //                   width: 15,
        //                 ),
        //                 // Padding(
        //                 //   padding: const EdgeInsets.all(8.0),
        //                 //   child: Ink(
        //                 //     decoration: const ShapeDecoration(
        //                 //       color: Colors.white, // White background color
        //                 //       shape: CircleBorder(), // Circular shape
        //                 //     ),
        //                 //     child: IconButton(
        //                 //       icon: const Icon(
        //                 //         Icons.event_note,
        //                 //         color: Colors.black, // Black icon color
        //                 //       ),
        //                 //       onPressed: () {
        //                 //         // Handle button click
        //                 //       },
        //                 //     ),
        //                 //   ),
        //                 // )
        //               ]
        //             : [],
        //       )
        //     : null,


        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            automaticallyImplyLeading: false, // Remove the default back button
            backgroundColor: Colors.transparent,
            elevation: 0,
            title:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/images/new_app_bar/icon_ham.png',
                        width: 39,
                        height: 39,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Text(getTitle(data), style: TextStyle(
                    color: Colors.white, fontSize: size.width * 0.055),),
                Spacer(),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => NotificationScreen(),),);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                      child: Image.asset(
                        'assets/images/new_app_bar/icon_bell.png',
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ),
                ),

                // Second image and other widgets here
              ],
            ),
          ),
        ),
        drawer: !concessionOpen
            ? BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: cardcolorblue, blurRadius: 5, spreadRadius: 3),
              ],
            ),
            child: Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                ),
              ),
              backgroundColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        SizedBox(width: 10,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userDetails != null
                                  ? (userDetails.isStudent
                                  ? userDetails.studentModel!.name
                                  : userDetails.facultyModel!.name)
                                  : "Tsecite",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 20),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              userDetails != null
                                  ? (userDetails.isStudent ?
                              '${userDetails.studentModel!.branch} ${userDetails
                                  .studentModel!.gradyear}' : '${data
                                  ?.facultyModel?.qualification}')
                                  : 'anonymous',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 12),
                            )
                          ],
                        ))
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Home',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                          fontSize: 13,
                          color: currentPage == 0
                              ? Theme
                              .of(context)
                              .colorScheme
                              .onBackground
                              : Colors.white,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          currentPage = 0;
                          currentBottomNavPage = "home";
                        });
                        Navigator.pop(context);
                      },
                    ),
                    /*ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Railway Concession',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                fontSize: 13,
                                color: currentPage == 3 ? Theme.of(context).colorScheme.onBackground : Colors.white,
                              ),
                            ),
                            onTap: () {
                              //page 3
                              setState(() {
                                currentPage = 3;
                                Navigator.pop(context);
                              });
                            },
                          ),*/
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Departments',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                          fontSize: 13,
                          color: currentPage == 7
                              ? Theme
                              .of(context)
                              .colorScheme
                              .onBackground
                              : Colors.white,
                        ),
                      ),
                      onTap: () {
                        ref
                            .read(titleProvider.notifier)
                            .state = 'Departments';
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DepartmentListScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Committees',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                          fontSize: 13,
                          color: currentPage == 6
                              ? Theme
                              .of(context)
                              .colorScheme
                              .onBackground
                              : Colors.white,
                        ),
                      ),
                      onTap: () {
                        ref
                            .read(titleProvider.notifier)
                            .state = 'Committees';
                        /*setState(() {
                                currentPage = 6;
                              });*/
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => CommitteesScreen(),
                            builder: (context) => OldCommittessScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Training and Placement Cell',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                          fontSize: 13,
                          color: currentPage == 5
                              ? Theme
                              .of(context)
                              .colorScheme
                              .onBackground
                              : Colors.white,
                        ),
                      ),
                      onTap: () {
                        ref
                            .read(titleProvider.notifier)
                            .state = 'Training and Placement Cell';
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TPCScreen(),
                          ),
                        );
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
                    /*ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Manage Account',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              //page 4
                              // setState(() {
                              //   currentPage = 4;
                              //   Navigator.pop(context);
                              // });
                            },
                          ),*/
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'About Us',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      /////////////////////////////////////////////////////////////////////////
                      onTap: () {
                        ref
                            .read(titleProvider.notifier)
                            .state = 'About Us';
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutUs(),
                          ),
                        );
                      },
                    ),
                    Link(
                      uri: Uri.parse("mailto:devsclubtsec@gmail.com"),
                      builder: (context, followLink) =>
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Contact Us',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                fontSize: 13,
                                color: currentPage == 4
                                    ? Theme
                                    .of(context)
                                    .colorScheme
                                    .onBackground
                                    : Colors.white,
                              ),
                            ),
                            onTap: () => followLink?.call(),
                          ),
                    ),

                    Spacer(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Coming soon........',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                          fontSize: 13,
                          color: currentPage == 5
                              ? Theme
                              .of(context)
                              .colorScheme
                              .onBackground
                              : Colors.white,
                        ),
                      ),
                      onTap: () {
                        ref
                            .read(titleProvider.notifier)
                            .state = 'Something cooking .....';
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoon(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Report a bug',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                          fontSize: 13,
                          color: currentPage == 5
                              ? Theme
                              .of(context)
                              .colorScheme
                              .onBackground
                              : Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BugReportScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10,),
                    Container(
                      alignment: Alignment.center,
                      width: size.width,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff383838),
                      ),
                      child: InkWell(
                        child: Text(
                          data != null ? 'Logout' : 'Login',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                            fontSize: 22,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .error,
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
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                              text: 'Made with ♥️ TSEC ',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.white),
                              children: [
                                TextSpan(
                                    text: 'Devs Club',
                                    style: TextStyle(fontSize: 10,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700)
                                )
                              ]
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
            : null,
        bottomNavigationBar: MainBottomNavBar(
          onTileTap: _getIndex,
          currentBottomNavPage: currentBottomNavPage,
          changeCurrentBottomNavPage: (String page) {
            setState(() {
              currentBottomNavPage = page;
              // currentPage = widgetMap.keys.toList()[index]
            });
          },
        ),
        body: pages[currentPage],
      ),
    );
  }


  String getTitle(UserModel? data) {
    if (data!=null && data.facultyModel != null) {
      switch (currentPage) {
        case 0:
          return "Home";
        case 1:
          return "Notes";
        case 2:
          return "Profile";
        default:
          return "";
      }
    } else {
      switch (currentPage) {
        case 0:
          return "Home";
        case 1:
          return "Notes";
        case 2:
          return "Railway";
        case 3:
          return "Profile";
        default:
          return "";
      }
    }
  }
}