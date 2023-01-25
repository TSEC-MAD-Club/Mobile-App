import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/screens/departmentlist_screen/department_list.dart';
import 'package:tsec_app/screens/main_screen/widget/card_display.dart';
import 'package:tsec_app/utils/timetable_util.dart';
import '../../models/event_model/event_model.dart';
import '../../provider/event_provider.dart';
import '../../provider/firebase_provider.dart';
import '../../utils/image_assets.dart';
import '../../utils/launch_url.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_scaffold.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const colorList = [Colors.red, Colors.teal, Colors.blue];
  static const opacityList = [
    Color.fromRGBO(255, 0, 0, 0.2),
    Color.fromARGB(51, 0, 255, 225),
    Color.fromARGB(51, 0, 153, 255),
  ];

  static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _size = MediaQuery.of(context).size;
    var _theme = Theme.of(context);
    var _boxshadow = BoxShadow(
      color: _theme.primaryColorDark,
      spreadRadius: 1,
      blurRadius: 2,
      offset: const Offset(0, 1),
    );

    return CustomScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: MainScreenAppBar(sidePadding: _sidePadding),
            ),
            ref.watch(firebaseAuthProvider).currentUser?.uid == null
                ? const DepartmentList()
                : SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        width: _size.width * 0.9,
                        decoration: BoxDecoration(
                          color: _theme.primaryColor,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: _theme.primaryColorLight,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          boxShadow: [_boxshadow],
                        ),
                        child: DatePicker(
                          DateTime.now(),
                          monthTextStyle: _theme.textTheme.subtitle2!,
                          dayTextStyle: _theme.textTheme.subtitle2!,
                          dateTextStyle: _theme.textTheme.subtitle2!,
                          initialSelectedDate: DateTime.now(),
                          selectionColor: Colors.blue,
                          onDateChange: ((selectedDate) async {
                            ref.read(dayProvider.notifier).update(
                                (state) => getweekday(selectedDate.weekday));
                          }),
                        ),
                      ),
                    ),
                  ),
            ref.watch(firebaseAuthProvider).currentUser?.uid == null
                ? const SliverToBoxAdapter()
                : const CardDisplay(),
          ],
        ),
      ),
    );
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
  List<EventModel> eventList = [];

  void fetchEventDetails() {
    ref.watch(eventListProvider).when(data: ((data) {
      eventList.addAll(data ?? []);

      log(eventList[0].toString());

      imgList.clear();
      for (var data in eventList) {
        imgList.add(data.imageUrl);
      }
    }), loading: () {
      log("loading");
    }, error: (Object error, StackTrace? stackTrace) {
      log(error.toString());
    });
  }

  static List<String> imgList = [];

  //static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);
  static int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    fetchEventDetails();
    return Padding(
      padding: widget._sidePadding.copyWith(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Text(
                  "Thadomal Shahani Engineering College",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () => GoRouter.of(context).push("/notifications"),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const IconTheme(
                      data: IconThemeData(color: kLightModeLightBlue),
                      child: Icon(Icons.notifications),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => launchUrl(
              "https://goo.gl/maps/5DzApsKqUQ91T5yK7",
              context,
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  ImageAssets.locationIcon,
                  width: 20,
                ),
                Text(
                  "Bandra, Mumbai",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyText1!
                      .copyWith(color: kLightModeDarkBlue),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                "Upcoming Events",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          CarouselSlider(
            items: imgList
                .map(
                  (item) => GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(item),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(1),
                              BlendMode.modulate,
                            ),
                          ),
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    onTap: () => GoRouter.of(context)
                        .pushNamed("details_page", queryParams: {
                      "Event Name": eventList[_currentIndex].eventName,
                      "Event Time": eventList[_currentIndex].eventTime,
                      "Event Date": eventList[_currentIndex].eventDate,
                      "Event decription":
                          eventList[_currentIndex].eventDescription,
                      "Event registration url":
                          eventList[_currentIndex].eventRegistrationUrl,
                      "Event Image Url": item,
                      "Event Location": eventList[_currentIndex].eventLocation
                    }),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: .7,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Text(
                "Time Table",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
