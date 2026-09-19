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

  List<TripDestination> _destinations = [];
  final List<String> _recentActivity = [];
  bool isLoading = true;

  // UI mengakses daftar destinasi melalui getter ini
  List<TripDestination> get destinations => _destinations;

  // UI mengakses riwayat log aktivitas melalui getter ini
  List<String> get recentActivity => _recentActivity;

  Future<void> init() async {
    // Muat data awal
    final data = await _client
        .from('trip_plan_items')
        .select()
        .eq('trip_plan_id', tripPlanId)
        .order('order_index', ascending: true);

    _destinations =
        (data as List).map((e) => TripDestination.fromMap(e)).toList();
    isLoading = false;
    notifyListeners();

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
                // Abaikan jika bukan milik trip plan ini
                if (payload.newRecord['trip_plan_id'] != tripPlanId) return;

                // Ubah data mentah dari Supabase menjadi objek Dart
                final item = TripDestination.fromMap(payload.newRecord);

                // Tambahkan ke memori lokal
                _destinations.add(item);

                // Catat ke riwayat aktivitas
                _tambahActivity('Destinasi baru ditambahkan');

                // Render ulang layar
                notifyListeners();
              },
            )
            .onPostgresChanges(
              event: PostgresChangeEvent.update,
              schema: 'public',
              table: 'trip_plan_items',
              callback: (payload) {
                // Abaikan jika bukan milik trip plan ini
                if (payload.newRecord['trip_plan_id'] != tripPlanId) return;

                // Ubah data mentah dari Supabase menjadi objek Dart
                final updated = TripDestination.fromMap(payload.newRecord);

                // Cari ada di urutan ke-berapa data usang tersebut di HP kita
                final idx = _destinations.indexWhere((d) => d.id == updated.id);

                // Timpa dengan data baru
                if (idx != -1) {
                  _destinations[idx] = updated;
                }

                _tambahActivity('Destinasi diperbarui');
                notifyListeners();
              },
            )
            .onPostgresChanges(
              event: PostgresChangeEvent.delete,
              schema: 'public',
              table: 'trip_plan_items',
              callback: (payload) {
                // OldRecord adalah jejak rekaman dari baris yang baru saja dihanguskan dari database. biasanya cuma { "id": "..." }.
                final id = payload.oldRecord['id'] as String?;

                // Cari destinasi dengan ID tersebut di memori lokal kita, lalu hapus dari list
                if (id != null) _destinations.removeWhere((d) => d.id == id);

                _tambahActivity('Destinasi dihapus');
                notifyListeners();
              },
            )
            .subscribe();
  }

  void _tambahActivity(String pesan) {
    _recentActivity.insert(0, pesan);
    if (_recentActivity.length > 5) _recentActivity.removeLast();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }
}
