// lib/data/models/trip_plan.dart

class TripPlan {
  TripPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;

  factory TripPlan.fromMap(Map<String, dynamic> map) {
    return TripPlan(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
