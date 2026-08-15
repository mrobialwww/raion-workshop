// lib/ui/destination_list/destination_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'destination_list_viewmodel.dart';

class DestinationListView extends StatelessWidget {
  const DestinationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DestinationListViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Wisatain')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              // Ketikannya dikirim ke ViewModel, bukan disimpan di widget
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
            return ListTile(
              title: Text(destinasi.nama),
              subtitle: Text(destinasi.daerah),
              trailing: Text(destinasi.hargaTampil),
            );
          },
        );
    }
  }
}