import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/utils/notification_type.dart';

final authProvider = StateNotifierProvider<AuthProvider, bool>(((ref) {
  return AuthProvider(ref: ref, authService: ref.watch(authServiceProvider));
}));

final studentModelProvider = StateProvider<StudentModel?>((ref) {
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

  Future<StudentModel?> fetchStudentDetails(
      User? user, BuildContext context) async {
    return await _authService.fetchStudentDetails(user, context);
  }

  void changePassword(String password, BuildContext context) {
    _authService.updatePassword(password, context);
  }

  void updateUserDetails(
      StudentModel student, WidgetRef ref, BuildContext context) async {
    try {
      StudentModel updatedStudentData =
          await _authService.updateUserDetails(student);
      _ref.read(studentModelProvider.notifier).state = updatedStudentData;

      // StudentModel? data = ref.watch(studentModelProvider);
      // if (data != null) NotificationType.makeTopic(_ref);

      StudentModel? studentmodel = ref.watch(studentModelProvider);
      NotificationType.makeTopic(ref, studentmodel);
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

  void signout() {
    _authService.signout();
  }
}
