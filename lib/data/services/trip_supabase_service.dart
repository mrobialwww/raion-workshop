// lib/data/services/trip_supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_plan.dart';

class TripSupabaseService {
  final _client = Supabase.instance.client;

  // ── Trip Plans ──────────────────────────────────────────
  Future<List<TripPlan>> fetchTripPlans() async {
    final data = await _client
        .from('trip_plans')
        .select()
        .order('created_at', ascending: false);

    return (data as List).map((e) => TripPlan.fromMap(e)).toList();
  }

  Future<TripPlan> createTripPlan(String title) async {
    final userId = _client.auth.currentUser!.id;
    final data =
        await _client
            .from('trip_plans')
            .insert({'user_id': userId, 'title': title})
            .select()
            .single();

    return TripPlan.fromMap(data);
  }

  Future<void> deleteTripPlan(String id) async {
    await _client.from('trip_plans').delete().eq('id', id);
  }
}
