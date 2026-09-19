// lib/ui/destination_list/destination_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../live_trip_board/live_trip_board_view.dart';
import '../live_trip_board/live_trip_board_viewmodel.dart';
import 'destination_list_viewmodel.dart';

class DestinationListView extends StatelessWidget {
  const DestinationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DestinationListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.selectedTrip?.title ?? 'Wisatain'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            tooltip: 'Live Trip Board',
            onPressed:
                viewModel.selectedTrip == null
                    ? null
                    : () => _bukaLiveTripBoard(context, viewModel),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => viewModel.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown pilih trip
          if (viewModel.tripPlans.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: DropdownButtonFormField<String>(
                initialValue: viewModel.selectedTrip?.id,
                decoration: const InputDecoration(
                  labelText: 'Trip Plan',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items:
                    viewModel.tripPlans
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(t.title),
                          ),
                        )
                        .toList(),
                onChanged: (id) {
                  final trip = viewModel.tripPlans.firstWhere(
                    (t) => t.id == id,
                  );
                  viewModel.pilihTrip(trip);
                },
              ),
            ),
          // Search bar
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
          Expanded(child: _isi(context, viewModel)),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'fab_trip',
            onPressed: () => _dialogBuatTrip(context, viewModel),
            tooltip: 'Buat Trip Baru',
            child: const Icon(Icons.map),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'fab_dest',
            onPressed:
                viewModel.selectedTrip == null
                    ? null
                    : () => _dialogTambahDestinasi(context, viewModel),
            tooltip: 'Tambah Destinasi',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _bukaLiveTripBoard(
    BuildContext context,
    DestinationListViewModel viewModel,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider(
              create:
                  (_) => LiveTripBoardViewModel(
                    tripPlanId: viewModel.selectedTrip!.id,
                    tripTitle: viewModel.selectedTrip!.title,
                  )..init(),
              child: const LiveTripBoardView(),
            ),
      ),
    );
  }

  Widget _isi(BuildContext context, DestinationListViewModel viewModel) {
    switch (viewModel.status) {
      case StatusData.memuat:
        return const Center(child: CircularProgressIndicator());

      case StatusData.gagal:
        return Center(child: Text(viewModel.pesanError));

      case StatusData.berhasil:
        if (viewModel.selectedTrip == null) {
          return const Center(child: Text('Buat trip plan dulu!'));
        }
        if (viewModel.destinasi.isEmpty) {
          return const Center(child: Text('Belum ada destinasi. Tambahkan!'));
        }

        return ListView.builder(
          itemCount: viewModel.destinasi.length,
          itemBuilder: (context, index) {
            final dest = viewModel.destinasi[index];

            return ListTile(
              leading:
                  dest.photoUrl != null
                      ? CircleAvatar(
                        backgroundImage: NetworkImage(dest.photoUrl!),
                      )
                      : const CircleAvatar(child: Icon(Icons.place)),
              title: Text(dest.name),
              subtitle: Text('${dest.daerah} · ${dest.hargaTampil}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _statusChip(dest.status),
                  PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'delete') {
                        viewModel.hapusDestinasi(dest.id);
                      } else if (val == 'upload_photo') {
                        viewModel.uploadFoto(dest.id);
                      } else {
                        viewModel.updateStatus(dest.id, val);
                      }
                    },
                    itemBuilder:
                        (_) => [
                          const PopupMenuItem(
                            value: 'planned',
                            child: Text('○ Planned'),
                          ),
                          const PopupMenuItem(
                            value: 'in_progress',
                            child: Text('● In Progress'),
                          ),
                          const PopupMenuItem(
                            value: 'visited',
                            child: Text('✓ Visited'),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'upload_photo',
                            child: Text('📷 Upload Foto'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  Widget _statusChip(String status) {
    final (label, color) = switch (status) {
      'visited' => ('✓', Colors.green),
      'in_progress' => ('●', Colors.orange),
      _ => ('○', Colors.grey),
    };
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(label, style: TextStyle(color: color, fontSize: 18)),
    );
  }

  Future<void> _dialogBuatTrip(
    BuildContext context,
    DestinationListViewModel viewModel,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => _BuatTripDialog(viewModel: viewModel),
    );
  }

  Future<void> _dialogTambahDestinasi(
    BuildContext context,
    DestinationListViewModel viewModel,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => _TambahDestinasiDialog(viewModel: viewModel),
    );
  }
}

class _BuatTripDialog extends StatefulWidget {
  final DestinationListViewModel viewModel;
  const _BuatTripDialog({required this.viewModel});

  @override
  State<_BuatTripDialog> createState() => _BuatTripDialogState();
}

class _BuatTripDialogState extends State<_BuatTripDialog> {
  final ctrl = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buat Trip Baru'),
      content: TextField(
        controller: ctrl,
        decoration: const InputDecoration(
          labelText: 'Nama Trip (contoh: Bali Trip)',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (ctrl.text.isNotEmpty) {
              widget.viewModel.buatTripPlan(ctrl.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Buat'),
        ),
      ],
    );
  }
}

class _TambahDestinasiDialog extends StatefulWidget {
  final DestinationListViewModel viewModel;
  const _TambahDestinasiDialog({required this.viewModel});

  @override
  State<_TambahDestinasiDialog> createState() => _TambahDestinasiDialogState();
}

class _TambahDestinasiDialogState extends State<_TambahDestinasiDialog> {
  final nameCtrl = TextEditingController();
  final daerahCtrl = TextEditingController();
  final hargaCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    daerahCtrl.dispose();
    hargaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Destinasi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Nama Destinasi'),
          ),
          TextField(
            controller: daerahCtrl,
            decoration: const InputDecoration(labelText: 'Daerah'),
          ),
          TextField(
            controller: hargaCtrl,
            decoration: const InputDecoration(labelText: 'Harga (Rp)'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (nameCtrl.text.isNotEmpty) {
              widget.viewModel.tambahDestinasi(
                name: nameCtrl.text.trim(),
                daerah: daerahCtrl.text.trim(),
                hargaRupiah: int.tryParse(hargaCtrl.text) ?? 0,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
