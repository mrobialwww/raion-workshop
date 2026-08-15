// lib/data/models/destination.dart

class Destination {
  const Destination({
    required this.id,
    required this.nama,
    required this.daerah,
    required this.hargaRupiah,
  });

  final String id;
  final String nama;
  final String daerah;
  final int hargaRupiah;

  // Satu-satunya tempat harga diformat.
  // Jadi nggak ada widget yang ngitung atau nyusun teks harga sendiri.
  String get hargaTampil => 'Rp $hargaRupiah';
}