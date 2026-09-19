// lib/ui/auth/login_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_viewmodel.dart';
import 'register_view.dart';
import 'register_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    final viewModel = context.watch<LoginViewModel>();
    final isLoading = viewModel.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Wisatain — Login')),
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
                        : () => viewModel.login(
                          email: _emailCtrl.text.trim(),
                          password: _passwordCtrl.text,
                        ),
                child:
                    isLoading
                        ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Login'),
              ),
            ),
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => ChangeNotifierProvider(
                          create:
                              (_) => RegisterViewModel(
                                authRepository: context.read<AuthRepository>(),
                              ),
                          child: const RegisterView(),
                        ),
                  ),
                );

                // Bersihkan isian setelah pop dari halaman register
                if (!context.mounted) return;
                _emailCtrl.clear();
                _passwordCtrl.clear();
              },
              child: const Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
