import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/utils/notification_type.dart';

final authProvider = StateNotifierProvider<AuthProvider, bool>(((ref) {
  return AuthProvider(ref: ref, authService: ref.watch(authServiceProvider));
}));

final studentModelProvider = StateProvider<StudentModel?>((ref) {
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

  Future updateProfilePic(Uint8List image) async {
    _ref.read(profilePicProvider.notifier).state = image;
    await _authService.updateProfilePic(image);
  }

  Future fetchProfilePic() async {
    final user = _ref.read(firebaseAuthProvider).currentUser;
    String url =
        "https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/Images%2F${user?.uid}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse =
          Map<String, dynamic>.from(json.decode(response.body));
      // return jsonResponse['downloadTokens'] ?? '';
      url = "$url?alt=media&token=${jsonResponse['downloadTokens']}";
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        _ref.read(profilePicProvider.notifier).state = res.bodyBytes;
        debugPrint("download url in auth provider is $url");
        return response.bodyBytes;
      } else {
        throw Exception('Failed to fetch image');
      }
    } else {
      _ref.read(profilePicProvider.notifier).state = null;
    }
  }

  Future<StudentModel?> fetchStudentDetails(
      User? user, BuildContext context) async {
    return await _authService.fetchStudentDetails(user, context);
  }

  void changePassword(String password, BuildContext context) {
    _authService.updatePassword(password, context);
  }

  Future updateUserStateDetails(
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

  Future updateUserDetails(
      StudentModel student, WidgetRef ref, BuildContext context) async {
    try {
      StudentModel updatedStudentData =
          await _authService.updateUserDetails(student);
      _ref.read(studentModelProvider.notifier).state = updatedStudentData;

      // StudentModel? data = ref.watch(studentModelProvider);
      // if (data != null) NotificationType.makeTopic(_ref);

      StudentModel? studentmodel = ref.watch(studentModelProvider);
      NotificationType.makeTopic(ref, studentmodel);
      updateUserStateDetails(studentmodel, ref);
      // String studentYear = updatedStudentData.gradyear.toString();
      // String studentBranch = updatedStudentData.branch.toString();
      // String studentDiv = updatedStudentData.div.toString();
      // String studentBatch = updatedStudentData.batch.toString();
      // yearTopic = studentYear;
      // yearBranchTopic = "$studentYear-$studentBranch";
      // yearBranchDivTopic = "$studentYear-$studentBranch-$studentDiv";
      // yearBranchDivBatchTopic =
      //     "$studentYear-$studentBranch-$studentDiv-$studentBatch";

      // ref.read(notificationTypeProvider.notifier).state = NotificationTypeC(
      //     notification: "All",
      //     yearTopic: studentYear,
      //     yearBranchTopic: "$studentYear-$studentBranch",
      //     yearBranchDivTopic: "$studentYear-$studentBranch-$studentDiv",
      //     yearBranchDivBatchTopic:
      //         "$studentYear-$studentBranch-$studentDiv-$studentBatch");

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

  Future signout() async {
    await _authService.signout();
  }
}
