import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/theme_provider.dart';
import '../../utils/image_assets.dart';
import 'widgets/custom_toggle_button.dart';
import 'widgets/skip_and_next_row.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);
  Widget content(double _height, double _width, BuildContext context) {
    return Column(
      children: <Widget>[
        Consumer(builder: (context, ref, child) {
          final themeMode = ref.watch(themeProvider);
          return Image.asset(
            themeMode == ThemeMode.dark ? ImageAssets.moon : ImageAssets.sun,
            height: 0.25 * _height,
            width: 0.54 * _width,
          );
        }),
        const SizedBox(height: 40),
        Text(
          "Choose a style",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 15),
        Text(
          "Pop or subtle. Day or night. \n Customize your interface.",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(height: 0.05 * _height),
        Consumer(
          builder: (context, ref, child) => CustomToggleButton(
            values: const ['Light', 'Dark'],
            onToggleCallback: () {
              ref.read(themeProvider.notifier).switchTheme();
            },
          ),
        ),
        (_height > _width)
            ? const Spacer()
            : const SizedBox(
                height: 50,
              ),
        //const Spacer(),
        const SkipAndNextRow(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: (height > width)
              ? content(height, width, context)
              : SingleChildScrollView(
                  child: content(height, width, context),
                ),
        ),
      ),
    );
  }
}
