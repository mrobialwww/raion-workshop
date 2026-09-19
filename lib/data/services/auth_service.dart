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
      await _client.auth.signUp(email: email, password: password);

      debugPrint('Kode OTP verifikasi pendaftaran berhasil dikirim ke: $email');
    } on AuthException catch (e) {
      // Menangkap error jika email sudah terdaftar atau format salah
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
      final response = await _client.auth.verifyOTP(
        email: email,
        token: otpCode.trim(),
        type: OtpType.email,
      );

      debugPrint('Verifikasi berhasil! User ID: ${response.user?.id}');
      return response;
    } on AuthException catch (e) {
      debugPrint('Kode OTP salah atau kadaluarsa: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Gagal memverifikasi OTP: $e');
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
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
