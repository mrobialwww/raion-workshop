// lib/data/repositories/trip_repository.dart
import '../models/trip_plan.dart';
import '../services/trip_supabase_service.dart';

class TripRepository {
  TripRepository({required this.supabaseService});

  final TripSupabaseService supabaseService;

  Future<List<TripPlan>> ambilTripPlans() => supabaseService.fetchTripPlans();

  Future<TripPlan> buatTripPlan(String title) =>
      supabaseService.createTripPlan(title);

  Future<void> hapusTripPlan(String id) => supabaseService.deleteTripPlan(id);
}
