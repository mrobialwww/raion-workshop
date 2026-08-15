// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/destination_repository.dart';
import 'data/repositories/trip_repository.dart';
import 'data/services/destination_local_service.dart';
import 'ui/destination_list/destination_list_view.dart';
import 'ui/destination_list/destination_list_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => DestinationLocalService()),

        Provider(
          create: (context) => DestinationRepository(
            service: context.read<DestinationLocalService>(),
          ),
        ),

        // Didaftarin di paling atas, biar dua layar pakai objek yang sama
        Provider(create: (_) => TripRepository()),
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
      home: ChangeNotifierProvider(
        create: (context) => DestinationListViewModel(
          repository: context.read<DestinationRepository>(),
          tripRepository: context.read<TripRepository>(),
        )..muat(),
        child: const DestinationListView(),
      ),
    );
  }
}