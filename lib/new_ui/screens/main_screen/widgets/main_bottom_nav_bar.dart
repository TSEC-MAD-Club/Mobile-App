import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/erp_screen/erp_screen.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/home_widget.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/railway_screen.dart';
import 'package:tsec_app/new_ui/screens/timetable_screen/timetable_screen.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/new_ui/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';
import 'package:tsec_app/services/sharedprefsfordot.dart';

import '../../notes_screen/notes_screen.dart';

class MainBottomNavBar extends ConsumerStatefulWidget {
  String currentBottomNavPage;
  Function changeCurrentBottomNavPage;
  Function(int) onTileTap;
  MainBottomNavBar(
      {required this.currentBottomNavPage,
        required this.changeCurrentBottomNavPage,
        required this.onTileTap,
        super.key});

  @override
  ConsumerState<MainBottomNavBar> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<MainBottomNavBar> {
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
          changeCurrentPage: (page,index) {
            setState(() {
              widget.changeCurrentBottomNavPage(page);
            });
          },
        ),
        "notes": NotesScreen(),
        "timetable": const TimeTable(),
        "concession": const RailwayConcessionScreen(),
        "profile": ProfilePage(
          justLoggedIn: false,
        )
      };
    }
    else {
      widgetMap = {
        "home": HomeWidget(
          changeCurrentPage: (page,index) {
            setState(() {
              widget.changeCurrentBottomNavPage(page);
            });
          },
        ),
        "notes": NotesScreen(),
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
      return user != null && !concessionOpen
          ? BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: cardcolorblue,
        selectedItemColor: oldDateSelectBlue,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            activeIcon: Icon(Icons.home,),
            icon: Icon(Icons.home_outlined,),
            label: "Home",
          ),
          if(user.isStudent) ...[
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              activeIcon: Icon(Icons.notes),
              icon: Icon(Icons.notes_outlined),
              label: "Notes",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Stack(
                children: [
                  Icon(Icons.directions_railway_outlined),
                  SharedPreferencesForDot.getRailwayDot() ? Positioned(right: 0,top: 0,child: Icon(Icons.circle,color: Colors.red,size: 10,),) : SizedBox(),
                ],
              ),
              activeIcon: Icon(Icons.directions_railway_filled),
              label: "Railway",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            )
          ],

          if(user.facultyModel != null)
            ... [
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.file_open_outlined),
              activeIcon: Icon(Icons.file_open_sharp),
              label: "Notes",
            ),
            BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
          ]



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
          widget.changeCurrentBottomNavPage(widgetMap.keys.toList()[index]);
          widget.onTileTap(index);
        },
      )
          : SizedBox(width: 1, height: 1, child: Container());

  }
}
