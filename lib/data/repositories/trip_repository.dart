// lib/data/repositories/trip_repository.dart
import '../models/destination.dart';

class TripRepository {
  // Satu-satunya tempat data rencana perjalanan disimpan.
  final List<Destination> _rencana = [];

  // Dikasih versi yang nggak bisa diubah, biar View nggak bisa
  // nambah atau ngapus data langsung.
  List<Destination> ambilRencana() => List.unmodifiable(_rencana);

  int get jumlah => _rencana.length;

  bool sudahAda(String id) => _rencana.any((d) => d.id == id);

  void tambah(Destination destinasi) {
    if (!sudahAda(destinasi.id)) {
      _rencana.add(destinasi);
    }
  }

  void hapus(String id) {
    _rencana.removeWhere((d) => d.id == id);
  }
}