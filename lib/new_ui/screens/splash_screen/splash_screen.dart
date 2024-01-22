import 'package:tsec_app/models/user_model/user_model.dart';

import '/../utils/image_assets.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/new_ui/screens/main_screen/main_screen.dart';
import 'package:tsec_app/new_ui/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/provider/app_state_provider.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/utils/notification_type.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Timer(const Duration(seconds: 2), () {
  //     StudentModel? studentModel = ref.read(studentModelProvider);
  //     if (ref.read(appStateProvider).isFirstOpen) {
  //       GoRouter.of(context).go('/theme');
  //     } else if (studentModel != null) {
  //       if (studentModel.updateCount == 0 || studentModel.updateCount == null) {
  //         GoRouter.of(context).go('/profile-page?justLoggedIn=true');
  //       } else {
  //         GoRouter.of(context).go('/main');
  //       }
  //     } else {
  //       debugPrint("student details not found");
  //       GoRouter.of(context).go('/main');
  //     }
  //   });
  // }

  //check permissions
  void requestPermission() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final status2 = await Permission.manageExternalStorage.status;
    if (!status2.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ref.watch(authProvider.notifier).getUserData(ref, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            UserModel? userModel = ref.read(userModelProvider);
            // if (userModel != null &&
            //     (studentModel.updateCount == 0 ||
            //         studentModel.updateCount == null)) {
            //   return ProfilePage(justLoggedIn: true);
            // } else {
            //   return MainScreen();
            // }
            if (userModel != null) {
              return ProfilePage(justLoggedIn: true);
            } else {
              return MainScreen();
            }
          } else {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  child: Image.asset(ImageAssets.tsecapplogo),
                  height: 250,
                  width: 250,
                ),
              ),
            );
          }
        });
  }
}
