import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                  daysCount: 7,
                  onDateChange: ((selectedDate) {
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
    'https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/events%2FWhatsApp%20Image%202022-12-13%20at%2019.16.12.jpeg?alt=media&token=fcb02f10-a68f-4a59-aa13-11e3b99134c2',
    'https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/events%2FWhatsApp%20Image%202022-12-14%20at%205.12.48%20PM.jpeg?alt=media&token=1a8c0a8a-3a00-4619-91db-927a37c830f7',
    'https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/events%2FWhatsApp%20Image%202023-01-02%20at%207.11.19%20PM.jpeg?alt=media&token=48bddc2e-7fff-4f1d-a36d-f1d1de098c97'
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
                    onTap: () => GoRouter.of(context).push("/details_page"),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: .7,
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
