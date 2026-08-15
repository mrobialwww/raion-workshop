// lib/ui/trip_plan/trip_plan_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'trip_plan_viewmodel.dart';

class TripPlanView extends StatelessWidget {
  const TripPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPlanViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Rencana Perjalanan')),
      body: viewModel.rencana.isEmpty
          ? const Center(child: Text('Belum ada destinasi yang dipilih'))
          : ListView.builder(
              itemCount: viewModel.rencana.length,
              itemBuilder: (context, index) {
                final destinasi = viewModel.rencana[index];
                return ListTile(
                  title: Text(destinasi.nama),
                  subtitle: Text(destinasi.hargaTampil),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => viewModel.hapus(destinasi.id),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Total: ${viewModel.totalTampil}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}