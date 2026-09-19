// lib/ui/destination_list/destination_list_viewmodel.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/trip_destination.dart';
import '../../data/models/trip_plan.dart';
import '../../data/repositories/destination_repository.dart';
import '../../data/repositories/trip_repository.dart';
import '../../data/repositories/auth_repository.dart';

enum StatusData { memuat, berhasil, gagal }

class DestinationListViewModel extends ChangeNotifier {
  DestinationListViewModel({
    required this.repository,
    required this.tripRepository,
    required this.authRepository,
  });

  final DestinationRepository repository;
  final TripRepository tripRepository;
  final AuthRepository authRepository;

  StatusData _status = StatusData.memuat;
  List<TripDestination> _semua = [];
  List<TripPlan> _tripPlans = [];
  TripPlan? _selectedTrip;
  String _kataKunci = '';
  String _pesanError = '';

  StatusData get status => _status;
  String get pesanError => _pesanError;
  List<TripPlan> get tripPlans => _tripPlans;
  TripPlan? get selectedTrip => _selectedTrip;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  List<TripDestination> get destinasi {
    if (_kataKunci.isEmpty) return _semua;
    final kunci = _kataKunci.toLowerCase();
    return _semua.where((d) {
      return d.name.toLowerCase().contains(kunci) ||
          d.daerah.toLowerCase().contains(kunci);
    }).toList();
  }

  Future<void> muat() async {
    _status = StatusData.memuat;
    notifyListeners();

    try {
      _tripPlans = await tripRepository.ambilTripPlans();
      if (_tripPlans.isNotEmpty) {
        _selectedTrip = _tripPlans.first;
        _semua = await repository.ambilDestinasi(_selectedTrip!.id);
      } else {
        _semua = [];
      }
      _status = StatusData.berhasil;
    } catch (e) {
      _pesanError = 'Gagal memuat data. Coba lagi.';
      _status = StatusData.gagal;
    }

    notifyListeners();
  }

  Future<void> pilihTrip(TripPlan trip) async {
    _selectedTrip = trip;
    _status = StatusData.memuat;
    notifyListeners();

    try {
      _semua = await repository.ambilDestinasi(trip.id);
      _status = StatusData.berhasil;
    } catch (_) {
      _status = StatusData.gagal;
    }

    notifyListeners();
  }

  Future<void> buatTripPlan(String title) async {
    final trip = await tripRepository.buatTripPlan(title);
    _tripPlans.insert(0, trip);
    await pilihTrip(trip);
  }

  Future<void> tambahDestinasi({
    required String name,
    required String daerah,
    required int hargaRupiah,
  }) async {
    if (_selectedTrip == null) return;

    final item = TripDestination(
      id: '',
      tripPlanId: _selectedTrip!.id,
      name: name,
      daerah: daerah,
      hargaRupiah: hargaRupiah,
      status: 'planned',
      orderIndex: _semua.length,
      createdAt: DateTime.now(),
    );

    final hasil = await repository.tambahDestinasi(item);
    _semua.add(hasil);
    notifyListeners();
  }

  Future<void> updateStatus(String id, String status) async {
    await repository.updateStatus(id, status);
    final idx = _semua.indexWhere((d) => d.id == id);
    if (idx != -1) {
      _semua[idx] = TripDestination(
        id: _semua[idx].id,
        tripPlanId: _semua[idx].tripPlanId,
        name: _semua[idx].name,
        daerah: _semua[idx].daerah,
        hargaRupiah: _semua[idx].hargaRupiah,
        status: status,
        photoUrl: _semua[idx].photoUrl,
        orderIndex: _semua[idx].orderIndex,
        createdAt: _semua[idx].createdAt,
      );
      notifyListeners();
    }
  }

  Future<void> hapusDestinasi(String id) async {
    await repository.hapusDestinasi(id);
    _semua.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  void cari(String kataKunci) {
    _kataKunci = kataKunci;
    notifyListeners();
  }

  Future<void> logout() async {
    await authRepository.signOut();
  }

  // Fungsi untuk mengunggah foto ke destinasi tertentu
  Future<void> uploadFoto(String destinationId) async {
    try {
      // 1. Membuka galeri ponsel supaya pengguna bisa memilih gambar
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      // Kalau pengguna membatalkan pilihan (tutup galeri), proses berhenti di sini
      if (picked == null) return;

      // 2. Tampilkan efek loading di layar
      _status = StatusData.memuat;
      notifyListeners();

      // 3. Menyiapkan wujud asli file gambar tsb dan mencari tahu ID siapa yang klik (user saat ini)
      final file = File(picked.path);
      final userId = authRepository.getCurrentUserId()!;

      // 4. Mengirimkan gambar ke Storage DAN menyimpan URL-nya ke Database sekaligus
      final url = await repository.uploadAndUpdateFoto(
        userId: userId,
        destinationId: destinationId,
        file: file,
      );

      // 5. Mencari di mana urutan data lama di memori HP, lalu menggantinya dengan data baru + sisipan URL foto
      // Ini agar fotonya langsung muncul di tampilan HP tanpa perlu di-refresh ulang dari awal
      final idx = _semua.indexWhere((d) => d.id == destinationId);
      if (idx != -1) {
        _semua[idx] = TripDestination(
          id: _semua[idx].id,
          tripPlanId: _semua[idx].tripPlanId,
          name: _semua[idx].name,
          daerah: _semua[idx].daerah,
          hargaRupiah: _semua[idx].hargaRupiah,
          status: _semua[idx].status,
          photoUrl: url,
          orderIndex: _semua[idx].orderIndex,
          createdAt: _semua[idx].createdAt,
        );
      }

      // 6. Beri tahu UI bahwa semuanya sukses dan matikan layar loading
      _status = StatusData.berhasil;
      notifyListeners();
    } catch (e) {
      // 7. Kalau internet mati atau gagal proses, tangkap pesan errornya!
      _pesanError = 'Gagal upload foto';
      _status = StatusData.gagal;
      notifyListeners();
    }
  }
}
