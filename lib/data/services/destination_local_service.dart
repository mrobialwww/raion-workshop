// lib/data/services/destination_local_service.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_destination.dart';

class DestinationLocalService {
  final _client = Supabase.instance.client;

  Future<List<TripDestination>> fetchDestinations(String tripPlanId) async {
    // TODO: Query tabel 'trip_plan_items', filter by trip_plan_id, order by order_index ascending
    throw UnimplementedError();
  }

  Future<TripDestination> createDestination(TripDestination item) async {
    // TODO: Insert ke tabel 'trip_plan_items' lalu kembalikan hasilnya sebagai TripDestination
    throw UnimplementedError();
  }

  Future<void> updateDestinationStatus(String id, String status) async {
    // TODO: Update kolom 'status' dan 'updated_at' di tabel 'trip_plan_items'
  }

  Future<void> updateDestinationPhoto(String id, String photoUrl) async {
    // TODO: Update kolom 'photo_url' di tabel 'trip_plan_items'
  }

  Future<void> deleteDestination(String id) async {
    // TODO: Delete baris pada tabel 'trip_plan_items' berdasarkan id
  }

  Future<String> uploadPhoto({
    required String userId,
    required String destinationId,
    required File imagefile,
  }) async {
    // TODO: Upload file ke Supabase Storage bucket 'destination-images'
    // Lalu kembalikan public URL-nya
    throw UnimplementedError();
  }

  Future<void> deletePhoto(String path) async {
    // TODO: Delete file dari Supabase Storage bucket 'destination-images'
  }
}
