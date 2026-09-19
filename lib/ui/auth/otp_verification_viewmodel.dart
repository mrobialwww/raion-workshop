// lib/ui/auth/otp_verification_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_viewmodel.dart' show AuthStatus;

class OtpVerificationViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final String email;
  final String password;

  OtpVerificationViewModel({
    required this.authRepository,
    required this.email,
    required this.password,
  });

  AuthStatus _status = AuthStatus.idle;
  String _pesanError = '';

  AuthStatus get status => _status;
  String get pesanError => _pesanError;

  /// Verifikasi kode OTP 6 digit yang dimasukkan pengguna
  Future<bool> verifyOtp(String otpCode) async {
    _status = AuthStatus.loading;
    _pesanError = '';
    notifyListeners();

    try {
      await authRepository.verifySignUpOtp(email: email, otpCode: otpCode);
      _status = AuthStatus.idle;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _pesanError = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (_) {
      _pesanError = 'Terjadi kesalahan. Coba lagi.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Kirim ulang kode OTP ke email yang sama
  Future<void> resendOtp() async {
    _status = AuthStatus.loading;
    _pesanError = '';
    notifyListeners();

    try {
      await authRepository.sendSignUpOtp(email: email, password: password);
      _status = AuthStatus.idle;
      notifyListeners();
    } on AuthException catch (e) {
      _pesanError = e.message;
      _status = AuthStatus.error;
      notifyListeners();
    } catch (_) {
      _pesanError = 'Gagal mengirim ulang kode.';
      _status = AuthStatus.error;
      notifyListeners();
    }
  }
}
