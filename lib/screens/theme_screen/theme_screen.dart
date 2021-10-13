import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/theme_provider.dart';

import 'widgets/custom_toggle_button.dart';
import 'widgets/skip_and_next_row.dart';
import '../../utils/image_assets.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            Consumer(builder: (context, watch, child) {
              final themeMode = watch(themeProvider);
              return Image.asset(
                themeMode == ThemeMode.dark
                    ? ImageAssets.moon
                    : ImageAssets.sun,
                height: 0.25 * size.height,
                width: 0.54 * size.width,
              );
            }),
            const SizedBox(height: 40),
            Text(
              "Choose a style",
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 15),
            Text(
              "Pop or subtle. Day or night. \n Customize your interface.",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 0.05 * size.height),
            CustomToggleButton(
              values: const ['Light', 'Dark'],
              onToggleCallback: (index) {
                context.read(themeProvider.notifier).switchTheme();
              },
            ),
            const Spacer(),
            const SkipAndNextRow(),
          ],
        ),
      ),
    );
  }
}
