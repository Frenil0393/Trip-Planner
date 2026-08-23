class TripModel {
  final String id;
  final String title;
  final String originalPrompt;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  String status; // 'UPCOMING', 'ACTIVE', 'PAST'

  TripModel({
    required this.id,
    required this.title,
    required this.originalPrompt,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.status = 'UPCOMING',
  });
}
