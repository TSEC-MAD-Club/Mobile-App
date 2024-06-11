import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  // List<Widget> widgets = <Widget>[
  //   HomeWidget(),
  //   ERPScreen(),
  //   const TimeTable(),
  //   const RailwayConcessionScreen(),
  //   ProfilePage(
  //     justLoggedIn: false,
  //   ),
  // ];
  late Map<String, Widget> widgetMap;
  @override
  void initState() {
    UserModel? user = ref.read(userModelProvider);
    if (user != null && user.isStudent) {
      widgetMap = {
        "home": HomeWidget(
          changeCurrentPage: (page) {
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
          changeCurrentPage: (page) {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userModelProvider);
    currentPage = widget.currentBottomNavPage;
    // debugPrint(currentPage.toString());
    // debugPrint(widgetMap.keys.toList()[currentPage].toString());
    // debugPrint(widgetMap.values.toList().toString());
    // debugPrint(widgetMap[currentPage].toString());
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
              if(user.isStudent) ...[
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
                  //     BottomNavigationBarItem(
                  //       backgroundColor: Colors.transparent,
                  //       activeIcon: Icon(Icons.home),
                  //       icon: Icon(Icons.home_outlined),
                  //       label: "Home",
                  //     ),
                  //     BottomNavigationBarItem(
                  //       backgroundColor: Colors.transparent,
                  //       icon: Icon(Icons.people_outline),
                  //       activeIcon: Icon(Icons.people_rounded),
                  //       label: "Library",
                  //     ),
                  //     BottomNavigationBarItem(
                  //       backgroundColor: Colors.transparent,
                  //       activeIcon: Icon(Icons.calendar_today),
                  //       icon: Icon(Icons.calendar_today_outlined),
                  //       label: "Time Table",
                  //     ),
                  //     BottomNavigationBarItem(
                  //       backgroundColor: Colors.transparent,
                  //       icon: Icon(Icons.directions_railway_outlined),
                  //       activeIcon: Icon(Icons.directions_railway_filled),
                  //       label: "Railway",
                  //     ),
                  //     BottomNavigationBarItem(
                  //       backgroundColor: Colors.transparent,
                  //       icon: Icon(Icons.person_outline),
                  //       activeIcon: Icon(Icons.person),
                  //       label: "Profile",
                  //     ),
                  //   ]
                  // : [

                    ],
              currentIndex: widgetMap.keys.toList().indexOf(currentPage),
              onTap: (index) {
                // setState(() {
                //   selectedPage = index;
                // });
                widget
                    .changeCurrentBottomNavPage(widgetMap.keys.toList()[index]);
              },
            )
          : null,
      body: widgetMap[currentPage],
    );
  }
}
