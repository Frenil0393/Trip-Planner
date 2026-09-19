
import 'dart:convert';

/// Represents a travel destination (city, region, or tourist hub).
///
/// This model is designed for the AI Trip Planner to manage destination
/// information, showcase curated tourist attractions (spots), and recommend
/// dining spots. It supports both local SQLite storage and remote API serialization
/// (e.g. Gemini AI recommendations or Amadeus destination search).
class DestinationModel {
  /// Unique identifier for the destination (e.g., 'paris', 'tokyo', or a UUID).
  final String id;

  /// Common display name of the destination (e.g., "Paris", "Tokyo").
  final String name;

  /// Country where the destination is located (e.g., "France", "Japan").
  final String country;

  /// Short catchy tagline or subtitle for UI headers.
  final String tagline;

  /// Detailed overview describing culture, highlights, and travel appeal.
  final String description;

  /// High-resolution banner / hero image URL for cards and detail headers.
  final String imageUrl;

  /// Overall user or travel rating (e.g., 4.8 out of 5.0).
  final double rating;

  /// Associated travel tags or categories (e.g., "Romantic", "Culture", "Food").
  final List<String> tags;

  /// Ideal travel window/season (e.g., "April to October", "Year-round").
  final String bestTimeToVisit;

  /// Primary local currency or standard currency code (e.g., "EUR", "JPY", "USD").
  final String currency;

  /// Curated must-see attractions / landmarks at this destination.
  final List<DestinationSpot> spots;

  /// Curated top dining establishments / restaurants at this destination.
  final List<DestinationDining> dining;

  const DestinationModel({
    required this.id,
    required this.name,
    required this.country,
    this.tagline = '',
    this.description = '',
    required this.imageUrl,
    this.rating = 4.5,
    this.tags = const [],
    this.bestTimeToVisit = 'Year-round',
    this.currency = 'USD',
    this.spots = const [],
    this.dining = const [],
  });

  /// Formatted title combining name and country (e.g., "Paris, France").
  String get fullLocation => '$name, $country';

  /// Creates a copy of this [DestinationModel] with modified fields.
  DestinationModel copyWith({
    String? id,
    String? name,
    String? country,
    String? tagline,
    String? description,
    String? imageUrl,
    double? rating,
    List<String>? tags,
    String? bestTimeToVisit,
    String? currency,
    List<DestinationSpot>? spots,
    List<DestinationDining>? dining,
  }) {
    return DestinationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      bestTimeToVisit: bestTimeToVisit ?? this.bestTimeToVisit,
      currency: currency ?? this.currency,
      spots: spots ?? this.spots,
      dining: dining ?? this.dining,
    );
  }

  /// Converts this [DestinationModel] to a [Map] for SQLite storage or JSON encoding.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'tagline': tagline,
      'description': description,
      'image_url': imageUrl,
      'rating': rating,
      'tags': tags.join(','), // Store as comma-separated string for SQLite
      'best_time_to_visit': bestTimeToVisit,
      'currency': currency,
      'spots': jsonEncode(spots.map((s) => s.toMap()).toList()),
      'dining': jsonEncode(dining.map((d) => d.toMap()).toList()),
    };
  }

  /// Creates a [DestinationModel] from a [Map] (from SQLite query or API response).
  factory DestinationModel.fromMap(Map<String, dynamic> map) {
    // Handle tags parsing (can be a comma-separated String or a List)
    List<String> parsedTags = [];
    if (map['tags'] is String) {
      final tagsStr = map['tags'] as String;
      if (tagsStr.isNotEmpty) {
        parsedTags = tagsStr.split(',').map((e) => e.trim()).toList();
      }
    } else if (map['tags'] is List) {
      parsedTags = List<String>.from(map['tags'] as List);
    }

    // Handle spots parsing (can be a JSON string from SQLite or a List from JSON API)
    List<DestinationSpot> parsedSpots = [];
    if (map['spots'] is String) {
      try {
        final decoded = jsonDecode(map['spots'] as String);
        if (decoded is List) {
          parsedSpots = decoded
              .map((item) => DestinationSpot.fromMap(item as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {}
    } else if (map['spots'] is List) {
      parsedSpots = (map['spots'] as List)
          .map((item) => DestinationSpot.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    // Handle dining parsing
    List<DestinationDining> parsedDining = [];
    if (map['dining'] is String) {
      try {
        final decoded = jsonDecode(map['dining'] as String);
        if (decoded is List) {
          parsedDining = decoded
              .map((item) => DestinationDining.fromMap(item as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {}
    } else if (map['dining'] is List) {
      parsedDining = (map['dining'] as List)
          .map((item) => DestinationDining.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    return DestinationModel(
      id: (map['id'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      country: (map['country'] ?? '') as String,
      tagline: (map['tagline'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      imageUrl: (map['image_url'] ?? map['imageUrl'] ?? '') as String,
      rating: ((map['rating'] ?? 4.5) as num).toDouble(),
      tags: parsedTags,
      bestTimeToVisit: (map['best_time_to_visit'] ?? map['bestTimeToVisit'] ?? 'Year-round') as String,
      currency: (map['currency'] ?? 'USD') as String,
      spots: parsedSpots,
      dining: parsedDining,
    );
  }

  /// Serializes this model directly to a JSON string.
  String toJson() => jsonEncode(toMap());

  /// Deserializes a JSON string directly into a [DestinationModel].
  factory DestinationModel.fromJson(String source) =>
      DestinationModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DestinationModel(id: $id, name: $name, country: $country, spots: ${spots.length}, dining: ${dining.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DestinationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // --------------------------------------------------------------------------
  // Curated Sample Destinations (Ready for immediate use in UI and prototype)
  // --------------------------------------------------------------------------

  /// Pre-configured curated destinations matching the app's default templates.
  static final List<DestinationModel> sampleDestinations = [
    DestinationModel(
      id: 'paris',
      name: 'Paris',
      country: 'France',
      tagline: 'The city of light, love, and endless inspiration.',
      description:
          'Paris, France\'s capital, is a major European city and a global center for art, fashion, gastronomy, and culture. Its 19th-century cityscape is crisscrossed by wide boulevards and the River Seine.',
      imageUrl: 'assets/images/paris.jpg',
      rating: 4.8,
      tags: ['Romantic', 'Art', 'Cuisine', 'Historic'],
      bestTimeToVisit: 'April - October',
      currency: 'EUR',
      spots: [
        DestinationSpot(
          id: 'eiffel-tower',
          title: 'Eiffel Tower',
          description: 'Iconic wrought-iron spire and symbol of Paris.',
          imageUrl: 'assets/images/eiffel_tower.jpg',
          category: 'Landmark',
          rating: 4.8,
        ),
        DestinationSpot(
          id: 'louvre-museum',
          title: 'Louvre Museum',
          description: 'World\'s largest art museum, home to the Mona Lisa.',
          imageUrl: 'assets/images/spot_default.jpg',
          category: 'Museum',
          rating: 4.7,
        ),
        DestinationSpot(
          id: 'notre-dame',
          title: 'Notre-Dame Cathedral',
          description: 'Medieval Catholic cathedral renowned for French Gothic architecture.',
          imageUrl: 'assets/images/paris.jpg',
          category: 'Historic',
          rating: 4.6,
        ),
        DestinationSpot(
          id: 'montmartre',
          title: 'Montmartre & Sacré-Cœur',
          description: 'Bohemian hilltop neighborhood with panoramic basilica views.',
          imageUrl: 'assets/images/spot_default.jpg',
          category: 'Neighborhood',
          rating: 4.7,
        ),
      ],
      dining: [
        DestinationDining(
          id: 'le-jules-verne',
          title: 'Le Jules Verne',
          description: 'Fine French dining with panoramic views from the Eiffel Tower.',
          imageUrl: 'assets/images/spot_default.jpg',
          cuisine: 'French Fine Dining',
          priceRange: '\$\$\$\$',
          rating: 4.9,
        ),
        DestinationDining(
          id: 'cafe-de-flore',
          title: 'Café de Flore',
          description: 'Classic Parisian literary café in Saint-Germain-des-Prés.',
          imageUrl: 'assets/images/spot_default.jpg',
          cuisine: 'French Bistro & Bakery',
          priceRange: '\$\$',
          rating: 4.5,
        ),
        DestinationDining(
          id: 'l-as-du-fallafel',
          title: 'L\'As du Fallafel',
          description: 'World-famous Middle Eastern street food in the heart of the Marais.',
          imageUrl: 'assets/images/spot_default.jpg',
          cuisine: 'Middle Eastern Street Food',
          priceRange: '\$',
          rating: 4.7,
        ),
      ],
    ),
    DestinationModel(
      id: 'tokyo',
      name: 'Tokyo',
      country: 'Japan',
      tagline: 'Where ancient traditions seamlessly meet hyper-futuristic innovation.',
      description:
          'Tokyo, Japan’s bustling capital, mixes ultramodern neon-lit skyscrapers with historic temples. The city is renowned for cutting-edge technology, anime hubs, and unparalleled culinary craft.',
      imageUrl: 'assets/images/tokyo.jpg',
      rating: 4.9,
      tags: ['Futuristic', 'Tech', 'Anime', 'Sushi'],
      bestTimeToVisit: 'March - May & September - November',
      currency: 'JPY',
      spots: [
        DestinationSpot(
          id: 'shibuya-crossing',
          title: 'Shibuya Crossing',
          description: 'The world\'s busiest pedestrian intersection illuminated by giant screens.',
          imageUrl: 'assets/images/shibuya.jpg',
          category: 'Landmark',
          rating: 4.8,
        ),
        DestinationSpot(
          id: 'senso-ji',
          title: 'Sensō-ji Temple',
          description: 'Tokyo’s oldest Buddhist temple founded in 645 AD in Asakusa.',
          imageUrl: 'assets/images/tokyo.jpg',
          category: 'Historic Temple',
          rating: 4.7,
        ),
        DestinationSpot(
          id: 'akihabara-electric-town',
          title: 'Akihabara Electric Town',
          description: 'The epicenter of gaming, manga, anime, and tech electronics.',
          imageUrl: 'assets/images/spot_default.jpg',
          category: 'Culture & Shopping',
          rating: 4.6,
        ),
      ],
      dining: [
        DestinationDining(
          id: 'sukiyabashi-jiro',
          title: 'Ginza Sushi Masters',
          description: 'Authentic Edomae-style omakase sushi prepared by legendary chefs.',
          imageUrl: 'assets/images/spot_default.jpg',
          cuisine: 'Traditional Japanese Sushi',
          priceRange: '\$\$\$\$',
          rating: 4.9,
        ),
        DestinationDining(
          id: 'ichiran-shinjuku',
          title: 'Ichiran Ramen',
          description: 'Signature tonkotsu ramen served in individual flavor-focus booths.',
          imageUrl: 'assets/images/spot_default.jpg',
          cuisine: 'Japanese Ramen',
          priceRange: '\$',
          rating: 4.8,
        ),
      ],
    ),
    DestinationModel(
      id: 'swiss-alps',
      name: 'Swiss Alps',
      country: 'Switzerland',
      tagline: 'Breathtaking peaks, alpine meadows, and pristine glacial lakes.',
      description:
          'The Swiss Alps encompass dramatic mountain ranges including the iconic Matterhorn and Jungfrau, featuring premier hiking trails, scenic cogwheel railways, and world-class ski resorts.',
      imageUrl: 'assets/images/swiss_alps.jpg',
      rating: 4.9,
      tags: ['Adventure', 'Nature', 'Mountains', 'Hiking'],
      bestTimeToVisit: 'June - September (Hiking), Dec - March (Skiing)',
      currency: 'CHF',
      spots: [
        DestinationSpot(
          id: 'matterhorn',
          title: 'The Matterhorn',
          description: 'One of the highest and most iconic alpine summits in Europe.',
          imageUrl: 'assets/images/matterhorn.jpg',
          category: 'Natural Wonder',
          rating: 4.9,
        ),
        DestinationSpot(
          id: 'jungfraujoch',
          title: 'Jungfraujoch - Top of Europe',
          description: 'Europe\'s highest altitude railway station with year-round ice palaces.',
          imageUrl: 'assets/images/swiss_alps.jpg',
          category: 'Excursion',
          rating: 4.8,
        ),
      ],
      dining: [
        DestinationDining(
          id: 'zermatt-fondue-stube',
          title: 'Walliserstube Zermatt',
          description: 'Traditional Swiss cheese fondue and raclette by an open fireplace.',
          imageUrl: 'assets/images/spot_default.jpg',
          cuisine: 'Traditional Swiss Alpine',
          priceRange: '\$\$\$',
          rating: 4.7,
        ),
      ],
    ),
    DestinationModel(
      id: 'rome',
      name: 'Rome',
      country: 'Italy',
      tagline: 'The Eternal City where ancient history and vibrant street life converge.',
      description:
          'Rome is Italy’s sprawling, cosmopolitan capital boasting nearly 3,000 years of globally influential art, architecture, and ruins such as the Colosseum and Roman Forum.',
      imageUrl: 'assets/images/rome.jpg',
      rating: 4.7,
      tags: ['Ancient History', 'Architecture', 'Pasta', 'Espresso'],
      bestTimeToVisit: 'September - November & April - May',
      currency: 'EUR',
      spots: [
        DestinationSpot(
          id: 'colosseum',
          title: 'The Colosseum',
          description: 'The monumental Flavian Amphitheatre of Imperial Roman gladiator games.',
          imageUrl: 'assets/images/colosseum.jpg',
          category: 'Ancient Ruins',
          rating: 4.8,
        ),
        DestinationSpot(
          id: 'trevi-fountain',
          title: 'Trevi Fountain',
          description: 'Baroque masterpiece fountain where travelers toss coins to ensure return.',
          imageUrl: 'assets/images/rome.jpg',
          category: 'Monument',
          rating: 4.7,
        ),
      ],
      dining: [
        DestinationDining(
          id: 'da-enzo-trastevere',
          title: 'Da Enzo al 29',
          description: 'Legendary Roman trattoria serving classic Carbonara and Cacio e Pepe.',
          imageUrl: 'assets/images/spot_default.jpg',
          cuisine: 'Roman Trattoria',
          priceRange: '\$\$',
          rating: 4.8,
        ),
      ],
    ),
  ];

  /// Helper to find a destination by name (case-insensitive search),
  /// falling back to creating a dynamic model if not found.
  static DestinationModel findByName(String name) {
    final cleanName = name.trim().toLowerCase();
    for (final dest in sampleDestinations) {
      if (dest.name.toLowerCase() == cleanName ||
          dest.id.toLowerCase() == cleanName ||
          cleanName.contains(dest.name.toLowerCase())) {
        return dest;
      }
    }
    // Fallback: create a dynamic destination with the provided name
    return DestinationModel(
      id: cleanName.replaceAll(' ', '-'),
      name: name,
      country: 'Global',
      tagline: 'Discover the wonders of $name.',
      description: 'Explore curated spots, cuisine, and itineraries in $name.',
      imageUrl: sampleDestinations.first.imageUrl,
      spots: sampleDestinations.first.spots,
      dining: sampleDestinations.first.dining,
    );
  }
}

/// Represents a specific point-of-interest, tourist attraction, or landmark.
class DestinationSpot {
  /// Unique identifier for the spot.
  final String id;

  /// Name / Title of the spot (e.g. "Eiffel Tower").
  final String title;

  /// Short description highlighting why visitors should go.
  final String description;

  /// Photo URL representing the attraction.
  final String imageUrl;

  /// Categorization (e.g., 'Landmark', 'Museum', 'Park', 'Historic').
  final String category;

  /// Average visitor rating.
  final double rating;

  const DestinationSpot({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.category = 'Attraction',
    this.rating = 4.5,
  });

  DestinationSpot copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    double? rating,
  }) {
    return DestinationSpot(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'category': category,
      'rating': rating,
    };
  }

  factory DestinationSpot.fromMap(Map<String, dynamic> map) {
    return DestinationSpot(
      id: (map['id'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      imageUrl: (map['image_url'] ?? map['imageUrl'] ?? '') as String,
      category: (map['category'] ?? 'Attraction') as String,
      rating: ((map['rating'] ?? 4.5) as num).toDouble(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory DestinationSpot.fromJson(String source) =>
      DestinationSpot.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DestinationSpot(id: $id, title: $title, category: $category)';
}

/// Represents a recommended dining spot, café, or restaurant at a destination.
class DestinationDining {
  /// Unique identifier for the dining establishment.
  final String id;

  /// Name of the restaurant/café (e.g., "Le Jules Verne").
  final String title;

  /// Short culinary summary or dining ambiance description.
  final String description;

  /// Photo URL representing the restaurant or its dishes.
  final String imageUrl;

  /// Type of cuisine (e.g., "French Bistro", "Authentic Ramen", "Roman Trattoria").
  final String cuisine;

  /// Price indicator ('$', '$$', '$$$', '$$$$').
  final String priceRange;

  /// Customer rating.
  final double rating;

  const DestinationDining({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.cuisine = 'Local Cuisine',
    this.priceRange = '\$\$',
    this.rating = 4.5,
  });

  DestinationDining copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? cuisine,
    String? priceRange,
    double? rating,
  }) {
    return DestinationDining(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cuisine: cuisine ?? this.cuisine,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'cuisine': cuisine,
      'price_range': priceRange,
      'rating': rating,
    };
  }

  factory DestinationDining.fromMap(Map<String, dynamic> map) {
    return DestinationDining(
      id: (map['id'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      imageUrl: (map['image_url'] ?? map['imageUrl'] ?? '') as String,
      cuisine: (map['cuisine'] ?? 'Local Cuisine') as String,
      priceRange: (map['price_range'] ?? map['priceRange'] ?? '\$\$') as String,
      rating: ((map['rating'] ?? 4.5) as num).toDouble(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory DestinationDining.fromJson(String source) =>
      DestinationDining.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DestinationDining(id: $id, title: $title, cuisine: $cuisine)';
}
