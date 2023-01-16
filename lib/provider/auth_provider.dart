import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthProvider, bool>(((ref) {
  return AuthProvider(ref.watch(authServiceProvider));
}));

final studentModelProvider = StateProvider<StudentModel?>((ref) {
  return null;
});

final signedUserProvider = StateProvider<User?>((ref) {
  return null;
});

class AuthProvider extends StateNotifier<bool> {
  final AuthService _authService;

  AuthProvider(AuthService authService)
      : _authService = authService,
        super(false);

  void signInUser(String email, String password, BuildContext context) {
    _authService.signInUser(email, password, context);
  }

  Future<User?> getUser() async {
    state = false;
    User? user = await _authService.userCurrentState.first;
    state = true;
    return user;
  }

  Future<StudentModel?> fetchStudentDetails(
      String email, BuildContext context) async {
    return await _authService.fetchStudentDetails(email, context);
  }

  void changePassword(String password, BuildContext context) {
    _authService.updatePassword(password, context);
  }
}
