import 'package:flutter/material.dart';
import 'package:tsec_app/screens/theme_screen/widgets/body.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}