import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/notification_model/notification_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/login_screen/ResetPasswordScreen.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/provider/notification_provider.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:tsec_app/utils/form_validity.dart';
import 'package:tsec_app/utils/notification_type.dart';
import 'package:url_launcher/link.dart';

// import 'widgets/custom_app_bar_for_login.dart';
// import 'widgets/custom_login_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;
  bool passwordVisible = true;
  bool loggedInButtonPressed = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }



  Future login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loggedInButtonPressed = true;
      });
      print("print1");
      UserCredential? userCredential = await ref
          .watch(authProvider.notifier)
          .signInUser(_emailTextEditingController.text.trim(),
              _passwordTextEditingController.text.trim(), context);
      print("print2");
      if (userCredential == null) {
        setState(() {
          loggedInButtonPressed = false;
        });
        return;
      }
      print("print3");

      await ref.watch(authProvider.notifier).getUserData(ref, context);
      print("print4");
      UserModel? userModel = ref.watch(userModelProvider);
      print("print5");
      print("print6");

      if (userModel != null) {
        print("print6");
        ref.watch(authProvider.notifier).setupFCMNotifications(ref,
            userModel.studentModel, FirebaseAuth.instance.currentUser!.uid);

        // if (studentModel.updateCount != null &&
        //     studentModel.updateCount! > 0) {
        //   GoRouter.of(context).go('/main');
        // } else {
        //   GoRouter.of(context).go(
        //       '/profile-page?justLoggedIn=true');
        // }

        GoRouter.of(context).go('/profile-page?justLoggedIn=true');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            GoRouter.of(context).go('/main');
                          },
                          child: Text(
                            "Skip",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  Text(
                    "Welcome",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Lets sign you in",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  // CustomAppBarForLogin(
                  //   title: "Welcome!",
                  //   description: "Let's sign you in.",
                  // ),
                  // LoginWidget(),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 30, left: 30, right: 30),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              // boxShadow: isItDarkMode
                              //     ? shadowLightModeTextFields
                              //     : shadowDarkModeTextFields,
                            ),
                            child: TextFormField(
                              controller: _emailTextEditingController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (!isValidEmail(value)) {
                                  return 'Please enter a Valid Email';
                                }
                                return null;
                              },
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff353F5A),
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
                                  color: Color(0xff6B708C),
                                ),
                                hintText: "Email",
                                fillColor: Color(0xff191B22),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 30, left: 30, right: 30),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              // boxShadow: isItDarkMode
                              //     ? shadowLightModeTextFields
                              //     : shadowDarkModeTextFields,
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              controller: _passwordTextEditingController,
                              obscureText: passwordVisible,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                              decoration: InputDecoration(
                                suffixIconColor:
                                    Theme.of(context).colorScheme.onTertiary,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                    debugPrint(passwordVisible.toString());
                                  },
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onTertiary,
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
                                  color: Theme.of(context).colorScheme.onTertiary,
                                ),
                                hintText: "Password",
                                fillColor: Color(0xff191B22),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: InkResponse(
                                borderRadius: BorderRadius.circular(
                                    30), // Set the desired border radius
                                onTap: () async {
                                  //forgotPassword();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPasswordScreen(),),);
                                },
                                highlightShape:
                                    BoxShape.rectangle, // Custom shape
              
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the desired border radius
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Reset Password',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        !loggedInButtonPressed
                            ? Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    login();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Set the border radius here
                                    ),
                                    padding: EdgeInsets.all(
                                        16), // Adjust padding as needed
                                  ),
                                  child: Container(
                                    width: double
                                        .infinity, // Set width to full width
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        'Log In',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: CircularProgressIndicator(),
                              ),
                      ],
                    ),
                  ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Need help signing in?  ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme!.onSecondary,
                        ),
                      ),
                      Link(
                        uri: Uri.parse("mailto:devsclubtsec@gmail.com?subject=Request%20for%20Login%20Credentials&body=Dear%20Team,%0D%0A%0D%0AI%20want%20to%20request%20for%20TSEC%20App%20login%20Credentials.%0D%0A%0D%0AMy%20Details%20are:%0D%0AFull%20Name%20(Surname_First_Lastname):%0D%0AEmail:%0D%0APhone%20Number:%0D%0AGraduation%20Year:%0D%0ABranch:%0D%0ADiv%20(C2):%0D%0ABatch%20(C21):%0D%0A%0D%0AThank%20You."),
                        builder: (context, followLink) => GestureDetector(
                          onTap: () => followLink?.call(),
                          child: Text(
                            "Contact Us",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
