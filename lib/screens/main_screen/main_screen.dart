import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/screens/main_screen/widget/schedule_card.dart';
import '../../utils/image_assets.dart';
import '../../utils/launch_url.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_scaffold.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const colorList = [Colors.red, Colors.teal, Colors.blue];
  static const opacityList = [
    Color.fromRGBO(255, 0, 0, 0.2),
    Color.fromARGB(51, 0, 255, 225),
    Color.fromARGB(51, 0, 153, 255),
  ];
  static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);
  @override
  Widget build(BuildContext context) {
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
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 2.0,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 3,
                  (context, index) {
                    var color = colorList[index];
                    var opacity = opacityList[index];
                    return ScheduleCard(
                      color,
                      opacity,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png',
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png',
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png',
    'https://assets.devfolio.co/hackathons/d2e152245d8146898efc542304ef6653/assets/cover/694.png'
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
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                          )),
                      onTap: () => GoRouter.of(context).push("/details_page")),
                )
                .toList(),
            options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                viewportFraction: 1),
          ),
        ],
      ),
    );
  }
}
