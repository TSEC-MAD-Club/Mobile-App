import 'package:flutter/material.dart';
import 'package:tsec_app/provider/theme_provider.dart';
import 'package:tsec_app/utils/themes.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isItDarkMode = brightness == Brightness.dark;
    return Wrap(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Email", style: Theme.of(context).textTheme.subtitle1),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: isItDarkMode
                              ? shadowLightModeTextFields
                              : shadowDarkModeTextFields),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Enter Your E-Mail ID",
                            fillColor: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Text("Password",
                      style: Theme.of(context).textTheme.subtitle1),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: isItDarkMode
                              ? shadowLightModeTextFields
                              : shadowDarkModeTextFields),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Enter Your Password",
                            fillColor: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ])),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Text("Forgot Password",
                    style: TextStyle(color: Colors.blue)),
              ),
            ])
      ],
    );
  }
}
