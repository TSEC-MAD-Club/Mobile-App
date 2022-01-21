import 'package:flutter/material.dart';

import 'widgets/custom_app_bar_for_login.dart';
import 'widgets/custom_login_widget.dart';
import 'widgets/skip_and_next_row.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: ListView(
            children: const <Widget>[
              CustomAppBarForLogin(
                title: "Welcome!",
                description: "Let's sign you in.",
              ),
              LoginWidget(),
              SkipAndNextRow(),
            ],
          ),
        ));
  }
}
