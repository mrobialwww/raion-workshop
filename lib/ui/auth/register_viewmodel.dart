// lib/ui/auth/register_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_viewmodel.dart' show AuthStatus;

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  RegisterViewModel({required this.authRepository});

  AuthStatus _status = AuthStatus.idle;
  String _pesanError = '';
  bool _obscurePassword = true;

  AuthStatus get status => _status;
  String get pesanError => _pesanError;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Mengirim OTP ke email. Mengembalikan true jika berhasil, false jika gagal.
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _pesanError = '';
    notifyListeners();

    try {
      // Kirim OTP verifikasi ke email (password disertakan sesuai panduan)
      await authRepository.sendSignUpOtp(email: email, password: password);
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
}
