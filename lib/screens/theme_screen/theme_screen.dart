import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/theme_provider.dart';
import '../../utils/image_assets.dart';
import '../../widgets/custom_scaffold.dart';
import 'widgets/custom_toggle_button.dart';
import 'widgets/skip_and_next_row.dart';

class ThemeScreen extends ConsumerStatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends ConsumerState<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            Consumer(builder: (context, ref, child) {
              final themeMode = ref.watch(themeProvider);
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
                ref.read(themeProvider.notifier).switchTheme();
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
