// lib/data/models/trip_destination.dart

class TripDestination {
  TripDestination({
    required this.id,
    required this.tripPlanId,
    required this.name,
    required this.daerah,
    required this.hargaRupiah,
    required this.status,
    this.photoUrl,
    required this.orderIndex,
    required this.createdAt,
  });

  final String id;
  final String tripPlanId;
  final String name;
  final String daerah;
  final int hargaRupiah;
  final String status;
  final String? photoUrl;
  final int orderIndex;
  final DateTime createdAt;

  // Satu-satunya tempat harga diformat.
  String get hargaTampil => 'Rp $hargaRupiah';

  factory TripDestination.fromMap(Map<String, dynamic> map) {
    return TripDestination(
      id: map['id'] as String,
      tripPlanId: map['trip_plan_id'] as String,
      name: map['name'] as String,
      daerah: map['daerah'] as String? ?? '',
      hargaRupiah: map['harga_rupiah'] as int? ?? 0,
      status: map['status'] as String? ?? 'planned',
      photoUrl: map['photo_url'] as String?,
      orderIndex: map['order_index'] as int? ?? 0,
      createdAt:
          map['created_at'] != null
              ? DateTime.parse(map['created_at'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_plan_id': tripPlanId,
      'name': name,
      'daerah': daerah,
      'harga_rupiah': hargaRupiah,
      'status': status,
      'photo_url': photoUrl,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
