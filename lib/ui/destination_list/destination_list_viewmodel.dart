// lib/ui/destination_list/destination_list_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../../data/models/destination.dart';
import '../../data/repositories/destination_repository.dart';

enum StatusData { memuat, berhasil, gagal }

class DestinationListViewModel extends ChangeNotifier {
  DestinationListViewModel({required this.repository});

  final DestinationRepository repository;

  StatusData _status = StatusData.memuat;
  List<Destination> _semua = [];
  String _kataKunci = '';
  String _pesanError = '';

  StatusData get status => _status;
  String get pesanError => _pesanError;

  // Logika nyaringnya di sini, bukan di dalam build()
  List<Destination> get destinasi {
    if (_kataKunci.isEmpty) return _semua;

    final kunci = _kataKunci.toLowerCase();
    return _semua.where((d) {
      return d.nama.toLowerCase().contains(kunci) ||
          d.daerah.toLowerCase().contains(kunci);
    }).toList();
  }

  Future<void> muat() async {
    _status = StatusData.memuat;
    notifyListeners();

    try {
      _semua = await repository.ambilDestinasi(paksaMuatUlang: true);
      _status = StatusData.berhasil;
    } catch (e) {
      _pesanError = 'Gagal memuat destinasi. Coba lagi.';
      _status = StatusData.gagal;
    }

    notifyListeners();
  }

  void cari(String kataKunci) {
    _kataKunci = kataKunci;
    notifyListeners();   // nggak manggil Service lagi, datanya udah ada
  }
}