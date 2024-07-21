import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:async/async.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/new_ui/screens/main_screen/main_screen.dart';
import 'package:tsec_app/new_ui/screens/profile_screen/profile_screen.dart';
import 'package:tsec_app/new_ui/screens/launch_screen/launch_screen.dart';
import 'package:tsec_app/provider/app_state_provider.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import '/../utils/image_assets.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/utils/notification_type.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  DateTime? _launchDate;
  bool _isLaunchDateFetched = false;

  fetchUserDataOnce() {
    return _memoizer.runOnce(() async {
      await ref.read(authProvider.notifier).getUserData(ref, context);
      return 'REMOTE DATA';
    });
  }

  Future<void> _fetchLaunchDate() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('Launch')
          .doc('launch')
          .get();
      Timestamp? timestamp = snapshot.data()?['date'] as Timestamp?;
      setState(() {
        _launchDate = timestamp?.toDate();
        _isLaunchDateFetched = true;
      });
    } catch (e) {
      print('Error fetching launch date: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLaunchDate();
  }

  //check permissions
  void requestpermission() async {
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
    if (!_isLaunchDateFetched) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_launchDate != null && DateTime.now().isBefore(_launchDate!)) {
      return LaunchScreen();
    }

    return FutureBuilder(
        future: fetchUserDataOnce(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            UserModel? userModel = ref.read(userModelProvider);
            if (userModel != null &&
                userModel.isStudent &&
                (userModel.studentModel?.updateCount == 0 ||
                    userModel.studentModel?.updateCount == null)) {
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
