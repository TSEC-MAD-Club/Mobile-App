import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/profile_screen/profile_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;
  List<Widget> widgets = <Widget>[
    HomeWidget(),
    const Text(
      'Library',
    ),
    const Text(
      'Timetable',
    ),
    const Text(
      'Railway Concession',
    ),
    ProfilePage(
      justLoggedIn: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.black,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
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
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
      body: widgets[selectedPage],
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();

    // return CustomScaffold(
    //   body: SafeArea(
    //     child: CustomScrollView(
    //       slivers: [
    //         const SliverToBoxAdapter(
    //           child: MainScreenAppBar(sidePadding: _sidePadding),
    //         ),
    //         data == null
    //             ? const DepartmentList()
    //             : SliverPadding(
    //                 padding: const EdgeInsets.all(20),
    //                 sliver: SliverToBoxAdapter(
    //                   child: Container(
    //                     width: _size.width * 0.9,
    //                     decoration: BoxDecoration(
    //                       color: _theme.primaryColor,
    //                       borderRadius: BorderRadius.circular(15.0),
    //                       border: Border.all(
    //                         color: _theme.primaryColorLight,
    //                         width: 1,
    //                         style: BorderStyle.solid,
    //                       ),
    //                       boxShadow: [_boxshadow],
    //                     ),
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(15.0),
    //                       child: DatePicker(
    //                         DateTime.now(),
    //                         monthTextStyle: _theme.textTheme.subtitle2!,
    //                         dayTextStyle: _theme.textTheme.subtitle2!,
    //                         dateTextStyle: _theme.textTheme.subtitle2!,
    //                         initialSelectedDate: DateTime.now(),
    //                         selectionColor: Colors.blue,
    //                         onDateChange: ((selectedDate) async {
    //                           ref
    //                               .read(dayProvider.notifier)
    //                               .update((state) => selectedDate);
    //                         }),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //         data != null ? const CardDisplay() : const SliverToBoxAdapter()
    //       ],
    //     ),
    //   ),
    // );
  }
}

class MainScreenAppBar extends ConsumerStatefulWidget {
  final EdgeInsets _sidePadding;
  const MainScreenAppBar({
    Key? key,
    required EdgeInsets sidePadding,
  })  : _sidePadding = sidePadding,
        super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainScreenAppBarState();
}

class _MainScreenAppBarState extends ConsumerState<MainScreenAppBar> {
  // List<EventModel> eventList = [];
  bool shouldLoop = true;

  void launchUrlcollege() async {
    var url = "https://tsec.edu/";

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url.toString());
    } else
      throw "Could not launch url";
  }

  // void fetchEventDetails() {
  //   ref.watch(eventListProvider).when(
  //       data: ((data) {
  //         eventList.addAll(data ?? []);
  //         imgList.clear();
  //         for (var data in eventList) {
  //           imgList.add(data.imageUrl);
  //         }
  //         // imgList = [imgList[0]];
  //         if (imgList.length == 1) shouldLoop = false;
  //       }),
  //       loading: () {
  //         const CircularProgressIndicator();
  //       },
  //       error: (Object error, StackTrace? stackTrace) {});
  // }

  static List<String> imgList = [];

  //static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);
  static int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    StudentModel? data = ref.watch(studentModelProvider);
    return Container();
    // fetchEventDetails();
    // return Padding(
    //   padding: widget._sidePadding.copyWith(top: 15),
    //   child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: <Widget>[
    //           Flexible(
    //             flex: 4,
    //             child: GestureDetector(
    //               onTap: () {
    //                 launchUrlcollege();
    //               },
    //               child: Text("Thadomal Shahani Engineering College",
    //                   style: Theme.of(context).textTheme.headline3),
    //             ),
    //           ),
    //           data == null
    //               ? const SizedBox()
    //               : Flexible(
    //                   flex: 1,
    //                   child: GestureDetector(
    //                     onTap: () =>
    //                         GoRouter.of(context).push("/notifications"),
    //                     child: Container(
    //                       padding: const EdgeInsets.all(5),
    //                       decoration: BoxDecoration(
    //                         color: Theme.of(context).colorScheme.secondary,
    //                         borderRadius: BorderRadius.circular(5),
    //                       ),
    //                       child: const IconTheme(
    //                         data: IconThemeData(color: kLightModeLightBlue),
    //                         child: Icon(Icons.notifications),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //         ],
    //       ),
    //       const SizedBox(height: 10),
    //       GestureDetector(
    //         onTap: () => launchUrl(
    //           "https://goo.gl/maps/5DzApsKqUQ91T5yK7",
    //           context,
    //         ),
    //         child: Row(
    //           children: <Widget>[
    //             Image.asset(
    //               ImageAssets.locationIcon,
    //               width: 20,
    //             ),
    //             Text(
    //               "Bandra, Mumbai",
    //               style: Theme.of(context)
    //                   .primaryTextTheme
    //                   .bodyText1!
    //                   .copyWith(color: kLightModeDarkBlue),
    //             ),
    //           ],
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 15,
    //       ),
    //       imgList.isEmpty
    //           ? ClipRRect(
    //               child: Image.asset(ImageAssets.tsecImg),
    //               borderRadius: BorderRadius.circular(15),
    //             )
    //           : Column(
    //               children: [
    //                 Row(
    //                   children: [
    //                     Text(
    //                       "Upcoming Events",
    //                       style: Theme.of(context).textTheme.bodyLarge,
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(
    //                   height: 15,
    //                 ),
    //                 CarouselSlider(
    //                   items: imgList
    //                       .map(
    //                         (item) => GestureDetector(
    //                             child: Padding(
    //                               padding: const EdgeInsets.symmetric(
    //                                   horizontal: 8.0),
    //                               child: Container(
    //                                 width:
    //                                     MediaQuery.of(context).size.width * 0.6,
    //                                 height:
    //                                     MediaQuery.of(context).size.width * 0.4,
    //                                 decoration: BoxDecoration(
    //                                   image: DecorationImage(
    //                                     image: CachedNetworkImageProvider(item),
    //                                     fit: BoxFit.fill,
    //                                     colorFilter: ColorFilter.mode(
    //                                       Colors.white.withOpacity(1),
    //                                       BlendMode.modulate,
    //                                     ),
    //                                   ),
    //                                   color: Colors.white,
    //                                   borderRadius: const BorderRadius.all(
    //                                     Radius.circular(20),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             onTap: () {
    //                               GoRouter.of(context).pushNamed("details_page",
    //                                   queryParameters: {
    //                                     "Event Name":
    //                                         eventList[_currentIndex].eventName,
    //                                     "Event Time":
    //                                         eventList[_currentIndex].eventTime,
    //                                     "Event Date":
    //                                         eventList[_currentIndex].eventDate,
    //                                     "Event decription":
    //                                         eventList[_currentIndex]
    //                                             .eventDescription,
    //                                     "Event registration url":
    //                                         eventList[_currentIndex]
    //                                             .eventRegistrationUrl,
    //                                     "Event Image Url": item,
    //                                     "Event Location":
    //                                         eventList[_currentIndex]
    //                                             .eventLocation,
    //                                     "Committee Name":
    //                                         eventList[_currentIndex]
    //                                             .committeeName
    //                                   });
    //                             }),
    //                       )
    //                       .toList(),
    //                   options: CarouselOptions(
    //                     autoPlay: shouldLoop,
    //                     enableInfiniteScroll: shouldLoop,
    //                     enlargeCenterPage: true,
    //                     viewportFraction: .7,
    //                     onPageChanged: (index, reason) {
    //                       setState(() {
    //                         _currentIndex = index;
    //                       });
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //       const SizedBox(
    //         height: 30,
    //       ),
    //       Row(
    //         children: [
    //           Text(
    //             data != null ? "Time Table" : "Departments ",
    //             style: Theme.of(context).textTheme.bodyLarge,
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
