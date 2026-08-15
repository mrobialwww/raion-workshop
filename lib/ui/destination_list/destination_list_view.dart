// lib/ui/destination_list/destination_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/trip_repository.dart';
import '../trip_plan/trip_plan_view.dart';
import '../trip_plan/trip_plan_viewmodel.dart';
import 'destination_list_viewmodel.dart';

class DestinationListView extends StatelessWidget {
  const DestinationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DestinationListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisatain'),
        actions: [
          TextButton.icon(
            onPressed: () => _bukaRencana(context, viewModel),
            icon: const Icon(Icons.luggage),
            label: Text('${viewModel.jumlahRencana}'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: viewModel.cari,
              decoration: const InputDecoration(
                hintText: 'Cari destinasi atau daerah',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: _isi(viewModel)),
        ],
      ),
    );
  }

  Future<void> _bukaRencana(
    BuildContext context,
    DestinationListViewModel viewModel,
  ) async {
    // Repositorynya diambil dulu sebelum pindah layar
    final tripRepository = context.read<TripRepository>();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => TripPlanViewModel(tripRepository: tripRepository),
          child: const TripPlanView(),
        ),
      ),
    );

    viewModel.segarkan();
  }

  Widget _isi(DestinationListViewModel viewModel) {
    switch (viewModel.status) {
      case StatusData.memuat:
        return const Center(child: CircularProgressIndicator());

      case StatusData.gagal:
        return Center(child: Text(viewModel.pesanError));

      case StatusData.berhasil:
        if (viewModel.destinasi.isEmpty) {
          return const Center(child: Text('Destinasinya nggak ketemu'));
        }

        return ListView.builder(
          itemCount: viewModel.destinasi.length,
          itemBuilder: (context, index) {
            final destinasi = viewModel.destinasi[index];
            final sudah = viewModel.sudahDirencanakan(destinasi.id);

            return ListTile(
              title: Text(destinasi.nama),
              subtitle: Text('${destinasi.daerah} · ${destinasi.hargaTampil}'),
              trailing: sudah
                  ? const Icon(Icons.check_circle, color: Colors.teal)
                  : IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => viewModel.tambahKeRencana(destinasi),
                    ),
            );
          },
        );
    }
  }
}