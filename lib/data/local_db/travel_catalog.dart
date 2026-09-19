/// Local SQLite Database Travel Catalog Models and Pre-seeded Data.
///
/// Supports Step 3 ("The App Searches Your Local Database") by providing
/// matching transport schedules, suggested hotels, key spot sightseeing details,
/// and nearby lunch and dinner spots.
library;

class CatalogTransport {
  final String id;
  final String destination;
  final String mode; // 'Train', 'Flight', 'Bus', 'Car'
  final String title;
  final String description;
  final double cost;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  const CatalogTransport({
    required this.id,
    required this.destination,
    required this.mode,
    required this.title,
    required this.description,
    required this.cost,
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 11,
    this.endMinute = 30,
  });
}

class CatalogHotel {
  final String id;
  final String destination;
  final String name;
  final String description;
  final double costPerNight;
  final int checkInHour;
  final int checkInMinute;
  final int checkOutHour;
  final int checkOutMinute;

  const CatalogHotel({
    required this.id,
    required this.destination,
    required this.name,
    required this.description,
    required this.costPerNight,
    this.checkInHour = 14,
    this.checkInMinute = 0,
    this.checkOutHour = 11,
    this.checkOutMinute = 0,
  });
}

class CatalogSpot {
  final String id;
  final String destination;
  final String name;
  final String description;
  final double entryFee;
  final int durationMinutes;
  final List<String> keywords;

  const CatalogSpot({
    required this.id,
    required this.destination,
    required this.name,
    required this.description,
    required this.entryFee,
    this.durationMinutes = 120,
    this.keywords = const [],
  });
}

class CatalogDining {
  final String id;
  final String destination;
  final String mealType; // 'Lunch', 'Dinner', 'Breakfast'
  final String restaurantName;
  final String description;
  final double averageCost;

  const CatalogDining({
    required this.id,
    required this.destination,
    required this.mealType,
    required this.restaurantName,
    required this.description,
    required this.averageCost,
  });
}

/// Pre-seeded SQLite-ready travel catalog for destinations.
class TravelCatalog {
  // Transports
  static const List<CatalogTransport> transports = [
    // Paris
    CatalogTransport(
      id: 'trans-paris-train',
      destination: 'Paris',
      mode: 'Train',
      title: 'Train to Paris (Eurostar High-Speed)',
      description: 'Eurostar Express departing St Pancras / Central Station to Gare du Nord. Reserved seat in Coach 4.',
      cost: 75.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-paris-flight',
      destination: 'Paris',
      mode: 'Flight',
      title: 'Flight to Paris (Air France AF102)',
      description: 'Direct flight arriving at Paris Charles de Gaulle (CDG) Terminal 2E.',
      cost: 165.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    // Rome
    CatalogTransport(
      id: 'trans-rome-train',
      destination: 'Rome',
      mode: 'Train',
      title: 'Train to Rome (Frecciarossa High-Speed)',
      description: 'High-speed express rail arriving at Roma Termini Station, Coach 2 Standard Class.',
      cost: 65.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-rome-flight',
      destination: 'Rome',
      mode: 'Flight',
      title: 'Flight to Rome (ITA Airways IT410)',
      description: 'Morning commercial flight arriving at Leonardo da Vinci–Fiumicino Airport.',
      cost: 150.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    // Tokyo
    CatalogTransport(
      id: 'trans-tokyo-train',
      destination: 'Tokyo',
      mode: 'Train',
      title: 'Train to Tokyo (Shinkansen Bullet Train)',
      description: 'Tokaido-Sanyo Shinkansen high-speed bullet train arriving at Tokyo Station.',
      cost: 95.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-tokyo-flight',
      destination: 'Tokyo',
      mode: 'Flight',
      title: 'Flight to Tokyo (ANA Flight NH204)',
      description: 'International flight arriving at Haneda Airport (HND) Terminal 3.',
      cost: 280.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    // Swiss Alps
    CatalogTransport(
      id: 'trans-swiss-train',
      destination: 'Swiss Alps',
      mode: 'Train',
      title: 'Train to Swiss Alps (Glacier Scenic Express)',
      description: 'Panoramic alpine mountain railway journey into Zermatt / Interlaken station.',
      cost: 85.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-swiss-flight',
      destination: 'Swiss Alps',
      mode: 'Flight',
      title: 'Flight to Swiss Alps (Swiss Air LX348)',
      description: 'Scheduled flight into Zurich Airport with onward SBB train transfer.',
      cost: 190.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
  ];

  // Hotels
  static const List<CatalogHotel> hotels = [
    // Paris
    CatalogHotel(
      id: 'hotel-paris-1',
      destination: 'Paris',
      name: 'Hôtel Le Grand Paris',
      description: 'Boutique stay near Saint-Germain with comfortable designer rooms and city views.',
      costPerNight: 160.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    CatalogHotel(
      id: 'hotel-paris-2',
      destination: 'Paris',
      name: 'Hôtel Eiffel Seine',
      description: 'Art Nouveau hotel located a short 5-minute walk from the Eiffel Tower and Seine river.',
      costPerNight: 190.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    // Rome
    CatalogHotel(
      id: 'hotel-rome-1',
      destination: 'Rome',
      name: 'Hotel Colosseum Palace',
      description: 'Historic boutique hotel overlooking Roman ruins with a panoramic rooftop terrace.',
      costPerNight: 145.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    // Tokyo
    CatalogHotel(
      id: 'hotel-tokyo-1',
      destination: 'Tokyo',
      name: 'Shinjuku Prince Hotel',
      description: 'Sleek modern tower hotel situated directly in vibrant Shinjuku entertainment district.',
      costPerNight: 175.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    // Swiss Alps
    CatalogHotel(
      id: 'hotel-swiss-1',
      destination: 'Swiss Alps',
      name: 'Matterhorn Alpine Chalet',
      description: 'Cozy timber chalet lodge with stunning balcony views of the Matterhorn peak.',
      costPerNight: 210.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
  ];

  // Sightseeing Spots
  static const List<CatalogSpot> spots = [
    // Paris
    CatalogSpot(
      id: 'spot-paris-eiffel',
      destination: 'Paris',
      name: 'Eiffel Tower',
      description: 'Ascend Gustave Eiffel\'s world-famous iron lattice tower for breathtaking panoramic views of Paris.',
      entryFee: 32.0,
      durationMinutes: 120,
      keywords: ['eiffel', 'tower', 'toureiffel', 'summit'],
    ),
    CatalogSpot(
      id: 'spot-paris-louvre',
      destination: 'Paris',
      name: 'Louvre Museum',
      description: 'Explore the world\'s largest art museum, home to Da Vinci\'s Mona Lisa and the Venus de Milo.',
      entryFee: 22.0,
      durationMinutes: 150,
      keywords: ['louvre', 'museum', 'art', 'mona lisa'],
    ),
    CatalogSpot(
      id: 'spot-paris-notre-dame',
      destination: 'Paris',
      name: 'Notre-Dame & Île de la Cité',
      description: 'Stroll through the medieval heart of Paris along the Seine river banks and majestic cathedral square.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['notre-dame', 'notredame', 'seine', 'cathedral'],
    ),
    CatalogSpot(
      id: 'spot-paris-arc',
      destination: 'Paris',
      name: 'Arc de Triomphe & Champs-Élysées',
      description: 'Visit the historic monument honoring French history and walk down the world\'s most famous avenue.',
      entryFee: 16.0,
      durationMinutes: 90,
      keywords: ['arc', 'triomphe', 'champs', 'elysees'],
    ),

    // Rome
    CatalogSpot(
      id: 'spot-rome-colosseum',
      destination: 'Rome',
      name: 'Colosseum & Roman Forum',
      description: 'Walk through the gladiatorial amphitheater and the ancient political center of the Roman Empire.',
      entryFee: 28.0,
      durationMinutes: 150,
      keywords: ['colosseum', 'forum', 'gladiator', 'ruins'],
    ),
    CatalogSpot(
      id: 'spot-rome-vatican',
      destination: 'Rome',
      name: 'Vatican Museums & St. Peter\'s',
      description: 'Discover Michelangelo\'s Sistine Chapel ceiling and the Renaissance splendor of St. Peter\'s Basilica.',
      entryFee: 25.0,
      durationMinutes: 180,
      keywords: ['vatican', 'sistine', 'peters', 'chapel'],
    ),
    CatalogSpot(
      id: 'spot-rome-trevi',
      destination: 'Rome',
      name: 'Trevi Fountain & Spanish Steps',
      description: 'Toss a coin into Rome\'s iconic baroque fountain and enjoy gelato on the Piazza di Spagna.',
      entryFee: 0.0,
      durationMinutes: 60,
      keywords: ['trevi', 'fountain', 'spanish', 'steps'],
    ),

    // Tokyo
    CatalogSpot(
      id: 'spot-tokyo-shibuya',
      destination: 'Tokyo',
      name: 'Shibuya Crossing & Sky Observatory',
      description: 'Experience the world\'s busiest pedestrian intersection and 360-degree skyline views from Shibuya Sky.',
      entryFee: 18.0,
      durationMinutes: 120,
      keywords: ['shibuya', 'crossing', 'sky', 'observatory'],
    ),
    CatalogSpot(
      id: 'spot-tokyo-sensoji',
      destination: 'Tokyo',
      name: 'Senso-ji Temple & Asakusa',
      description: 'Tokyo\'s oldest and most revered Buddhist temple with its vibrant Nakamise shopping arcade.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['sensoji', 'senso-ji', 'asakusa', 'temple'],
    ),
    CatalogSpot(
      id: 'spot-tokyo-akihabara',
      destination: 'Tokyo',
      name: 'Akihabara Electric Town',
      description: 'Hub for Japanese gaming, anime culture, electronic boutiques, and themed cafes.',
      entryFee: 0.0,
      durationMinutes: 120,
      keywords: ['akihabara', 'anime', 'tech', 'electronics'],
    ),

    // Swiss Alps
    CatalogSpot(
      id: 'spot-swiss-matterhorn',
      destination: 'Swiss Alps',
      name: 'Matterhorn Glacier Paradise',
      description: 'Europe\'s highest mountain cable car station offering year-round snow and jaw-dropping alpine vistas.',
      entryFee: 85.0,
      durationMinutes: 180,
      keywords: ['matterhorn', 'glacier', 'mountain', 'cable car', 'zermatt'],
    ),
    CatalogSpot(
      id: 'spot-swiss-jungfrau',
      destination: 'Swiss Alps',
      name: 'Jungfraujoch - Top of Europe',
      description: 'Cogwheel train journey up into the high alpine glacier wonderland with ice sculptures.',
      entryFee: 95.0,
      durationMinutes: 200,
      keywords: ['jungfrau', 'jungfraujoch', 'alps', 'train'],
    ),
  ];

  // Dining
  static const List<CatalogDining> dinings = [
    // Paris
    CatalogDining(
      id: 'dine-paris-lunch-1',
      destination: 'Paris',
      mealType: 'Lunch',
      restaurantName: 'Le Bistrot Parisien',
      description: 'Traditional Parisian brasserie serving croque-monsieur, duck rillettes, and fresh baguettes.',
      averageCost: 28.0,
    ),
    CatalogDining(
      id: 'dine-paris-dinner-1',
      destination: 'Paris',
      mealType: 'Dinner',
      restaurantName: 'Café de Flore French Dining',
      description: 'Historic Saint-Germain landmark offering beef bourguignon, French onion soup, and vintage wine.',
      averageCost: 48.0,
    ),
    CatalogDining(
      id: 'dine-paris-lunch-2',
      destination: 'Paris',
      mealType: 'Lunch',
      restaurantName: 'Chez Janou Provençal Bistro',
      description: 'Charming Marais bistro serving southern French ratatouille and unlimited artisanal chocolate mousse.',
      averageCost: 32.0,
    ),
    CatalogDining(
      id: 'dine-paris-dinner-2',
      destination: 'Paris',
      mealType: 'Dinner',
      restaurantName: 'L\'Ambroisie Classical Dining',
      description: 'Michelin-level French haute cuisine featuring roasted sea bass, escargot, and delicate pastries.',
      averageCost: 65.0,
    ),

    // Rome
    CatalogDining(
      id: 'dine-rome-lunch-1',
      destination: 'Rome',
      mealType: 'Lunch',
      restaurantName: 'Trattoria Da Enzo al 29',
      description: 'Cozy Roman trattoria renowned for authentic carbonara, cacio e pepe, and fried artichokes.',
      averageCost: 24.0,
    ),
    CatalogDining(
      id: 'dine-rome-dinner-1',
      destination: 'Rome',
      mealType: 'Dinner',
      restaurantName: 'Ristorante Aroma at Colosseum',
      description: 'Fine dining terrace with direct floodlit views of the Colosseum and classic Italian courses.',
      averageCost: 55.0,
    ),
    CatalogDining(
      id: 'dine-rome-lunch-2',
      destination: 'Rome',
      mealType: 'Lunch',
      restaurantName: 'Pizzeria Da Baffetto',
      description: 'Crisp wood-fired thin-crust Roman pizza paired with Peroni draft beer.',
      averageCost: 18.0,
    ),
    CatalogDining(
      id: 'dine-rome-dinner-2',
      destination: 'Rome',
      mealType: 'Dinner',
      restaurantName: 'Osteria Barberini',
      description: 'Intimate dining spot famed for seasonal fresh black truffle pasta and Roman veal saltimbocca.',
      averageCost: 45.0,
    ),

    // Tokyo
    CatalogDining(
      id: 'dine-tokyo-lunch-1',
      destination: 'Tokyo',
      mealType: 'Lunch',
      restaurantName: 'Ichiran Ramen Shibuya',
      description: 'Classic rich tonkotsu pork broth ramen served in private flavor concentration booths.',
      averageCost: 16.0,
    ),
    CatalogDining(
      id: 'dine-tokyo-dinner-1',
      destination: 'Tokyo',
      mealType: 'Dinner',
      restaurantName: 'Gonpachi Nishi-Azabu (Kill Bill Restaurant)',
      description: 'Atmospheric izakaya serving charcoal-grilled yakitori, handmade soba, and premium sake.',
      averageCost: 42.0,
    ),
    CatalogDining(
      id: 'dine-tokyo-lunch-2',
      destination: 'Tokyo',
      mealType: 'Lunch',
      restaurantName: 'Tsukiji Fish Market Sushi Dai',
      description: 'Ultra-fresh morning sashimi and nigiri sushi selected directly from Tokyo seafood docks.',
      averageCost: 35.0,
    ),
    CatalogDining(
      id: 'dine-tokyo-dinner-2',
      destination: 'Tokyo',
      mealType: 'Dinner',
      restaurantName: 'Rokkasen Yakiniku Shinjuku',
      description: 'Premium melt-in-the-mouth Matsusaka Wagyu beef barbecue grilled right at your table.',
      averageCost: 65.0,
    ),

    // Swiss Alps
    CatalogDining(
      id: 'dine-swiss-lunch-1',
      destination: 'Swiss Alps',
      mealType: 'Lunch',
      restaurantName: 'Chez Vrony Alpine Hut',
      description: 'Rustic rustic chalet perched at 2,100m offering traditional rösti, cured meats, and local cheese.',
      averageCost: 38.0,
    ),
    CatalogDining(
      id: 'dine-swiss-dinner-1',
      destination: 'Swiss Alps',
      mealType: 'Dinner',
      restaurantName: 'Walliserkanne Fondue Stübli',
      description: 'Traditional wood-paneled tavern serving bubbling Swiss Gruyère cheese fondue and Valais wines.',
      averageCost: 52.0,
    ),
  ];
}
