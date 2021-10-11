import 'package:flutter/material.dart';

import '../utils/image_assets.dart';
import '../utils/launch_url.dart';
import '../utils/themes.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
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
                            onTap: () {},
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
