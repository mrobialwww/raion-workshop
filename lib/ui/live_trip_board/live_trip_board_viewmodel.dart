// lib/ui/live_trip_board/live_trip_board_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/trip_destination.dart';

class LiveTripBoardViewModel extends ChangeNotifier {
  LiveTripBoardViewModel({required this.tripPlanId, required this.tripTitle});

  final String tripPlanId;
  final String tripTitle;

  final _client = Supabase.instance.client;
  RealtimeChannel? _channel;

  List<TripDestination> destinations = [];
  final List<String> recentActivity = [];
  bool isLoading = true;

  Future<void> init() async {
    // TODO: Ambil data awal dari tabel 'trip_plan_items' (filter by tripPlanId, order by order_index),
    // convert ke List<TripDestination>, set isLoading = false, lalu notifyListeners()

    // Subscribe ke Realtime
    // 1. Saat teman menambahkan destinasi baru
    // 2. Saat teman mengubah status (cth: Planned -> Visited)
    // 3. Saat teman menekan tombol Hapus Destinasi
    _channel =
        _client
            .channel('trip_board_$tripPlanId')
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'trip_plan_items',
              callback: (payload) {
                // TODO: Cek `trip_plan_id`, ubah payload.newRecord menjadi TripDestination,
                // tambahkan ke destinations, catat aktivitas, lalu notifyListeners()
              },
            )
            .onPostgresChanges(
              event: PostgresChangeEvent.update,
              schema: 'public',
              table: 'trip_plan_items',
              callback: (payload) {
                // TODO: Cek `trip_plan_id`, ubah payload.newRecord menjadi TripDestination,
                // cari indexnya, timpa data lama, lalu notifyListeners()
              },
            )
            .onPostgresChanges(
              event: PostgresChangeEvent.delete,
              schema: 'public',
              table: 'trip_plan_items',
              callback: (payload) {
                // TODO: Ambil id dari payload.oldRecord, cari destinasi berdasarkan id,
                // hapus dari destinations, lalu notifyListeners()
              },
            )
            .subscribe();
  }

  // Menambahkan ke daftar riwayat aktivitas
  void _tambahActivity(String pesan) {
    recentActivity.insert(0, pesan);
    if (recentActivity.length > 5) recentActivity.removeLast();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }
}
