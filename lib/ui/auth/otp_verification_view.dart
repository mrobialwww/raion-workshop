// lib/ui/auth/otp_verification_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_viewmodel.dart' show AuthStatus;
import 'otp_verification_viewmodel.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final _otpCtrl = TextEditingController();

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OtpVerificationViewModel>();
    final isLoading = viewModel.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi Email')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Masukkan kode 8 digit yang dikirim ke:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              viewModel.email,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _otpCtrl,
              decoration: const InputDecoration(
                labelText: 'Kode OTP',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              keyboardType: TextInputType.number,
              maxLength: 8,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                letterSpacing: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (viewModel.status == AuthStatus.error)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  viewModel.pesanError,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            // Tombol utama: Verifikasi OTP
            FilledButton(
              onPressed:
                  isLoading
                      ? null
                      : () async {
                        final berhasil = await viewModel.verifyOtp(
                          _otpCtrl.text,
                        );
                        if (berhasil && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Akun berhasil diverifikasi! Selamat datang 🎉',
                              ),
                            ),
                          );
                          // AuthWrapper akan otomatis redirect ke home
                          // karena session sudah terbentuk setelah verifyOTP
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      },
              child:
                  isLoading
                      ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Verifikasi'),
            ),
            const SizedBox(height: 12),
            // Tombol sekunder: Kirim Ulang OTP
            TextButton(
              onPressed:
                  isLoading
                      ? null
                      : () async {
                        await viewModel.resendOtp();
                        if (context.mounted &&
                            viewModel.status != AuthStatus.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Kode OTP baru telah dikirim ulang.',
                              ),
                            ),
                          );
                        }
                      },
              child: const Text('Belum terima kode? Kirim ulang'),
            ),
          ],
        ),
      ),
    );
  }
}
