// lib/ui/live_trip_board/live_trip_board_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'live_trip_board_viewmodel.dart';

class LiveTripBoardView extends StatelessWidget {
  const LiveTripBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LiveTripBoardViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text(vm.tripTitle)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: Colors.white, size: 8),
                  SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body:
          vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _sectionItinerary(vm),
                  const SizedBox(height: 16),
                  _sectionActivity(vm),
                ],
              ),
    );
  }

  Widget _sectionItinerary(LiveTripBoardViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ITINERARY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (vm.destinations.isEmpty)
              const Text(
                'Belum ada destinasi',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...vm.destinations.map((d) {
                final (icon, color) = switch (d.status) {
                  'visited' => ('✓', Colors.green),
                  'in_progress' => ('●', Colors.orange),
                  _ => ('○', Colors.grey),
                };
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(icon, style: TextStyle(color: color, fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(d.name),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _sectionActivity(LiveTripBoardViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RECENT ACTIVITY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (vm.recentActivity.isEmpty)
              const Text(
                'Belum ada aktivitas',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...vm.recentActivity.map(
                (a) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [const Text('• '), Expanded(child: Text(a))],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
