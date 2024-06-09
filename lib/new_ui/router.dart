import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/event_model/event_model.dart';
import 'package:tsec_app/new_ui/screens/login_screen/login_screen.dart';
import 'package:tsec_app/new_ui/screens/main_screen/main_screen.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/notes_screen.dart';
import 'package:tsec_app/new_ui/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/new_ui/screens/railway_screen/railway_screen.dart';
import 'package:tsec_app/new_ui/screens/splash_screen/splash_screen.dart';
import 'package:tsec_app/screens/department_screen/department_screen.dart';
import 'package:tsec_app/screens/departmentlist_screen/department_list.dart';
import 'package:tsec_app/utils/department_enum.dart';

import 'screens/event_details_screen/event_details.dart';
import 'screens/home_screen/home_screen.dart';

final routes = GoRouter(
  // urlPathStrategy: UrlPathStrategy.path,
  routes: [
  GoRoute(
  path: "/",
  builder: (context, state) => const SplashScreen(),
),
    GoRoute(
      name: "main",
      path: "/main",
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      name: "home",
      path: "/home",
      builder: (context, state) => HomeScreen(
      currentBottomNavPage: "home",
      changeCurrentBottomNavPage: () {},
      ),
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
      path: '/profile-page',
      builder: (context, state) {
      String justLoggedInSt = state.uri.queryParameters['justLoggedIn'] ??
      "false"; // may be null
      bool justLoggedIn = justLoggedInSt == "true";
      return ProfilePage(justLoggedIn: justLoggedIn);
      },
    ),

    GoRoute(
      path: "/concession",
      builder: (context, state) => const RailwayConcessionScreen(),
    ),
    GoRoute(
      path: "/notes",
      builder: (context, state) => const NotesScreen(),
    ),
// GoRoute(
//   path: "/notifications",
//   builder: (context, state) => const NotificationScreen(),
// ),
// GoRoute(
//   path: "/theme",
//   builder: (context, state) => const ThemeScreen(),
// ),
// GoRoute(
//   path: "/committee",
//   builder: (context, state) => const CommitteesScreen(),
// ),
// GoRoute(
//   path: "/tpc",
//   builder: (context, state) => const TPCScreen(),
// ),
    GoRoute(
      name: "details_page",
      path: "/details_page",
      builder: (context, state) {
      EventModel eventModel = EventModel(
      state.uri.queryParameters["Event Name"]!,
      state.uri.queryParameters["Event Time"]!,
      state.uri.queryParameters["Event Date"]!,
      state.uri.queryParameters["Event decription"]!,
      state.uri.queryParameters["Event registration url"]!,
      state.uri.queryParameters["Event Image Url"]!,
      state.uri.queryParameters["Event Location"]!,
      state.uri.queryParameters["Committee Name"]!);
      return EventDetail(
        eventModel: eventModel,
        );
      },
    ),
    GoRoute(
      path: "/department",
      builder: (context, state) {
      final department = DepartmentEnum.values[
      int.parse(state.uri.queryParameters["department"] as String)];
      return DepartmentScreen(department: department);
      },
    ),
    GoRoute(
      path: "/department-list",
      builder: (context, state) => const DepartmentListScreen(),
    )
  ]
);