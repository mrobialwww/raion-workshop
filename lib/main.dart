// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/destination_repository.dart';
import 'data/services/destination_local_service.dart';
import 'ui/destination_list/destination_list_view.dart';
import 'ui/destination_list/destination_list_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Lapisan paling bawah didaftarin duluan
        Provider(create: (_) => DestinationLocalService()),

        Provider(
          create: (context) => DestinationRepository(
            service: context.read<DestinationLocalService>(),
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
      theme: ThemeData(colorSchemeSeed: Colors.teal),

      // ViewModel didaftarin dekat layarnya. Satu layar, satu ViewModel.
      home: ChangeNotifierProvider(
        // "..muat()" artinya: bikin ViewModelnya, terus langsung panggil muat()
        create: (context) => DestinationListViewModel(
          repository: context.read<DestinationRepository>(),
        )..muat(),
        child: const DestinationListView(),
      ),
    );
  }
}