// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/theme_provider.dart';
import '../../utils/department_enum.dart';
import '../../utils/image_assets.dart';
import '../../utils/launch_url.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_scaffold.dart';
import 'widget/custom_card.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final colorList = [Colors.red, Colors.teal, Colors.blue];
  final opacityList = const [
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
      spreadRadius: 2,
      blurRadius: 8,
      offset: const Offset(0, 1),
    );

    return CustomScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: MainScreenAppBar(sidePadding: _sidePadding),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: _sidePadding.copyWith(top: 15),
                child: Text(
                  "Departments",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 15.0,
                      ),
                      child: SizedBox(
                        height: _size.height * 0.6,
                        width: _size.width,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, value) {
                              var color = colorList[value];
                              var opacity = opacityList[value];
                              return CustomCard(
                                color,
                                opacity,
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //

  // @override
  // Widget build(BuildContext context) {

  // }
}

// class DeptWidget extends StatelessWidget {
//   const DeptWidget({
//     Key? key,
//     required this.image,
//     required this.department,
//   }) : super(key: key);

//   final String image;
//   final DepartmentEnum department;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => GoRouter.of(context).push(
//         "/department?department=${department.index}",
//       ),
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: EdgeInsets.zero,
//         color: Theme.of(context).colorScheme.secondary,
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Image.asset(
//                     "assets/images/branches/$image.png",
//                     height: 100,
//                   ),
//                 ),
//               ),
//               Text(department.name),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MainScreenAppBar extends ConsumerWidget {
  const MainScreenAppBar({
    Key? key,
    required EdgeInsets sidePadding,
  })  : _sidePadding = sidePadding,
        super(key: key);

  final EdgeInsets _sidePadding;

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
                  onTap: () => ref.read(themeProvider.notifier).switchTheme(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const IconTheme(
                      data: IconThemeData(color: kLightModeLightBlue),
                      child: Icon(Icons.dark_mode),
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
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 12),
                  color: kLightModeDarkBlue.withOpacity(.2),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Image.asset(ImageAssets.tsecImg),
          )
        ],
      ),
    );
  }
}
