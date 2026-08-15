// lib/data/services/destination_local_service.dart
import '../models/destination.dart';

class DestinationLocalService {
  // Jedanya sengaja dikasih, biar state "memuat" beneran kelihatan pas demo.
  Future<List<Destination>> ambilDestinasi() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return const [
      Destination(id: 'd1', nama: 'Pantai Kelingking', daerah: 'Bali', hargaRupiah: 250000),
      Destination(id: 'd2', nama: 'Bromo Sunrise', daerah: 'Jawa Timur', hargaRupiah: 400000),
      Destination(id: 'd3', nama: 'Raja Ampat', daerah: 'Papua Barat', hargaRupiah: 1500000),
      Destination(id: 'd4', nama: 'Danau Toba', daerah: 'Sumatera Utara', hargaRupiah: 300000),
      Destination(id: 'd5', nama: 'Kawah Ijen', daerah: 'Jawa Timur', hargaRupiah: 350000),
    ];
  }
}