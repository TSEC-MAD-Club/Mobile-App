import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/colors.dart';

import '../../../provider/auth_provider.dart';
import '../../../utils/custom_snackbar.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  String emailController = "";

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
            child: Text("Reset Password",style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold),),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Forgot your password? No worries! Simply enter your email address below. We'll send a link to reset your password. Once you receive the link, follow the instructions to create a new password.",style: TextStyle(color: Colors.white,fontSize: 15),),
          ),

          SizedBox(
            height: 20,
          ),

          Container(
            alignment: Alignment.center,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              onChanged: (val){
                setState(() {
                  emailController = val;
                });
              },
              style: TextStyle(fontSize: 17),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Email"
              ),
            ),
          ),

          Spacer(),

          InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: emailController.isNotEmpty ? ()async{
              //Form Logic
              await forgotPassword(emailController);
            } : (){
              print("Please Enter Email");
            },
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: emailController.isNotEmpty ? cardcolorblue : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text("Send Mail",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
