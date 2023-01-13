import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/services/auth_service.dart';

final authProvider = Provider(((ref) {
  return AuthProvider(ref.watch(authServiceProvider), ref);
}));

final studentModelProvider = StateProvider<StudentModel?>((ref) {
  return null;
});

class AuthProvider {
  final AuthService _authService;
  final Ref _ref;
  AuthProvider(AuthService authService, Ref ref)
      : _authService = authService,
        _ref = ref;

  void signInUser(String email, String password) {
    _authService.signInUser(email, password);
  }

  void fetchStudentDetails(String email) async {
    StudentModel? studentModel = await _authService.fetchStudentDetails(email);
    log("model " + studentModel.toString());
    _ref.watch(studentModelProvider.notifier).update((state) => studentModel);
  }
}
