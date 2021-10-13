import 'dart:ui';

import 'package:flutter/material.dart';
import '../../utils/themes.dart';
import 'custom_app_bar_for_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).shadowColor,
      body: ListView(children: <Widget>[
        const CustomAppBarForLogin(
          title: "Welcome!",
          description: "Let's sign you in.",
        ),
      ]),
    );
  }
}
