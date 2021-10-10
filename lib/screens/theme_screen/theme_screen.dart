import 'package:flutter/material.dart';

import 'widgets/custom_toggle_button.dart';
import 'widgets/skip_and_next_row.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          Image.asset(
            'assets/images/themes/sun.png',
            height: 0.25 * size.height,
            width: 0.54 * size.width,
          ),
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
              isDarkMode = !isDarkMode;
              setState(() {});
            },
          ),
          const Spacer(),
          const SkipAndNextRow(),
        ],
      ),
    );
  }
}
