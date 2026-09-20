class AppConstants {
  static const List<Map<String, dynamic>> preBakedTemplates = [
    {
      'title': 'Weekend in Paris',
      'destination': 'Paris',
      'prompt': 'Plan a 3-day romantic weekend in Paris focusing on art and food.',
      'durationDays': 3,
      'image': 'assets/images/paris.jpg',
    },
    {
      'title': 'Tokyo Tech & Culture',
      'destination': 'Tokyo',
      'prompt': 'A 5-day trip to Tokyo exploring gadgets, anime, and modern culture.',
      'durationDays': 5,
      'image': 'assets/images/tokyo.jpg',
    },
    {
      'title': 'Swiss Alps Alpine Hike',
      'destination': 'Swiss Alps',
      'prompt': 'A 4-day hiking adventure in the Swiss Alps with mountain views.',
      'durationDays': 4,
      'image': 'assets/images/swiss_alps.jpg',
    },
    {
      'title': 'Rome Antiquities & Cuisine',
      'destination': 'Rome',
      'prompt': 'A 3-day cultural exploration of ancient Rome ruins and cuisine.',
      'durationDays': 3,
      'image': 'assets/images/rome.jpg',
    },
  ];

  static const List<String> activityTypes = ['TRANSPORT', 'HOTEL', 'SIGHTSEEING', 'FOOD'];
}
