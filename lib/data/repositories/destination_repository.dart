// lib/data/repositories/destination_repository.dart
import '../models/destination.dart';
import '../services/destination_local_service.dart';

class DestinationRepository {
  DestinationRepository({required this.service});

  final DestinationLocalService service;

  // Cache sederhana. Ini tugas Repository, bukan Service.
  List<Destination>? _cache;

  Future<List<Destination>> ambilDestinasi({bool paksaMuatUlang = false}) async {
    if (_cache != null && !paksaMuatUlang) {
      return _cache!;
    }

    final hasil = await service.ambilDestinasi();
    _cache = hasil;
    return hasil;
  }
}