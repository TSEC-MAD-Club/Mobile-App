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

final userProvider = StateProvider<User?>((ref) {
  return ref.watch(authServiceProvider).user; 
});

class AuthProvider extends StateNotifier<bool> {
  final AuthService _authService;

  AuthProvider(AuthService authService)
      : _authService = authService,
        super(false);

  Future<UserCredential?> signInUser(
      String email, String password, BuildContext context) async {
    return await _authService.signInUser(email, password, context);
  }

  Future<StudentModel?> fetchStudentDetails(
      String email, BuildContext context) async {
    return await _authService.fetchStudentDetails(email, context);
  }

  void changePassword(String password, BuildContext context) {
    _authService.updatePassword(password, context);
  }
}
