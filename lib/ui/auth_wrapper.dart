// lib/ui/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/destination_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/trip_repository.dart';
import 'auth/login_view.dart';
import 'auth/login_viewmodel.dart';
import 'destination_list/destination_list_view.dart';
import 'destination_list/destination_list_viewmodel.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // Mendengarkan perubahan auth state onauthenticated <-> authenticated
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Membangun halaman yg sesuai dengan auth state
      builder: (context, snapshot) {
        // Ambil data sesi (bukti login) terbaru dari stream
        final session = snapshot.data?.session;

        if (session != null) {
          // User sudah login → tampilkan halaman utama
          return ChangeNotifierProvider(
            create:
                (context) => DestinationListViewModel(
                  repository: context.read<DestinationRepository>(),
                  tripRepository: context.read<TripRepository>(),
                  authRepository: context.read<AuthRepository>(),
                )..muat(),
            child: const DestinationListView(),
          );
        }

        // User belum login → tampilkan halaman login
        return ChangeNotifierProvider(
          create:
              (_) => LoginViewModel(
                authRepository: context.read<AuthRepository>(),
              ),
          child: const LoginView(),
        );
      },
    );
  }
}
