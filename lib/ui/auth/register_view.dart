// lib/ui/auth/register_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_viewmodel.dart' show AuthStatus;
import 'otp_verification_view.dart';
import 'otp_verification_viewmodel.dart';
import 'register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();
    final isLoading = viewModel.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Wisatain — Register')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordCtrl,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    viewModel.obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => viewModel.togglePasswordVisibility(),
                ),
              ),
              obscureText: viewModel.obscurePassword,
            ),
            const SizedBox(height: 16),
            if (viewModel.status == AuthStatus.error)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  viewModel.pesanError,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          final email = _emailCtrl.text.trim();
                          final password = _passwordCtrl.text;

                          final berhasil = await viewModel.register(
                            email: email,
                            password: password,
                          );

                          if (berhasil && context.mounted) {
                            // Navigasi ke halaman OTP dengan membawa email
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => ChangeNotifierProvider(
                                      create:
                                          (ctx) => OtpVerificationViewModel(
                                            authRepository:
                                                ctx.read<AuthRepository>(),
                                            email: email,
                                            password: password,
                                          ),
                                      child: const OtpVerificationView(),
                                    ),
                              ),
                            );
                          }
                        },
                child:
                    isLoading
                        ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Daftar & Kirim Kode OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
