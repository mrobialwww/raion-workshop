// lib/ui/trip_plan/trip_plan_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../../data/models/destination.dart';
import '../../data/repositories/trip_repository.dart';

class TripPlanViewModel extends ChangeNotifier {
  TripPlanViewModel({required this.tripRepository});

  final TripRepository tripRepository;

  List<Destination> get rencana => tripRepository.ambilRencana();

  // Hitungan totalnya di ViewModel, bukan di widget
  int get totalHarga =>
      rencana.fold<int>(0, (total, destinasi) => total + destinasi.hargaRupiah);

  String get totalTampil => 'Rp $totalHarga';

  void hapus(String id) {
    tripRepository.hapus(id);
    notifyListeners();
  }
}