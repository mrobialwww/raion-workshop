// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/repositories/destination_repository.dart';
import 'data/repositories/trip_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/services/auth_service.dart';
import 'data/services/destination_local_service.dart';
import 'data/services/trip_supabase_service.dart';
import 'ui/auth_wrapper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(
          create:
              (context) => AuthRepository(service: context.read<AuthService>()),
        ),
        Provider(create: (_) => TripSupabaseService()),
        Provider(create: (_) => DestinationLocalService()),
        Provider(
          create:
              (context) => DestinationRepository(
                service: context.read<DestinationLocalService>(),
              ),
        ),
        Provider(
          create:
              (context) => TripRepository(
                supabaseService: context.read<TripSupabaseService>(),
              ),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisatain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const AuthWrapper(),
    );
  }
}
