class ActivityModel {
  final String id;
  final String tripId;
  final int dayNumber;
  final String activityType; // 'TRANSPORT', 'HOTEL', 'SIGHTSEEING', 'FOOD'
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final double cost;

  ActivityModel({
    required this.id,
    required this.tripId,
    required this.dayNumber,
    required this.activityType,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.cost,
  });
}
