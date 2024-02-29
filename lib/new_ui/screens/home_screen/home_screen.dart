import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/attendance_screen.dart';
import 'package:tsec_app/new_ui/screens/home_screen/widgets/home_widget.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/railway_screen.dart';
import 'package:tsec_app/new_ui/screens/timetable_screen/timetable_screen.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/new_ui/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/provider/railway_concession_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  int currentBottomNavPage;
  Function changeCurrentBottomNavPage;
  HomeScreen(
      {required this.currentBottomNavPage,
      required this.changeCurrentBottomNavPage,
      super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late int currentPage;
  List<Widget> widgets = <Widget>[
    HomeWidget(),
    AttendanceScreen(),
    const TimeTable(),
    const RailwayConcessionScreen(),
    ProfilePage(
      justLoggedIn: false,
    ),
  ];

  @override
  void initState() {
    currentPage = widget.currentBottomNavPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? data = ref.watch(userModelProvider);

    bool concessionOpen = ref.watch(railwayConcessionOpenProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: data != null && !concessionOpen
          ? BottomNavigationBar(
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.white,
              items: const [
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
                BottomNavigationBarItem(
                  backgroundColor: Colors.transparent,
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
              currentIndex: widget.currentBottomNavPage,
              onTap: (index) {
                // setState(() {
                //   selectedPage = index;
                // });
                widget.changeCurrentBottomNavPage(index);
              },
            )
          : null,
      body: widgets[widget.currentBottomNavPage],
    );
  }
}
