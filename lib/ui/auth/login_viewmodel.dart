// lib/ui/auth/login_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { idle, loading, error }

class LoginViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  LoginViewModel({required this.authRepository});

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

  Future<void> login({required String email, required String password}) async {
    _status = AuthStatus.loading;
    _pesanError = '';
    notifyListeners();

    try {
      await authRepository.signIn(email: email, password: password);
      // AuthWrapper otomatis mendeteksi session baru via stream
    } on AuthException catch (e) {
      _pesanError = e.message;
      _status = AuthStatus.error;
    } catch (_) {
      _pesanError = 'Terjadi kesalahan. Coba lagi.';
      _status = AuthStatus.error;
    }

    notifyListeners();
  }
}
