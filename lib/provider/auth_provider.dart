import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/services/auth_service.dart';

final authProvider = Provider(((ref) {
  return AuthProvider(ref.watch(authServiceProvider));
}));

class AuthProvider {
  final AuthService _authService;
  AuthProvider(AuthService authService) : _authService = authService;

  void signInUser(String email, String password) {
    _authService.signInUser(email, password);
  }
}
