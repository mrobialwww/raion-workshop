// lib/data/services/destination_local_service.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_destination.dart';

class DestinationLocalService {
  final _client = Supabase.instance.client;

  Future<List<TripDestination>> fetchDestinations(String tripPlanId) async {
    final data = await _client
        .from('trip_plan_items')
        .select()
        .eq('trip_plan_id', tripPlanId)
        .order('order_index', ascending: true);
    return (data as List).map((e) => TripDestination.fromMap(e)).toList();
  }

  Future<TripDestination> createDestination(TripDestination item) async {
    final data =
        await _client
            .from('trip_plan_items')
            .insert(item.toMap()..remove('id'))
            .select()
            .single();
    return TripDestination.fromMap(data);
  }

  Future<void> updateDestinationStatus(String id, String status) async {
    await _client
        .from('trip_plan_items')
        .update({
          'status': status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }

  Future<void> updateDestinationPhoto(String id, String photoUrl) async {
    await _client
        .from('trip_plan_items')
        .update({'photo_url': photoUrl})
        .eq('id', id);
  }

  Future<void> deleteDestination(String id) async {
    await _client.from('trip_plan_items').delete().eq('id', id);
  }

  Future<String> uploadPhoto({
    required String userId,
    required String destinationId,
    required File imagefile,
  }) async {
    final ext = imagefile.path.split('.').last;
    final path = '$userId/$destinationId.$ext';

    await _client.storage
        .from('destination-images')
        .upload(path, imagefile, fileOptions: const FileOptions(upsert: true));

    return _client.storage.from('destination-images').getPublicUrl(path);
  }

  Future<void> deletePhoto(String path) async {
    await _client.storage.from('destination-images').remove([path]);
  }
}
