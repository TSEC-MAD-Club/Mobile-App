import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/notification_model/notification_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            body: Column(
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
                                if (_emailTextEditingController.text.trim() !=
                                    "") {
                                  try {
                                    await ref
                                        .watch(authProvider.notifier)
                                        .resetPassword(
                                            _emailTextEditingController.text
                                                .trim(),
                                            context);

                                    showSnackBar(context,
                                        'Check your inbox and click on the link in password reset email');
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      showSnackBar(context,
                                          'No user found corresponding to that email.');
                                    } else
                                      showSnackBar(
                                          context, e.message.toString());
                                    return null;
                                  }
                                } else {
                                  showSnackBar(context,
                                      'Enter the email to reset password of that account');
                                }
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
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              UserCredential? userCredential = await ref
                                  .watch(authProvider.notifier)
                                  .signInUser(
                                      _emailTextEditingController.text.trim(),
                                      _passwordTextEditingController.text
                                          .trim(),
                                      context);

                              if (userCredential == null) {
                                return;
                              }

                              User? user = userCredential.user;
                              StudentModel? studentModel = await ref
                                  .watch(authProvider.notifier)
                                  .fetchStudentDetails(user, context);
                              ref
                                  .watch(studentModelProvider.notifier)
                                  .update((state) => studentModel);
                              // showDialog(
                              //     context: context,
                              // builder: ((context) => const ChangePasswordDialog()));

                              // GoRouter.of(context).go('/main');
                              await ref
                                  .watch(authProvider.notifier)
                                  .updateUserStateDetails(studentModel, ref);

                              await ref
                                  .watch(authProvider.notifier)
                                  .fetchProfilePic();
                              debugPrint(studentModel.toString());
                              _setupFCMNotifications(studentModel);
                              if (studentModel != null) {
                                if (studentModel.updateCount != null &&
                                    studentModel.updateCount! > 0) {
                                  GoRouter.of(context).go('/main');
                                } else {
                                  GoRouter.of(context)
                                      .go('/profile-page?justLoggedIn=true');
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Set the border radius here
                            ),
                            padding:
                                EdgeInsets.all(16), // Adjust padding as needed
                          ),
                          child: Container(
                            width: double.infinity, // Set width to full width
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
                      uri: Uri.parse("mailto:devsclubtsec@gmail.com"),
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
        ));
  }

  Future<void> _setupFCMNotifications(StudentModel? studentModel) async {
    final _messaging = FirebaseMessaging.instance;
    final _permission = await _messaging.requestPermission(provisional: true);

    if ([
      AuthorizationStatus.authorized,
      AuthorizationStatus.provisional,
    ].contains(_permission.authorizationStatus)) {
      NotificationType.makeTopic(ref, studentModel);
      _messaging.subscribeToTopic(NotificationType.notification);
      _messaging.subscribeToTopic(NotificationType.yearTopic);
      _messaging.subscribeToTopic(NotificationType.yearBranchTopic);
      _messaging.subscribeToTopic(NotificationType.yearBranchDivTopic);
      _messaging.subscribeToTopic(NotificationType.yearBranchDivBatchTopic);
      _setupInteractedMessage();
      _messageOnForeground();
    }
  }

  void _messageOnForeground() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> _setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // from - if message is sent from notification topic
    if (message.from == NotificationType.notification.addTopicsPrefix) {
      ref.read(notificationProvider.state).state = NotificationProvider(
        notificationModel: NotificationModel.fromMessage(message),
        isForeground: false,
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (message.from == NotificationType.notification.addTopicsPrefix) {
      ref.read(notificationProvider.state).state = NotificationProvider(
        notificationModel: NotificationModel.fromMessage(message),
        isForeground: true,
      );
    }
  }
}
