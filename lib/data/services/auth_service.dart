// lib/data/services/auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  /// Mengirim kode OTP pendaftaran ke email target
  Future<void> sendSignUpOtp({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Gunakan _client.auth.signUp() untuk mendaftarkan user
    } on AuthException catch (e) {
      debugPrint('Gagal pendaftaran: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Terjadi kesalahan tak terduga: $e');
      rethrow;
    }
  }

  /// Memverifikasi kode OTP yang dimasukkan pengguna
  Future<AuthResponse> verifySignUpOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      // TODO: Gunakan _client.auth.verifyOTP() dengan OtpType.email
      throw UnimplementedError();
    } on AuthException catch (e) {
      debugPrint('Kode OTP salah atau kadaluarsa: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Gagal memverifikasi OTP: $e');
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    // TODO: Gunakan _client.auth.signInWithPassword()
  }

  Future<void> signOut() async {
    // TODO: Gunakan _client.auth.signOut()
  }

  // Ambil data user yg sedang login
  String? getCurrentUserEmail() {
    final session = _client.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // Ambil id user yg sedang login
  String? getCurrentUserId() {
    final session = _client.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }
}
