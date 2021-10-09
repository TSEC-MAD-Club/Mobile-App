import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tsec_app/screens/theme_screen/widgets/custom_toggle_button.dart';
import 'package:tsec_app/utils/themes.dart';

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
            'assets/images/sun.png',
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
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: <Widget>[
                Text(
                  "Skip",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const Spacer(),
                SizedBox(
                  width: 70,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {},
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            kLightModeLightBlue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
