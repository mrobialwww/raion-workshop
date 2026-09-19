// lib/data/repositories/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository({required this.service});

  Future<void> signIn({required String email, required String password}) async {
    return service.signIn(email: email, password: password);
  }

  Future<void> sendSignUpOtp({
    required String email,
    required String password,
  }) async {
    return service.sendSignUpOtp(email: email, password: password);
  }

  Future<AuthResponse> verifySignUpOtp({
    required String email,
    required String otpCode,
  }) async {
    return service.verifySignUpOtp(email: email, otpCode: otpCode);
  }

  Future<void> signOut() async {
    return service.signOut();
  }

  String? getCurrentUserEmail() {
    return service.getCurrentUserEmail();
  }

  String? getCurrentUserId() {
    return service.getCurrentUserId();
  }
}
