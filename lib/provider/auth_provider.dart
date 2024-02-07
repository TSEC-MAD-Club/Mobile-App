import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/faculty_model/faculty_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/concession_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/utils/notification_type.dart';

final authProvider = StateNotifierProvider<AuthProvider, bool>(((ref) {
  return AuthProvider(ref: ref, authService: ref.watch(authServiceProvider));
}));

// final studentModelProvider = StateProvider<StudentModel?>((ref) {
//   return null;
// });

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
    // final user = _ref.read(firebaseAuthProvider).currentUser;
    // String url =
    //     "https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/Images%2F${user?.uid}";
    // final response = await http.get(Uri.parse(url));

    // if (response.statusCode == 200) {
    //   final jsonResponse =
    //       Map<String, dynamic>.from(json.decode(response.body));
    //   // return jsonResponse['downloadTokens'] ?? '';
    //   url = "$url?alt=media&token=${jsonResponse['downloadTokens']}";
    //   final res = await http.get(Uri.parse(url));
    //   if (res.statusCode == 200) {
    //     _ref.read(profilePicProvider.notifier).state = res.bodyBytes;
    //     // debugPrint("download url in auth provider is $url");
    //     return response.bodyBytes;
    //   } else {
    //     throw Exception('Failed to fetch image');
    //   }
    // } else {
    //   _ref.read(profilePicProvider.notifier).state = null;
    // }
    UserModel? userModel = _ref.watch(userModelProvider);
    if (userModel == null) {
      return;
    }
    String url = userModel.isStudent
        ? userModel.studentModel!.image ?? ""
        : userModel.facultyModel!.image;
        debugPrint("url is $url");
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
    return await _authService.fetchUserDetails(user, context);
  }

  void changePassword(String password, BuildContext context) {
    _authService.updatePassword(password, context);
  }

  Future getUserData(WidgetRef ref, BuildContext context) async {
    final user = _ref.watch(firebaseAuthProvider).currentUser;
    if (user?.uid != null) {
      UserModel? userModel = await ref
          .watch(authProvider.notifier)
          .fetchUserDetails(user, context);
      // ref.read(studentModelProvider.notifier).state = studentModel;
      ref.read(userModelProvider.notifier).state = userModel;

      if (userModel != null && userModel.isStudent) {
        NotificationType.makeTopic(ref, userModel.studentModel);
        await ref
            .watch(authProvider.notifier)
            .updateStudentTimeTableData(userModel.studentModel, ref);
      }

      await ref.watch(authProvider.notifier).fetchProfilePic();
      await ref.watch(concessionProvider.notifier).getConcessionData();
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
      print('Error updating profile: $e');
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
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
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
