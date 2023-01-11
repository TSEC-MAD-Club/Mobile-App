import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/screens/main_screen/widget/card_display.dart';
import 'package:tsec_app/utils/timetable_util.dart';
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
          SliverPadding(
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
                    // final date = selectedDate.day.toString() +"/" +
                    //     selectedDate.month.toString() + "/" +
                    //     selectedDate.year.toString();
                    // log(date.toString()); 
                    // final db = ref.watch(firestoreProvider);
                    // final data = await db
                    //     .collection("Holidays")
                    //     .where("date", isEqualTo: date)
                    //     .get().then((value) => print(value.docs
                    //     .map((e) => e.data()['Day'])));
                    
                    ref
                        .read(dayProvider.notifier)
                        .update((state) => getweekday(selectedDate.weekday));
                  }),
                ),
              ),
            ),
          ),
          const CardDisplay()
        ],
      )),
    );
  }
}

class MainScreenAppBar extends ConsumerWidget {
  const MainScreenAppBar({
    Key? key,
    required EdgeInsets sidePadding,
  })  : _sidePadding = sidePadding,
        super(key: key);

  final EdgeInsets _sidePadding;
  static const List<String> imgList = [
    'https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/events%2FWhatsApp%20Image%202022-12-13%20at%2019.16.12.jpeg?alt=media&token=fcb02f10-a68f-4a59-aa13-11e3b99134c2',
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png',
    'https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/events%2FWhatsApp%20Image%202022-12-13%20at%2019.16.12.jpeg?alt=media&token=fcb02f10-a68f-4a59-aa13-11e3b99134c2',
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png',
    'https://tsec-hacks-2023.devfolio.co/_next/image?url=https%3A%2F%2Fassets.devfolio.co%2Fhackathons%2F93fcebe58ecd49a597963853eb7deb66%2Fassets%2Fcover%2F129.png&w=1440&q=100'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: _sidePadding.copyWith(top: 15),
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
            height: 5,
          ),
          CarouselSlider(
            items: imgList
                .map(
                  (item) => GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(item),
                          fit: BoxFit.cover,
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
                    onTap: () => GoRouter.of(context).push("/details_page"),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2,
              enlargeCenterPage: true,
              viewportFraction: 1,
            ),
          ),
        ],
      ),
    );
  }
}
