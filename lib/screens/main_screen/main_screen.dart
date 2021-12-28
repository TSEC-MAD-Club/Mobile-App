import 'package:flutter/material.dart';
import 'package:tsec_app/provider/theme_provider.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';

import '../../utils/image_assets.dart';
import '../../utils/launch_url.dart';
import '../../utils/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context) {
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
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                childAspectRatio: 173 / 224,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: const [
                  DeptWidget(
                    image: "aids",
                    name: "AI & DS",
                  ),
                  DeptWidget(
                    image: "extc",
                    name: "Electronics & Telecomm",
                  ),
                  DeptWidget(
                    image: "cs",
                    name: "Computer Engineering",
                  ),
                  DeptWidget(
                    image: "it",
                    name: "Information Technology",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DeptWidget extends StatelessWidget {
  const DeptWidget({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                "assets/images/branches/$image.png",
              ),
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}

class MainScreenAppBar extends StatelessWidget {
  const MainScreenAppBar({
    Key? key,
    required EdgeInsets sidePadding,
  })  : _sidePadding = sidePadding,
        super(key: key);

  final EdgeInsets _sidePadding;

  @override
  Widget build(BuildContext context) {
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
                  onTap: () =>
                      context.read(themeProvider.notifier).switchTheme(),
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
