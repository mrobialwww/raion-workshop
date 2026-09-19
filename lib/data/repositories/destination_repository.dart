// lib/data/repositories/destination_repository.dart
import 'dart:io';
import '../models/trip_destination.dart';
import '../services/destination_local_service.dart';

class DestinationRepository {
  DestinationRepository({required this.service});

  final DestinationLocalService service;

  Future<List<TripDestination>> ambilDestinasi(String tripPlanId) =>
      service.fetchDestinations(tripPlanId);

  Future<TripDestination> tambahDestinasi(TripDestination item) =>
      service.createDestination(item);

  Future<void> updateStatus(String id, String status) =>
      service.updateDestinationStatus(id, status);

  Future<void> hapusDestinasi(String id) => service.deleteDestination(id);

  // Fungsi penggabung (Orchestrator) untuk Storage & Database
  Future<String> uploadAndUpdateFoto({
    required String userId,
    required String destinationId,
    required File file,
  }) async {
    // 1. Kirim ke Storage Service
    final url = await service.uploadPhoto(
      userId: userId,
      destinationId: destinationId,
      imagefile: file,
    );
    // 2. Simpan URL-nya ke Database Service
    await service.updateDestinationPhoto(destinationId, url);
    return url;
  }

  Future<void> deletePhoto(String path) async => service.deletePhoto(path);
}
