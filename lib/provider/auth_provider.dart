import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/faculty_model/faculty_model.dart';
import 'package:tsec_app/models/notification_model/notification_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/provider/notes_provider.dart';
import 'package:tsec_app/provider/notification_provider.dart';
import 'package:tsec_app/provider/subjects_provider.dart';
import 'package:tsec_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/utils/notification_type.dart';

final authProvider = StateNotifierProvider<AuthProvider, bool>(((ref) {
  return AuthProvider(ref: ref, authService: ref.watch(authServiceProvider));
}));

final userModelProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final profilePicProvider = StateProvider<Uint8List?>((ref) {
  return null;
});

final userProvider = StateProvider<User?>((ref) {
  return ref.watch(authServiceProvider).user;
});

class AuthProvider extends StateNotifier<bool> {
  final AuthService _authService;

  final Ref _ref;

  AuthProvider({authService, ref})
      : _authService = authService,
        _ref = ref,
        super(false);

  Future<UserCredential?> signInUser(
      String email, String password, BuildContext context) async {
    return await _authService.signInUser(email, password, context);
  }

  Future resetPassword(String email, BuildContext context) async {
    return await _authService.resetPassword(email, context);
  }

  Future<String> updateProfilePic(Uint8List image, UserModel userModel) async {
    _ref.read(profilePicProvider.notifier).state = image;
    String url = await _authService.updateProfilePic(image, userModel);
    return url;
  }

  Future fetchProfilePic() async {
    UserModel? userModel = _ref.watch(userModelProvider);
    if (userModel == null) {
      return;
    }
    String url = userModel.isStudent
        ? userModel.studentModel!.image ?? ""
        : userModel.facultyModel!.image;
    // debugPrint("url is $url");
    if (url != "") {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _ref.read(profilePicProvider.notifier).state = response.bodyBytes;
        return response.bodyBytes;
      } else {
        throw Exception('Failed to fetch image');
      }
    }
  }

  Future fetchSubjects() async {
    UserModel? userModel = _ref.watch(userModelProvider);
    if (userModel == null) {
      return;
    }
    String url = userModel.isStudent
        ? userModel.studentModel!.image ?? ""
        : userModel.facultyModel!.image;
    // debugPrint("url is $url");
    if (url != "") {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _ref.read(profilePicProvider.notifier).state = response.bodyBytes;
        return response.bodyBytes;
      } else {
        throw Exception('Failed to fetch image');
      }
    }
  }

  Future<UserModel?> fetchUserDetails(User? user, BuildContext context) async {
    //this fetches the core data pertaining to the student or professor
    return await _authService.fetchUserDetails(user, context);
  }

  void changePassword(String password, BuildContext context) {
    _authService.updatePassword(password, context);
  }

  Future getUserData(WidgetRef ref, BuildContext context) async {
    //this is being called on both splash and login screen
    final user = _ref.watch(firebaseAuthProvider).currentUser;
    if (user?.uid != null) {
      UserModel? userModel = await ref
          .watch(authProvider.notifier)
          .fetchUserDetails(user, context);
      ref.read(userModelProvider.notifier).state = userModel;
      if (userModel != null && userModel.isStudent) {
        NotificationType.makeTopic(ref, userModel.studentModel);
        await ref
            .watch(authProvider.notifier)
            .updateStudentTimeTableData(userModel.studentModel, ref);
        await ref.watch(concessionProvider.notifier).getConcessionData();
        await ref
            .watch(subjectsProvider.notifier)
            .fetchSubjects(userModel.studentModel!);
      }
      await ref.watch(authProvider.notifier).fetchProfilePic();
      await ref.read(notesProvider.notifier).fetchNotes(userModel);

      // if (studentModel != null) {
      //   debugPrint("in main");
      //   String studentYear = studentModel.gradyear.toString();
      //   String studentBranch = studentModel.branch.toString();
      //   String studentDiv = studentModel.div.toString();
      //   String studentBatch = studentModel.batch.toString();
      //   ref.read(notificationTypeProvider.notifier).state = NotificationTypeC(
      //       notification: "All",
      //       yearTopic: studentYear,
      //       yearBranchTopic: "$studentYear-$studentBranch",
      //       yearBranchDivTopic: "$studentYear-$studentBranch-$studentDiv",
      //       yearBranchDivBatchTopic:
      //           "$studentYear-$studentBranch-$studentDiv-$studentBatch");
      // }
    }
  }

  Future updateStudentTimeTableData(
      StudentModel? studentmodel, WidgetRef ref) async {
    if (studentmodel != null) {
      String studentYear = studentmodel.gradyear.toString();
      String studentBranch = studentmodel.branch.toString();
      String studentDiv = studentmodel.div.toString();
      String studentBatch = studentmodel.batch.toString();

      ref.read(notificationTypeProvider.notifier).state = NotificationTypeC(
          notification: "All",
          yearTopic: studentYear,
          yearBranchTopic: "$studentYear-$studentBranch",
          yearBranchDivTopic: "$studentYear-$studentBranch-$studentDiv",
          yearBranchDivBatchTopic:
              "$studentYear-$studentBranch-$studentDiv-$studentBatch");
    }
  }

  Future updateStudentDetails(
      StudentModel student, WidgetRef ref, BuildContext context) async {
    try {
      StudentModel updatedStudentData =
          await _authService.updateStudentDetails(student);
      _ref.read(userModelProvider.notifier).state =
          UserModel(isStudent: true, studentModel: updatedStudentData);

      StudentModel? studentmodel = ref.watch(userModelProvider)?.studentModel;
      NotificationType.makeTopic(ref, studentmodel);
      updateStudentTimeTableData(studentmodel, ref);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(studentmodel?.updateCount! == 1
                ? 'Profile updated successfully. You are only allowed to update it once again '
                : "Profile updated successfully. You have already updated it as many times as possible ")),
      );
    } catch (e) {
      print('Error updating student details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  Future updateFacultyDetails(
      FacultyModel faculty, WidgetRef ref, BuildContext context) async {
    try {
      FacultyModel updatedFacultyData =
          await _authService.updateFacultyDetails(faculty);
      _ref.read(userModelProvider.notifier).state =
          UserModel(isStudent: false, facultyModel: updatedFacultyData);
    } catch (e) {
      print('Error updating faculty details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  Future<void> setupFCMNotifications(
      WidgetRef ref, StudentModel? studentModel, String uid) async {
    final _messaging = FirebaseMessaging.instance;
    final _permission = await _messaging.requestPermission(provisional: true);

    if ([
      AuthorizationStatus.authorized,
      AuthorizationStatus.provisional,
    ].contains(_permission.authorizationStatus)) {
      NotificationType.makeTopic(ref, studentModel);
      _messaging.subscribeToTopic(uid);
      _messaging.subscribeToTopic(NotificationType.notification);
      _messaging.subscribeToTopic(NotificationType.yearTopic);
      _messaging.subscribeToTopic(NotificationType.yearBranchTopic);
      _messaging.subscribeToTopic(NotificationType.yearBranchDivTopic);
      _messaging.subscribeToTopic(NotificationType.yearBranchDivBatchTopic);
      _setupInteractedMessage(ref);
      _messageOnForeground(ref);
    }
  }

  void _messageOnForeground(WidgetRef ref) {
    FirebaseMessaging.onMessage.listen((event) {
      _handleForegroundMessage(ref, event);
    });
  }

  Future<void> _setupInteractedMessage(WidgetRef ref) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(ref, initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _handleForegroundMessage(ref, event);
    });
  }

  void _handleMessage(WidgetRef ref, RemoteMessage message) {
    // from - if message is sent from notification topic
    if (message.from == NotificationType.notification.addTopicsPrefix) {
      ref.read(notificationProvider.state).state = NotificationProvider(
        notificationModel: NotificationModel.fromMessage(message),
        isForeground: false,
      );
    }
  }

  void _handleForegroundMessage(WidgetRef ref, RemoteMessage message) {
    if (message.from == NotificationType.notification.addTopicsPrefix) {
      ref.read(notificationProvider.state).state = NotificationProvider(
        notificationModel: NotificationModel.fromMessage(message),
        isForeground: true,
      );
    }
  }

  Future signout() async {
    final _messaging = FirebaseMessaging.instance;

    _ref.read(userModelProvider.notifier).update((state) => null);
    _ref.read(profilePicProvider.notifier).update((state) => null);

    _messaging.unsubscribeFromTopic(NotificationType.notification);
    _messaging.unsubscribeFromTopic(NotificationType.yearBranchDivBatchTopic);
    _messaging.unsubscribeFromTopic(NotificationType.yearBranchDivTopic);
    _messaging.unsubscribeFromTopic(NotificationType.yearBranchTopic);
    _messaging.unsubscribeFromTopic(NotificationType.yearTopic);
    await _authService.signout();
  }
}
