import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/utils/form_validity.dart';

import '../../../provider/auth_provider.dart';
import '../../../utils/custom_snackbar.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  String emailController = "";

  final TextEditingController _emailTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Reset Password",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                "Forgot your password? No worries! \nSimply enter your email address below. We'll send a link to reset your password. Once you receive the link, follow the instructions to create a new password.",
                style: Theme.of(context).textTheme.bodySmall),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    emailController = val;
                  });
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
          Spacer(),
          InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: emailController.isNotEmpty
                ? () async {
                    //Form Logic
                    await forgotPassword(emailController);
                  }
                : () {
                    print("Please Enter Email");
                  },
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: emailController.isNotEmpty
                    // ? Color(0xff353F5A)
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text("Send Mail",
                  // style:
                  //     TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.black)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future forgotPassword(String email) async {
    if (email.trim() != "") {
      try {
        await ref
            .watch(authProvider.notifier)
            .resetPassword(email.trim(), context);

        showSnackBar(context,
            'Check your inbox and click on the link in password reset email');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackBar(context, 'No user found corresponding to that email.');
        } else
          showSnackBar(context, e.message.toString());
        return null;
      }
    } else {
      showSnackBar(
          context, 'Enter the email to reset password of that account');
    }
  }
}
