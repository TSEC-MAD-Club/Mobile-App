import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/login_screen/widgets/custom_dialog_box.dart';

import '../../../utils/themes.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
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
                    controller: _emailTextEditingController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (Theme.of(context).primaryColor ==
                                  const Color(0xFFF2F5F8))
                              ? Colors.black54
                              : Colors.white38,
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                        color: (Theme.of(context).primaryColor ==
                                const Color(0xFFF2F5F8))
                            ? Colors.grey[500]
                            : Colors.white60,
                      ),
                      hintText: "Enter Your E-Mail ID",
                      fillColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Text("Password", style: Theme.of(context).textTheme.subtitle1),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: isItDarkMode
                        ? shadowLightModeTextFields
                        : shadowDarkModeTextFields,
                  ),
                  child: TextField(
                    controller: _passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (Theme.of(context).primaryColor ==
                                  const Color(0xFFF2F5F8))
                              ? Colors.black54
                              : Colors.white38,
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                        color: (Theme.of(context).primaryColor ==
                                const Color(0xFFF2F5F8))
                            ? Colors.grey[500]
                            : Colors.white60,
                      ),
                      hintText: "Enter Your Password",
                      fillColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Text(
                "Forgot Password",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Skip",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 70,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    UserCredential? userCredential = await ref
                        .watch(authProvider.notifier)
                        .signInUser(
                            _emailTextEditingController.text.trim(),
                            _passwordTextEditingController.text.trim(),
                            context);

                    if (userCredential == null) {
                      return;
                    }
                    StudentModel? studentModel = await ref
                        .watch(authProvider.notifier)
                        .fetchStudentDetails(
                            _emailTextEditingController.text.trim(), context);
                    ref
                        .watch(studentModelProvider.notifier)
                        .update((state) => studentModel);
                    showDialog(
                        context: context,
                        builder: ((context) => const ChangePasswordDialog()));
                  },
                  child: const Icon(Icons.arrow_forward),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
