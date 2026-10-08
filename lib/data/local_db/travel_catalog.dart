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
  // Transports (Calculated in INR ₹)
  static const List<CatalogTransport> transports = [
    // Paris
    CatalogTransport(
      id: 'trans-paris-train',
      destination: 'Paris',
      mode: 'Train',
      title: 'Train to Paris (Eurostar High-Speed)',
      description: 'Eurostar Express departing St Pancras / Central Station to Gare du Nord. Reserved seat in Coach 4.',
      cost: 4500.0,
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
      cost: 8500.0,
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
      cost: 3800.0,
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
      cost: 7500.0,
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
      cost: 4800.0,
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
      cost: 9800.0,
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
      description: 'Panoramic glass-dome train ride from Zurich into Zermatt village terminal.',
      cost: 5200.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-swiss-flight',
      destination: 'Swiss Alps',
      mode: 'Flight',
      title: 'Flight to Swiss Alps (Swiss Air LX318)',
      description: 'Morning scenic arrival at Zurich / Geneva airport with connecting mountain rail.',
      cost: 10500.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),

    // Goa, India
    CatalogTransport(
      id: 'trans-goa-train',
      destination: 'Goa',
      mode: 'Train',
      title: 'Train to Goa (Konkan Kanya Express)',
      description: 'Scenic journey through the Western Ghats and Konkan coastline arriving at Madgaon Junction.',
      cost: 1650.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-goa-flight',
      destination: 'Goa',
      mode: 'Flight',
      title: 'Flight to Goa (IndiGo Coastal Express)',
      description: 'Direct domestic flight arriving at Dabolim / Mopa International Airport.',
      cost: 3800.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),

    // Jaipur, India
    CatalogTransport(
      id: 'trans-jaipur-train',
      destination: 'Jaipur',
      mode: 'Train',
      title: 'Train to Jaipur (Vande Bharat Express)',
      description: 'Ultra-fast semi-high speed express with executive chair car arriving at Jaipur Junction.',
      cost: 1450.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-jaipur-flight',
      destination: 'Jaipur',
      mode: 'Flight',
      title: 'Flight to Jaipur (Air India AI491)',
      description: 'Morning domestic flight arriving at Jaipur International Airport Terminal 2.',
      cost: 3200.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),

    // Manali, India
    CatalogTransport(
      id: 'trans-manali-train',
      destination: 'Manali',
      mode: 'Train',
      title: 'Overnight Volvo Coach to Manali',
      description: 'Luxury AC multi-axle sleeper coach ascending through the Beas river valley.',
      cost: 1750.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-manali-flight',
      destination: 'Manali',
      mode: 'Flight',
      title: 'Mountain Flight to Kullu-Manali (Bhuntar)',
      description: 'Scenic turboprop mountain flight touching down at Bhuntar Airport near Manali.',
      cost: 4800.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),

    // Kerala, India
    CatalogTransport(
      id: 'trans-kerala-train',
      destination: 'Kerala',
      mode: 'Train',
      title: 'Train to Kerala (Vande Bharat Express)',
      description: 'Scenic journey through coastal backwaters arriving at Ernakulam / Cochin Junction.',
      cost: 1850.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
    CatalogTransport(
      id: 'trans-kerala-flight',
      destination: 'Kerala',
      mode: 'Flight',
      title: 'Flight to Kochi, Kerala (IndiGo 6E)',
      description: 'Direct flight landing at Cochin International Airport (COK).',
      cost: 4200.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    ),
  ];

  // Hotels (Calculated in INR ₹ per night)
  static const List<CatalogHotel> hotels = [
    // Paris
    CatalogHotel(
      id: 'hotel-paris-1',
      destination: 'Paris',
      name: 'Hôtel Le Grand Paris',
      description: 'Boutique stay near Saint-Germain with comfortable designer rooms and city views.',
      costPerNight: 6500.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    CatalogHotel(
      id: 'hotel-paris-2',
      destination: 'Paris',
      name: 'Hôtel Eiffel Seine',
      description: 'Art Nouveau hotel located a short 5-minute walk from the Eiffel Tower and Seine river.',
      costPerNight: 8500.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    // Rome
    CatalogHotel(
      id: 'hotel-rome-1',
      destination: 'Rome',
      name: 'Hotel Colosseum Palace',
      description: 'Historic boutique hotel overlooking Roman ruins with a panoramic rooftop terrace.',
      costPerNight: 5500.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    // Tokyo
    CatalogHotel(
      id: 'hotel-tokyo-1',
      destination: 'Tokyo',
      name: 'Shinjuku Prince Hotel',
      description: 'Sleek modern tower hotel situated directly in vibrant Shinjuku entertainment district.',
      costPerNight: 6800.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    // Swiss Alps
    CatalogHotel(
      id: 'hotel-swiss-1',
      destination: 'Swiss Alps',
      name: 'Matterhorn Alpine Chalet',
      description: 'Cozy timber chalet lodge with stunning balcony views of the Matterhorn peak.',
      costPerNight: 9500.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),

    // Goa, India
    CatalogHotel(
      id: 'hotel-goa-1',
      destination: 'Goa',
      name: 'Taj Coastal Beach Resort',
      description: 'Premium beachside property with private cabanas, tropical gardens, and sea view villas.',
      costPerNight: 5200.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    CatalogHotel(
      id: 'hotel-goa-2',
      destination: 'Goa',
      name: 'Candolim Heritage Boutique Stay',
      description: 'Charming Portuguese-style heritage villa with outdoor pool and close walk to beach shacks.',
      costPerNight: 3500.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),

    // Jaipur, India
    CatalogHotel(
      id: 'hotel-jaipur-1',
      destination: 'Jaipur',
      name: 'Rambagh Heritage Palace',
      description: 'Aristocratic Rajput architecture, landscaped Mughal gardens, and royal hospitality.',
      costPerNight: 5800.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
    CatalogHotel(
      id: 'hotel-jaipur-2',
      destination: 'Jaipur',
      name: 'Jaipur Royal Haveli Stay',
      description: 'Traditional carved haveli with courtyard dining, jharokha balconies, and folk performances.',
      costPerNight: 3400.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),

    // Manali, India
    CatalogHotel(
      id: 'hotel-manali-1',
      destination: 'Manali',
      name: 'Himalayan Pine Valley Resort',
      description: 'Mountain facing wooden luxury suites overlooking snow-clad peaks and pine forests.',
      costPerNight: 3800.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),

    // Kerala, India
    CatalogHotel(
      id: 'hotel-kerala-1',
      destination: 'Kerala',
      name: 'Kumarakom Backwater Lake Resort',
      description: 'Waterfront luxury retreat with infinity pool, traditional Ayurvedic spa, and canal views.',
      costPerNight: 5500.0,
      checkInHour: 14,
      checkInMinute: 0,
    ),
  ];

  // Sightseeing Spots (Calculated in INR ₹ entry fee)
  static const List<CatalogSpot> spots = [
    // Paris, France
    CatalogSpot(
      id: 'spot-paris-eiffel',
      destination: 'Paris',
      name: 'Eiffel Tower',
      description: 'Ascend Gustave Eiffel\'s world-famous iron lattice tower for breathtaking panoramic views of Paris.',
      entryFee: 2200.0,
      durationMinutes: 120,
      keywords: ['eiffel', 'tower', 'toureiffel', 'summit'],
    ),
    CatalogSpot(
      id: 'spot-paris-louvre',
      destination: 'Paris',
      name: 'Louvre Art Museum',
      description: 'Explore the world\'s largest art museum, home to Da Vinci\'s Mona Lisa and the Venus de Milo.',
      entryFee: 1600.0,
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
      entryFee: 1200.0,
      durationMinutes: 90,
      keywords: ['arc', 'triomphe', 'champs', 'elysees'],
    ),
    CatalogSpot(
      id: 'spot-paris-montmartre',
      destination: 'Paris',
      name: 'Montmartre & Sacré-Cœur Basilica',
      description: 'Historic hilltop bohemian artists quarter overlooking the Parisian skyline with street painters.',
      entryFee: 0.0,
      durationMinutes: 120,
      keywords: ['montmartre', 'sacre', 'coeur', 'basilica', 'bohemian'],
    ),
    CatalogSpot(
      id: 'spot-paris-orsay',
      destination: 'Paris',
      name: 'Musée d\'Orsay Impressionist Art',
      description: 'Renowned Beaux-Arts railway station housing masterpieces by Monet, Van Gogh, and Renoir.',
      entryFee: 1400.0,
      durationMinutes: 120,
      keywords: ['orsay', 'art', 'monet', 'van gogh', 'impressionist'],
    ),
    CatalogSpot(
      id: 'spot-paris-seine',
      destination: 'Paris',
      name: 'Seine River Scenic Cruise',
      description: 'Glide past floodlit bridges, the Grand Palais, and historic landmarks on an evening river cruise.',
      entryFee: 1300.0,
      durationMinutes: 75,
      keywords: ['seine', 'river', 'cruise', 'boat', 'bridges'],
    ),
    CatalogSpot(
      id: 'spot-paris-sainte-chapelle',
      destination: 'Paris',
      name: 'Sainte-Chapelle Royal Gothic Stained Glass',
      description: 'Marvel at 1,113 brilliant 13th-century stained-glass panels inside the former royal residence.',
      entryFee: 1100.0,
      durationMinutes: 60,
      keywords: ['sainte', 'chapelle', 'stained', 'glass', 'gothic'],
    ),
    CatalogSpot(
      id: 'spot-paris-versailles',
      destination: 'Paris',
      name: 'Palace of Versailles & Royal Gardens',
      description: 'Opulent hall of mirrors, gilded staterooms, and sprawling fountain gardens of the Sun King.',
      entryFee: 2400.0,
      durationMinutes: 200,
      keywords: ['versailles', 'palace', 'gardens', 'mirrors', 'chateau'],
    ),
    CatalogSpot(
      id: 'spot-paris-luxembourg',
      destination: 'Paris',
      name: 'Jardin du Luxembourg & Latin Quarter',
      description: 'Relax in peaceful Medici fountain gardens and wander charming student alleys of the Left Bank.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['luxembourg', 'gardens', 'latin quarter', 'fountain'],
    ),

    // Rome, Italy
    CatalogSpot(
      id: 'spot-rome-colosseum',
      destination: 'Rome',
      name: 'Colosseum & Roman Forum',
      description: 'Walk through the gladiatorial amphitheater and the ancient political center of the Roman Empire.',
      entryFee: 1800.0,
      durationMinutes: 150,
      keywords: ['colosseum', 'forum', 'gladiator', 'ruins'],
    ),
    CatalogSpot(
      id: 'spot-rome-vatican',
      destination: 'Rome',
      name: 'Vatican Museums & Sistine Chapel',
      description: 'Discover Michelangelo\'s Sistine Chapel ceiling and the Renaissance splendor of St. Peter\'s Basilica.',
      entryFee: 1900.0,
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
    CatalogSpot(
      id: 'spot-rome-pantheon',
      destination: 'Rome',
      name: 'Pantheon & Piazza Navona',
      description: 'Ancient Roman temple with its colossal concrete dome and Bernini\'s Four Rivers Fountain.',
      entryFee: 450.0,
      durationMinutes: 90,
      keywords: ['pantheon', 'navona', 'bernini', 'fountain', 'dome'],
    ),
    CatalogSpot(
      id: 'spot-rome-castel',
      destination: 'Rome',
      name: 'Castel Sant\'Angelo & Tiber Bridge',
      description: 'Historic cylindrical fortress and mausoleum offering panoramic vistas over the Vatican and river.',
      entryFee: 1300.0,
      durationMinutes: 90,
      keywords: ['castel', 'angelo', 'tiber', 'fortress'],
    ),
    CatalogSpot(
      id: 'spot-rome-borghese',
      destination: 'Rome',
      name: 'Villa Borghese Gardens & Gallery',
      description: 'Stately park with Bernini sculptures, Caravaggio paintings, and peaceful rowboat lake.',
      entryFee: 1400.0,
      durationMinutes: 120,
      keywords: ['borghese', 'gallery', 'sculpture', 'gardens'],
    ),
    CatalogSpot(
      id: 'spot-rome-trastevere',
      destination: 'Rome',
      name: 'Trastevere Medieval Cobblestone Stroll',
      description: 'Lively bohemian neighborhood with ivy-clad trattorias, street buskers, and artisan craft shops.',
      entryFee: 0.0,
      durationMinutes: 100,
      keywords: ['trastevere', 'cobblestone', 'artisan', 'nightlife'],
    ),
    CatalogSpot(
      id: 'spot-rome-capitoline',
      destination: 'Rome',
      name: 'Capitoline Museums & Piazza del Campidoglio',
      description: 'Michelangelo-designed hilltop piazza housing classical bronzes, marble busts, and Roman history.',
      entryFee: 1200.0,
      durationMinutes: 100,
      keywords: ['capitoline', 'campidoglio', 'bronze', 'museum'],
    ),
    CatalogSpot(
      id: 'spot-rome-catacombs',
      destination: 'Rome',
      name: 'Catacombs of San Callisto & Appian Way',
      description: 'Underground subterranean crypts and ancient Roman cobblestones surrounded by cypress trees.',
      entryFee: 900.0,
      durationMinutes: 110,
      keywords: ['catacombs', 'callisto', 'appian', 'crypts'],
    ),
    CatalogSpot(
      id: 'spot-rome-piazza-popolo',
      destination: 'Rome',
      name: 'Piazza del Popolo & Pincio Terrace',
      description: 'Neoclassical square with twin churches and sunset viewpoint looking across Rome\'s domes.',
      entryFee: 0.0,
      durationMinutes: 60,
      keywords: ['popolo', 'pincio', 'terrace', 'viewpoint'],
    ),

    // Tokyo, Japan
    CatalogSpot(
      id: 'spot-tokyo-shibuya',
      destination: 'Tokyo',
      name: 'Shibuya Crossing & Sky Observatory',
      description: 'Experience the world\'s busiest pedestrian intersection and 360-degree skyline views from Shibuya Sky.',
      entryFee: 1200.0,
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
    CatalogSpot(
      id: 'spot-tokyo-skytree',
      destination: 'Tokyo',
      name: 'Tokyo Skytree Tower',
      description: 'World\'s tallest broadcasting tower with glass-floor observation decks towering 634 meters.',
      entryFee: 1800.0,
      durationMinutes: 110,
      keywords: ['skytree', 'tower', 'observation', 'skyline'],
    ),
    CatalogSpot(
      id: 'spot-tokyo-meiji',
      destination: 'Tokyo',
      name: 'Meiji Jingu Shrine & Harajuku',
      description: 'Tranquil forested Shinto shrine adjoining the youth fashion and crepe shops of Takeshita Street.',
      entryFee: 0.0,
      durationMinutes: 100,
      keywords: ['meiji', 'shrine', 'harajuku', 'takeshita'],
    ),
    CatalogSpot(
      id: 'spot-tokyo-shinjuku-gyoen',
      destination: 'Tokyo',
      name: 'Shinjuku Gyoen National Garden',
      description: 'Sprawling Imperial landscape garden featuring traditional Japanese, English, and French pavilions.',
      entryFee: 300.0,
      durationMinutes: 90,
      keywords: ['shinjuku', 'gyoen', 'garden', 'cherry blossom'],
    ),
    CatalogSpot(
      id: 'spot-tokyo-tsukiji',
      destination: 'Tokyo',
      name: 'Tsukiji Outer Seafood Market',
      description: 'Vibrant street food stalls serving fresh sushi, grilled scallops, tamagoyaki, and matcha desserts.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['tsukiji', 'market', 'sushi', 'street food'],
    ),
    CatalogSpot(
      id: 'spot-tokyo-odaiba',
      destination: 'Tokyo',
      name: 'Odaiba Bay & Rainbow Bridge',
      description: 'Futuristic waterfront entertainment island featuring giant Gundam statue and seaside park.',
      entryFee: 0.0,
      durationMinutes: 110,
      keywords: ['odaiba', 'rainbow bridge', 'gundam', 'bay'],
    ),
    CatalogSpot(
      id: 'spot-tokyo-ueno',
      destination: 'Tokyo',
      name: 'Ueno Park & Tokyo National Museum',
      description: 'Cultural park hosting Japan\'s oldest and largest museum of samurai armor and ancient treasures.',
      entryFee: 600.0,
      durationMinutes: 120,
      keywords: ['ueno', 'museum', 'samurai', 'park'],
    ),
    CatalogSpot(
      id: 'spot-tokyo-roppongi',
      destination: 'Tokyo',
      name: 'Roppongi Hills & Tokyo City View',
      description: 'Modern art complex and Mori Art Museum with open-air rooftop deck gazing at Tokyo Tower.',
      entryFee: 1200.0,
      durationMinutes: 90,
      keywords: ['roppongi', 'mori', 'tokyo tower', 'city view'],
    ),

    // Swiss Alps
    CatalogSpot(
      id: 'spot-swiss-matterhorn',
      destination: 'Swiss Alps',
      name: 'Matterhorn Glacier Paradise',
      description: 'Europe\'s highest mountain cable car station offering year-round snow and jaw-dropping alpine vistas.',
      entryFee: 3500.0,
      durationMinutes: 180,
      keywords: ['matterhorn', 'glacier', 'mountain', 'cable car', 'zermatt'],
    ),
    CatalogSpot(
      id: 'spot-swiss-jungfrau',
      destination: 'Swiss Alps',
      name: 'Jungfraujoch - Top of Europe',
      description: 'Cogwheel train journey up into the high alpine glacier wonderland with ice sculptures.',
      entryFee: 4000.0,
      durationMinutes: 200,
      keywords: ['jungfrau', 'jungfraujoch', 'alps', 'train'],
    ),
    CatalogSpot(
      id: 'spot-swiss-pilatus',
      destination: 'Swiss Alps',
      name: 'Mount Pilatus Golden Round Trip',
      description: 'World\'s steepest cogwheel railway and scenic cableways ascending above Lake Lucerne.',
      entryFee: 3200.0,
      durationMinutes: 180,
      keywords: ['pilatus', 'lucerne', 'cogwheel', 'lake'],
    ),
    CatalogSpot(
      id: 'spot-swiss-interlaken',
      destination: 'Swiss Alps',
      name: 'Interlaken & Harder Kulm Panorama',
      description: 'Funicular railway up to two-lakes bridge view of Lake Thun, Lake Brienz, and the Eiger peak.',
      entryFee: 1800.0,
      durationMinutes: 120,
      keywords: ['interlaken', 'harder', 'kulm', 'thun', 'brienz'],
    ),
    CatalogSpot(
      id: 'spot-swiss-grindelwald',
      destination: 'Swiss Alps',
      name: 'Grindelwald First Cliff Walk',
      description: 'Suspended metal walkway along sheer rock cliffs and panoramic views of alpine pastures.',
      entryFee: 2600.0,
      durationMinutes: 150,
      keywords: ['grindelwald', 'first', 'cliff', 'walk', 'bridge'],
    ),
    CatalogSpot(
      id: 'spot-swiss-lauterbrunnen',
      destination: 'Swiss Alps',
      name: 'Lauterbrunnen Valley of 72 Waterfalls',
      description: 'Fairytale glacial valley with towering cliffs and Staubbach Falls thundering down into the village.',
      entryFee: 0.0,
      durationMinutes: 120,
      keywords: ['lauterbrunnen', 'waterfall', 'staubbach', 'valley'],
    ),
    CatalogSpot(
      id: 'spot-swiss-lucerne-bridge',
      destination: 'Swiss Alps',
      name: 'Lucerne Chapel Bridge & Water Tower',
      description: 'Iconic 14th-century wooden footbridge spanning the Reuss River with medieval paintings.',
      entryFee: 0.0,
      durationMinutes: 60,
      keywords: ['lucerne', 'chapel bridge', 'reuss', 'tower'],
    ),
    CatalogSpot(
      id: 'spot-swiss-zermatt-village',
      destination: 'Swiss Alps',
      name: 'Zermatt Alpine Village & Gornergrat',
      description: 'Car-free mountain resort village with Gornergrat scenic railway framing the Matterhorn pyramid.',
      entryFee: 2800.0,
      durationMinutes: 160,
      keywords: ['zermatt', 'gornergrat', 'village', 'matterhorn'],
    ),
    CatalogSpot(
      id: 'spot-swiss-rhine-falls',
      destination: 'Swiss Alps',
      name: 'Rhine Falls Boat & Rock Exploration',
      description: 'Europe\'s most powerful waterfall with boat ride taking passengers to the central roaring rock.',
      entryFee: 1200.0,
      durationMinutes: 90,
      keywords: ['rhine', 'falls', 'waterfall', 'boat'],
    ),
    CatalogSpot(
      id: 'spot-swiss-geneva-lake',
      destination: 'Swiss Alps',
      name: 'Chillon Castle & Lake Geneva Shoreline',
      description: 'Medieval lakeside fortress immortalized by Lord Byron, surrounded by Swiss Riviera vineyards.',
      entryFee: 1400.0,
      durationMinutes: 110,
      keywords: ['chillon', 'castle', 'geneva', 'montreux'],
    ),

    // Goa, India
    CatalogSpot(
      id: 'spot-goa-baga',
      destination: 'Goa',
      name: 'Baga Beach & Watersports',
      description: 'Golden sandy beach popular for parasailing, jet skiing, beach shacks, and vibrant coastal music.',
      entryFee: 800.0,
      durationMinutes: 150,
      keywords: ['baga', 'beach', 'sea', 'watersports'],
    ),
    CatalogSpot(
      id: 'spot-goa-basilica',
      destination: 'Goa',
      name: 'Basilica of Bom Jesus',
      description: 'UNESCO World Heritage baroque church holding the sacred relics of St. Francis Xavier in Old Goa.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['basilica', 'church', 'bom jesus', 'old goa'],
    ),
    CatalogSpot(
      id: 'spot-goa-aguada',
      destination: 'Goa',
      name: 'Fort Aguada & Lighthouse',
      description: '17th-century Portuguese fortress overlooking the Arabian Sea with panoramic sunset views.',
      entryFee: 150.0,
      durationMinutes: 90,
      keywords: ['aguada', 'fort', 'lighthouse', 'sea'],
    ),
    CatalogSpot(
      id: 'spot-goa-dudhsagar',
      destination: 'Goa',
      name: 'Dudhsagar Waterfalls & Jeep Safari',
      description: 'Majestic four-tiered milky waterfall inside Bhagwan Mahaveer Sanctuary with jungle jeep trek.',
      entryFee: 1200.0,
      durationMinutes: 200,
      keywords: ['dudhsagar', 'waterfall', 'safari', 'jeep', 'falls'],
    ),
    CatalogSpot(
      id: 'spot-goa-chapora',
      destination: 'Goa',
      name: 'Chapora Fort & Vagator Cliffs',
      description: 'Scenic hilltop red-laterite fort overlooking Vagator and Morjim beaches, popular from Dil Chahta Hai.',
      entryFee: 0.0,
      durationMinutes: 80,
      keywords: ['chapora', 'vagator', 'fort', 'sunset', 'dil chahta hai'],
    ),
    CatalogSpot(
      id: 'spot-goa-anjuna',
      destination: 'Goa',
      name: 'Anjuna Flea Market & Sunset Point',
      description: 'Iconic open-air market with Tibetan handicrafts, bohemian jewelry, live music, and sea breeze.',
      entryFee: 0.0,
      durationMinutes: 120,
      keywords: ['anjuna', 'market', 'flea', 'sunset', 'beach'],
    ),
    CatalogSpot(
      id: 'spot-goa-palolem',
      destination: 'Goa',
      name: 'Palolem Beach & Butterfly Island Boat Tour',
      description: 'Tranquil crescent bay in South Goa with calm turquoise waters, kayaking, and dolphin spotting.',
      entryFee: 600.0,
      durationMinutes: 140,
      keywords: ['palolem', 'butterfly', 'island', 'kayaking', 'dolphin'],
    ),
    CatalogSpot(
      id: 'spot-goa-spice',
      destination: 'Goa',
      name: 'Sahakari Spice Plantation Tour',
      description: 'Aromatic walking tour of vanilla, cardamom, and pepper groves followed by traditional Goan lunch.',
      entryFee: 500.0,
      durationMinutes: 110,
      keywords: ['spice', 'plantation', 'sahakari', 'grove', 'buffet'],
    ),
    CatalogSpot(
      id: 'spot-goa-cruise',
      destination: 'Goa',
      name: 'Mandovi River Sunset Cruise',
      description: 'Evening river pleasure cruise featuring vibrant Goan folk performances (Dekhni, Fugdi) and music.',
      entryFee: 750.0,
      durationMinutes: 90,
      keywords: ['mandovi', 'cruise', 'river', 'sunset', 'folk'],
    ),
    CatalogSpot(
      id: 'spot-goa-fontainhas',
      destination: 'Goa',
      name: 'Fontainhas Latin Quarter Heritage Walk',
      description: 'Wander through Panaji\'s charming Portuguese quarter with colorful pastel villas and art galleries.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['fontainhas', 'latin', 'panaji', 'heritage', 'villas'],
    ),
    CatalogSpot(
      id: 'spot-goa-calangute',
      destination: 'Goa',
      name: 'Calangute Beach Promenade',
      description: 'Queen of Goan beaches with bustling seaside shacks, shopping bazaars, and sun loungers.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['calangute', 'beach', 'shacks', 'bazaar'],
    ),
    CatalogSpot(
      id: 'spot-goa-reismagos',
      destination: 'Goa',
      name: 'Reis Magos Fort & Estuary',
      description: 'Historic hilltop coastal battery commanding the mouth of the Mandovi River with cannons.',
      entryFee: 100.0,
      durationMinutes: 75,
      keywords: ['reis', 'magos', 'fort', 'cannon', 'river'],
    ),

    // Jaipur, India
    CatalogSpot(
      id: 'spot-jaipur-amber',
      destination: 'Jaipur',
      name: 'Amber Palace (Amer Fort)',
      description: 'Majestic hilltop fort featuring the glittering Sheesh Mahal mirror palace and Rajput courtyards.',
      entryFee: 550.0,
      durationMinutes: 150,
      keywords: ['amber', 'amer', 'fort', 'palace'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-hawa-mahal',
      destination: 'Jaipur',
      name: 'Hawa Mahal (Palace of Winds)',
      description: 'Iconic five-story pink sandstone palace featuring 953 ornate latticework jharokhas.',
      entryFee: 400.0,
      durationMinutes: 100,
      keywords: ['hawa', 'mahal', 'winds', 'palace'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-city-palace',
      destination: 'Jaipur',
      name: 'City Palace & Chandra Mahal',
      description: 'Grand royal residence blending Rajput and Mughal architecture with armory and textile museums.',
      entryFee: 700.0,
      durationMinutes: 120,
      keywords: ['city palace', 'chandra mahal', 'museum', 'royal'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-jantar-mantar',
      destination: 'Jaipur',
      name: 'Jantar Mantar Astronomical Observatory',
      description: 'UNESCO World Heritage site housing the world\'s largest stone sundial and astronomical instruments.',
      entryFee: 350.0,
      durationMinutes: 90,
      keywords: ['jantar', 'mantar', 'astronomy', 'sundial'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-nahargarh',
      destination: 'Jaipur',
      name: 'Nahargarh Fort Sunset Viewpoint',
      description: 'Hilltop fortress along the Aravalli hills delivering sweeping sunset views over the entire Pink City.',
      entryFee: 200.0,
      durationMinutes: 100,
      keywords: ['nahargarh', 'sunset', 'aravalli', 'viewpoint'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-jal-mahal',
      destination: 'Jaipur',
      name: 'Jal Mahal Water Palace Promenade',
      description: 'Mesmerizing palace standing in the middle of Man Sagar Lake, surrounded by hills and water birds.',
      entryFee: 0.0,
      durationMinutes: 60,
      keywords: ['jal', 'mahal', 'lake', 'water palace'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-albert-hall',
      destination: 'Jaipur',
      name: 'Albert Hall State Museum',
      description: 'Oldest museum of Rajasthan exhibiting royal miniature paintings, ivory art, and an Egyptian mummy.',
      entryFee: 300.0,
      durationMinutes: 90,
      keywords: ['albert', 'hall', 'museum', 'artifacts'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-jaigarh',
      destination: 'Jaipur',
      name: 'Jaigarh Fort & Jaivana Cannon',
      description: 'Victory fort housing the world\'s largest cannon on wheels with secret tunnels connecting to Amer.',
      entryFee: 250.0,
      durationMinutes: 110,
      keywords: ['jaigarh', 'cannon', 'jaivana', 'fort'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-chokhi-dhani',
      destination: 'Jaipur',
      name: 'Chokhi Dhani Ethnic Cultural Village',
      description: 'Celebrated cultural fair with puppet shows, camel rides, folk dances, and traditional dining.',
      entryFee: 1100.0,
      durationMinutes: 180,
      keywords: ['chokhi', 'dhani', 'village', 'folk', 'camel'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-bapu-bazaar',
      destination: 'Jaipur',
      name: 'Bapu & Johari Bazaar Handicrafts Stroll',
      description: 'Historic walled city markets renowned for Jaipuri quilts, tie-dye bandhani textiles, and silver jewelry.',
      entryFee: 0.0,
      durationMinutes: 100,
      keywords: ['bapu', 'johari', 'bazaar', 'shopping', 'textiles'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-galtaji',
      destination: 'Jaipur',
      name: 'Galta Ji Sun Temple (Monkey Temple)',
      description: 'Sacred mountain pilgrimage complex nestled in a narrow pass with natural freshwater spring kunds.',
      entryFee: 100.0,
      durationMinutes: 80,
      keywords: ['galta', 'kund', 'monkey temple', 'spring'],
    ),
    CatalogSpot(
      id: 'spot-jaipur-sisodia',
      destination: 'Jaipur',
      name: 'Sisodia Rani Garden & Palace',
      description: 'Tiered royal garden adorned with painted pavilions, bubbling fountains, and lush floral terraces.',
      entryFee: 150.0,
      durationMinutes: 75,
      keywords: ['sisodia', 'rani', 'garden', 'palace', 'fountain'],
    ),

    // Manali, India
    CatalogSpot(
      id: 'spot-manali-solang',
      destination: 'Manali',
      name: 'Solang Valley Adventure Hub',
      description: 'High-altitude adventure bowl famous for paragliding, zorbing, ropeways, and winter ski slopes.',
      entryFee: 1200.0,
      durationMinutes: 180,
      keywords: ['solang', 'valley', 'snow', 'adventure', 'paragliding'],
    ),
    CatalogSpot(
      id: 'spot-manali-hadimba',
      destination: 'Manali',
      name: 'Hadimba Devi Pagoda Temple',
      description: 'Historic 16th-century four-tiered pagoda-style cedar temple surrounded by ancient deodar forest.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['hadimba', 'temple', 'forest', 'pine', 'cedar'],
    ),
    CatalogSpot(
      id: 'spot-manali-rohtang',
      destination: 'Manali',
      name: 'Rohtang Pass High Snow Vista',
      description: 'Spectacular 3,978m mountain pass connecting Kullu and Spiti valleys with year-round snow.',
      entryFee: 1500.0,
      durationMinutes: 220,
      keywords: ['rohtang', 'pass', 'glacier', 'snow', 'himalayas'],
    ),
    CatalogSpot(
      id: 'spot-manali-jogini',
      destination: 'Manali',
      name: 'Jogini Waterfall Nature Trek',
      description: 'Scenic walking trail from Vashisht village through pine woods and apple orchards to tumbling falls.',
      entryFee: 0.0,
      durationMinutes: 120,
      keywords: ['jogini', 'waterfall', 'trek', 'orchard'],
    ),
    CatalogSpot(
      id: 'spot-manali-oldmanali',
      destination: 'Manali',
      name: 'Old Manali Bohemian Cafes & River Bank',
      description: 'Quaint wooden village with live music cafes, handicraft stalls, and peaceful trails along Manalsu river.',
      entryFee: 0.0,
      durationMinutes: 100,
      keywords: ['old manali', 'cafes', 'river', 'wooden'],
    ),
    CatalogSpot(
      id: 'spot-manali-vashisht',
      destination: 'Manali',
      name: 'Vashisht Hot Water Sulphur Springs',
      description: 'Centuries-old therapeutic thermal hot springs and traditional stone temple overlooking the valley.',
      entryFee: 0.0,
      durationMinutes: 80,
      keywords: ['vashisht', 'springs', 'hot water', 'temple'],
    ),
    CatalogSpot(
      id: 'spot-manali-manu',
      destination: 'Manali',
      name: 'Manu Temple & Upper Manali Ridge',
      description: 'Only temple in India dedicated to the ancient Sage Manu, perched high with panoramic mountain views.',
      entryFee: 0.0,
      durationMinutes: 75,
      keywords: ['manu', 'temple', 'ridge', 'sage'],
    ),
    CatalogSpot(
      id: 'spot-manali-naggar',
      destination: 'Manali',
      name: 'Naggar Castle & Roerich Art Gallery',
      description: 'Medieval Himalayan castle built with wood and stone earthquake-resistant architecture over Beas river.',
      entryFee: 150.0,
      durationMinutes: 110,
      keywords: ['naggar', 'castle', 'art', 'roerich', 'heritage'],
    ),
    CatalogSpot(
      id: 'spot-manali-mallroad',
      destination: 'Manali',
      name: 'Mall Road Evening Walk & Tibetan Market',
      description: 'Pedestrian-only heart of Manali with woolens, kullu shawls, wooden carvings, and steaming momos.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['mall road', 'shopping', 'tibetan', 'shawls'],
    ),
    CatalogSpot(
      id: 'spot-manali-gulaba',
      destination: 'Manali',
      name: 'Gulaba Scenic Snow Viewpoint',
      description: 'Lush alpine meadows surrounded by snow peaks on the highway to Rohtang, great for photography.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['gulaba', 'meadows', 'snow', 'viewpoint'],
    ),
    CatalogSpot(
      id: 'spot-manali-atal',
      destination: 'Manali',
      name: 'Atal Tunnel & Sissu Valley Day Excursion',
      description: 'World\'s longest highway tunnel above 10,000 feet leading to the dramatic waterfalls of Lahaul Valley.',
      entryFee: 500.0,
      durationMinutes: 160,
      keywords: ['atal tunnel', 'sissu', 'lahaul', 'tunnel', 'waterfall'],
    ),
    CatalogSpot(
      id: 'spot-manali-vanvihar',
      destination: 'Manali',
      name: 'Van Vihar Forest Park & Lake',
      description: 'Tranquil municipal park densely populated with towering deodar trees and a peaceful boating pond.',
      entryFee: 50.0,
      durationMinutes: 60,
      keywords: ['van vihar', 'park', 'boating', 'deodar'],
    ),

    // Kerala, India
    CatalogSpot(
      id: 'spot-kerala-backwaters',
      destination: 'Kerala',
      name: 'Alleppey Backwaters Houseboat Cruise',
      description: 'Cruising through tranquil emerald lagoons, coconut palm groves, and village waterways.',
      entryFee: 2500.0,
      durationMinutes: 200,
      keywords: ['alleppey', 'backwaters', 'houseboat', 'lagoon'],
    ),
    CatalogSpot(
      id: 'spot-kerala-tea',
      destination: 'Kerala',
      name: 'Munnar Tea Plantations & Museum',
      description: 'Rolling mist-covered green hills, colonial tea estates, and tea processing tasting workshops.',
      entryFee: 350.0,
      durationMinutes: 120,
      keywords: ['munnar', 'tea', 'plantations', 'hills'],
    ),
    CatalogSpot(
      id: 'spot-kerala-mattupetty',
      destination: 'Kerala',
      name: 'Mattupetty Dam & Echo Point',
      description: 'Storage reservoir dam surrounded by tea estates and Shola forests, famous for speedboat rides.',
      entryFee: 150.0,
      durationMinutes: 90,
      keywords: ['mattupetty', 'dam', 'echo point', 'reservoir'],
    ),
    CatalogSpot(
      id: 'spot-kerala-periyar',
      destination: 'Kerala',
      name: 'Periyar Wildlife Sanctuary Boat Safari',
      description: 'Scenic boat cruise on Periyar Lake in Thekkady spotting wild elephants, sambar deer, and birds.',
      entryFee: 750.0,
      durationMinutes: 140,
      keywords: ['periyar', 'thekkady', 'wildlife', 'safari', 'elephant'],
    ),
    CatalogSpot(
      id: 'spot-kerala-fortkochi',
      destination: 'Kerala',
      name: 'Fort Kochi Chinese Fishing Nets & Jew Town',
      description: 'Cantilevered seaside fishing nets, Dutch colonial streets, spice markets, and ancient synagogue.',
      entryFee: 0.0,
      durationMinutes: 120,
      keywords: ['fort kochi', 'chinese nets', 'jew town', 'synagogue'],
    ),
    CatalogSpot(
      id: 'spot-kerala-athirappilly',
      destination: 'Kerala',
      name: 'Athirappilly Waterfalls (Niagara of India)',
      description: 'Majestic 80-foot waterfall cascading through Vazhachal forest reserve, featured in blockbuster films.',
      entryFee: 100.0,
      durationMinutes: 130,
      keywords: ['athirappilly', 'waterfall', 'forest', 'niagara'],
    ),
    CatalogSpot(
      id: 'spot-kerala-kovalam',
      destination: 'Kerala',
      name: 'Kovalam Lighthouse Beach & Sunset',
      description: 'Iconic striped lighthouse tower offering sweeping views of the Arabian Sea and crescent coastline.',
      entryFee: 50.0,
      durationMinutes: 90,
      keywords: ['kovalam', 'lighthouse', 'beach', 'sunset'],
    ),
    CatalogSpot(
      id: 'spot-kerala-eravikulam',
      destination: 'Kerala',
      name: 'Eravikulam National Park (Nilgiri Tahr)',
      description: 'Sanctuary for the endangered Nilgiri Tahr mountain goat and rolling meadows of Neelakurinji blooms.',
      entryFee: 400.0,
      durationMinutes: 130,
      keywords: ['eravikulam', 'tahr', 'munnar', 'national park'],
    ),
    CatalogSpot(
      id: 'spot-kerala-varkala',
      destination: 'Kerala',
      name: 'Varkala Red Cliff Beach & Springs',
      description: 'Dramatic laterite cliffs abutting the beach with seaside cafes and natural mineral water spouts.',
      entryFee: 0.0,
      durationMinutes: 100,
      keywords: ['varkala', 'cliff', 'beach', 'cafes', 'springs'],
    ),
    CatalogSpot(
      id: 'spot-kerala-marari',
      destination: 'Kerala',
      name: 'Marari Beach Palm Grove Retreat',
      description: 'Peaceful fishing village beach with coconut groves, quiet sands, and traditional hammocks.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['marari', 'beach', 'coconut', 'relax'],
    ),
    CatalogSpot(
      id: 'spot-kerala-kumarakom',
      destination: 'Kerala',
      name: 'Kumarakom Bird Sanctuary & Vembanad Lake',
      description: 'Ramsar wetland sanctuary hosting migratory siberian cranes, kingfishers, and waterways.',
      entryFee: 200.0,
      durationMinutes: 100,
      keywords: ['kumarakom', 'birds', 'lake', 'wetland'],
    ),
    CatalogSpot(
      id: 'spot-kerala-bekal',
      destination: 'Kerala',
      name: 'Bekal Fort & Coastal Promenade',
      description: 'Keyhole-shaped beachfront bastion with observation towers rising directly out of the Arabian Sea.',
      entryFee: 150.0,
      durationMinutes: 110,
      keywords: ['bekal', 'fort', 'coastal', 'bastion'],
    ),
  ];

  // Dining (Calculated in INR ₹ average cost per person)
  static const List<CatalogDining> dinings = [
    // Paris, France
    CatalogDining(
      id: 'dine-paris-lunch-1',
      destination: 'Paris',
      mealType: 'Lunch',
      restaurantName: 'Le Bistrot Parisien',
      description: 'Traditional Parisian brasserie serving croque-monsieur, duck rillettes, and fresh baguettes.',
      averageCost: 850.0,
    ),
    CatalogDining(
      id: 'dine-paris-dinner-1',
      destination: 'Paris',
      mealType: 'Dinner',
      restaurantName: 'Café de Flore French Dining',
      description: 'Historic Saint-Germain landmark offering beef bourguignon, French onion soup, and vintage wine.',
      averageCost: 1600.0,
    ),
    CatalogDining(
      id: 'dine-paris-lunch-2',
      destination: 'Paris',
      mealType: 'Lunch',
      restaurantName: 'Bouillon Chartier Grands Boulevards',
      description: 'Art Nouveau dining hall offering classic roasted chicken, escargots, and crème caramel.',
      averageCost: 750.0,
    ),
    CatalogDining(
      id: 'dine-paris-dinner-2',
      destination: 'Paris',
      mealType: 'Dinner',
      restaurantName: 'Les Ombres Rooftop Terrace',
      description: 'Glass-roofed gourmet restaurant directly facing the illuminated Eiffel Tower.',
      averageCost: 2400.0,
    ),
    CatalogDining(
      id: 'dine-paris-lunch-3',
      destination: 'Paris',
      mealType: 'Lunch',
      restaurantName: 'L\'As du Fallafel (Le Marais)',
      description: 'World-famous casual eatery serving warm pita sandwiches stuffed with crispy falafel and eggplant.',
      averageCost: 550.0,
    ),
    CatalogDining(
      id: 'dine-paris-dinner-3',
      destination: 'Paris',
      mealType: 'Dinner',
      restaurantName: 'Le Train Bleu Gourmet',
      description: 'Opulent Belle Époque dining salon inside Gare de Lyon serving roasted veal and fine cheeses.',
      averageCost: 2200.0,
    ),

    // Rome, Italy
    CatalogDining(
      id: 'dine-rome-lunch-1',
      destination: 'Rome',
      mealType: 'Lunch',
      restaurantName: 'Trattoria Da Enzo al 29',
      description: 'Cozy Roman trattoria renowned for authentic carbonara, cacio e pepe, and fried artichokes.',
      averageCost: 750.0,
    ),
    CatalogDining(
      id: 'dine-rome-dinner-1',
      destination: 'Rome',
      mealType: 'Dinner',
      restaurantName: 'Ristorante Aroma at Colosseum',
      description: 'Fine dining terrace with direct floodlit views of the Colosseum and classic Italian courses.',
      averageCost: 1450.0,
    ),
    CatalogDining(
      id: 'dine-rome-lunch-2',
      destination: 'Rome',
      mealType: 'Lunch',
      restaurantName: 'Pizzarium Bonci',
      description: 'Famed Roman pizza al taglio shop with airy sourdough crusts and artisanal gourmet toppings.',
      averageCost: 550.0,
    ),
    CatalogDining(
      id: 'dine-rome-dinner-2',
      destination: 'Rome',
      mealType: 'Dinner',
      restaurantName: 'Osteria da Fortunata',
      description: 'Watch pasta made fresh by hand by Italian nonnas while dining on handmade tagliolini and ragù.',
      averageCost: 950.0,
    ),
    CatalogDining(
      id: 'dine-rome-lunch-3',
      destination: 'Rome',
      mealType: 'Lunch',
      restaurantName: 'Roscioli Salumeria con Cucina',
      description: 'Gourmet deli and wine bistro serving legendary amatriciana, burrata, and cured meats.',
      averageCost: 1100.0,
    ),
    CatalogDining(
      id: 'dine-rome-dinner-3',
      destination: 'Rome',
      mealType: 'Dinner',
      restaurantName: 'Tonnarello Trastevere',
      description: 'Lively piazza terrace famous for copper-pan cacio e pepe, meatballs, and house wine.',
      averageCost: 850.0,
    ),

    // Tokyo, Japan
    CatalogDining(
      id: 'dine-tokyo-lunch-1',
      destination: 'Tokyo',
      mealType: 'Lunch',
      restaurantName: 'Ichiran Ramen Shibuya',
      description: 'Classic rich tonkotsu pork broth ramen served in private flavor concentration booths.',
      averageCost: 650.0,
    ),
    CatalogDining(
      id: 'dine-tokyo-dinner-1',
      destination: 'Tokyo',
      mealType: 'Dinner',
      restaurantName: 'Gonpachi Nishi-Azabu Izakaya',
      description: 'Atmospheric izakaya serving charcoal-grilled yakitori, handmade soba, and green tea.',
      averageCost: 1500.0,
    ),
    CatalogDining(
      id: 'dine-tokyo-lunch-2',
      destination: 'Tokyo',
      mealType: 'Lunch',
      restaurantName: 'Katsukura Shinjuku Takashimaya',
      description: 'Crispy panko-breaded tonkotsu pork cutlets with shredded cabbage and sesame dipping sauce.',
      averageCost: 750.0,
    ),
    CatalogDining(
      id: 'dine-tokyo-dinner-2',
      destination: 'Tokyo',
      mealType: 'Dinner',
      restaurantName: 'Sukiyabashi Jiro Roppongi',
      description: 'Master Edomae sushi experience with seasonal fish selected daily from Toyosu fish market.',
      averageCost: 2900.0,
    ),
    CatalogDining(
      id: 'dine-tokyo-lunch-3',
      destination: 'Tokyo',
      mealType: 'Lunch',
      restaurantName: 'Tempura Kondo Ginza',
      description: 'Light and airy tempura fried to perfection including sweet potato fritters and jumbo prawns.',
      averageCost: 1400.0,
    ),
    CatalogDining(
      id: 'dine-tokyo-dinner-3',
      destination: 'Tokyo',
      mealType: 'Dinner',
      restaurantName: 'Imahan Sukiyaki Ningyocho',
      description: 'Historic tatami room restaurant serving marbled Kuroge Wagyu beef simmered in sweet soy broth.',
      averageCost: 2600.0,
    ),

    // Swiss Alps
    CatalogDining(
      id: 'dine-swiss-lunch-1',
      destination: 'Swiss Alps',
      mealType: 'Lunch',
      restaurantName: 'Chez Vrony Alpine Hut',
      description: 'Rustic chalet perched at 2,100m offering traditional rösti, cured meats, and local cheese.',
      averageCost: 1100.0,
    ),
    CatalogDining(
      id: 'dine-swiss-dinner-1',
      destination: 'Swiss Alps',
      mealType: 'Dinner',
      restaurantName: 'Walliserkanne Fondue Stübli',
      description: 'Traditional wood-paneled tavern serving bubbling Swiss Gruyère cheese fondue and hot cocoa.',
      averageCost: 2200.0,
    ),
    CatalogDining(
      id: 'dine-swiss-lunch-2',
      destination: 'Swiss Alps',
      mealType: 'Lunch',
      restaurantName: 'Restaurant Barry\'s Grindelwald',
      description: 'Charming timbered lodge offering crispy potato rösti with smoked ham and fried egg.',
      averageCost: 1100.0,
    ),
    CatalogDining(
      id: 'dine-swiss-dinner-2',
      destination: 'Swiss Alps',
      mealType: 'Dinner',
      restaurantName: 'Harder Kulm Panorama Restaurant',
      description: 'Romantic sunset terrace serving bubbling gruyère fondue overlooking the glowing Jungfrau peaks.',
      averageCost: 1900.0,
    ),
    CatalogDining(
      id: 'dine-swiss-lunch-3',
      destination: 'Swiss Alps',
      mealType: 'Lunch',
      restaurantName: 'Chalet Schuh Interlaken',
      description: 'Historic pastry parlor and cafe offering artisan Swiss chocolates, quiches, and alpine coffee.',
      averageCost: 850.0,
    ),
    CatalogDining(
      id: 'dine-swiss-dinner-3',
      destination: 'Swiss Alps',
      mealType: 'Dinner',
      restaurantName: 'Wirtshaus Taube Lucerne',
      description: 'Riverside old-town restaurant serving traditional Lucerne chügelipastete and veal sausages.',
      averageCost: 1600.0,
    ),

    // Goa, India
    CatalogDining(
      id: 'dine-goa-lunch-1',
      destination: 'Goa',
      mealType: 'Lunch',
      restaurantName: 'The Fisherman\'s Wharf',
      description: 'Riverside Goan dining serving kingfish peri-peri, prawn curry with rice, and poee bread.',
      averageCost: 650.0,
    ),
    CatalogDining(
      id: 'dine-goa-dinner-1',
      destination: 'Goa',
      mealType: 'Dinner',
      restaurantName: 'Martin\'s Corner',
      description: 'Legendary South Goan coastal restaurant famous for butter garlic crab and live acoustic music.',
      averageCost: 950.0,
    ),
    CatalogDining(
      id: 'dine-goa-lunch-2',
      destination: 'Goa',
      mealType: 'Lunch',
      restaurantName: 'Souza Lobo Calangute',
      description: 'Historic beachfront dining established in 1932 serving traditional Goan fish curry thali and calamari.',
      averageCost: 700.0,
    ),
    CatalogDining(
      id: 'dine-goa-dinner-2',
      destination: 'Goa',
      mealType: 'Dinner',
      restaurantName: 'Thalassa Greek & Coastal Tavern',
      description: 'Spectacular Vagator cliffside open-air sunset venue with Mediterranean grills and fire shows.',
      averageCost: 1400.0,
    ),
    CatalogDining(
      id: 'dine-goa-lunch-3',
      destination: 'Goa',
      mealType: 'Lunch',
      restaurantName: 'Gunpowder Assagao',
      description: 'Charming Portuguese heritage villa garden serving spicy Pandi pork curry, appams, and coastal roasts.',
      averageCost: 850.0,
    ),
    CatalogDining(
      id: 'dine-goa-dinner-3',
      destination: 'Goa',
      mealType: 'Dinner',
      restaurantName: 'Britto\'s Beach Shack (Baga)',
      description: 'Beloved sea-facing shack serving baked stuffed crabs, seafood platters, and chocolate mousse.',
      averageCost: 900.0,
    ),

    // Jaipur, India
    CatalogDining(
      id: 'dine-jaipur-lunch-1',
      destination: 'Jaipur',
      mealType: 'Lunch',
      restaurantName: 'LMB (Laxmi Mishthan Bhandar)',
      description: 'Historic Johari Bazaar eatery renowned for authentic Rajasthani Dal Baati Churma and Ghewar.',
      averageCost: 450.0,
    ),
    CatalogDining(
      id: 'dine-jaipur-dinner-1',
      destination: 'Jaipur',
      mealType: 'Dinner',
      restaurantName: '1135 AD Amber Royal Dining',
      description: 'Regal dining hall inside Amer Fort with silver dinnerware, live sitar music, and Mughlai curries.',
      averageCost: 1200.0,
    ),
    CatalogDining(
      id: 'dine-jaipur-lunch-2',
      destination: 'Jaipur',
      mealType: 'Lunch',
      restaurantName: 'Rawat Mishthan Bhandar',
      description: 'Famous Station Road stop renowned across India for steaming pyaaz kachoris and Rajasthani thali.',
      averageCost: 350.0,
    ),
    CatalogDining(
      id: 'dine-jaipur-dinner-2',
      destination: 'Jaipur',
      mealType: 'Dinner',
      restaurantName: 'Handi Restaurant (MI Road)',
      description: 'Award-winning clay-pot dining celebrated for tender handi meat, paneer lababdar, and roomali roti.',
      averageCost: 750.0,
    ),
    CatalogDining(
      id: 'dine-jaipur-lunch-3',
      destination: 'Jaipur',
      mealType: 'Lunch',
      restaurantName: 'Peacock Rooftop Restaurant',
      description: 'Artistic garden terrace near Hathroi Fort serving North Indian favorites with views of the hills.',
      averageCost: 550.0,
    ),
    CatalogDining(
      id: 'dine-jaipur-dinner-3',
      destination: 'Jaipur',
      mealType: 'Dinner',
      restaurantName: 'Spice Court (Civil Lines)',
      description: 'Gracious royal courtyard restaurant famous for fiery Rajasthani Junglee Maas and Keema Bati.',
      averageCost: 900.0,
    ),

    // Manali, India
    CatalogDining(
      id: 'dine-manali-lunch-1',
      destination: 'Manali',
      mealType: 'Lunch',
      restaurantName: 'Cafe 1947 Riverside',
      description: 'Charming vintage cafe beside the gushing Manalsu river serving wood-fired pizza and hot ginger tea.',
      averageCost: 550.0,
    ),
    CatalogDining(
      id: 'dine-manali-dinner-1',
      destination: 'Manali',
      mealType: 'Dinner',
      restaurantName: 'Johnson\'s Cafe & Bar',
      description: 'Cozy fireplace restaurant renowned for fresh Himalayan river trout with almond butter sauce.',
      averageCost: 850.0,
    ),
    CatalogDining(
      id: 'dine-manali-lunch-2',
      destination: 'Manali',
      mealType: 'Lunch',
      restaurantName: 'Chopsticks Tibetan Restaurant',
      description: 'Mall Road culinary landmark serving steaming bowls of Thukpa, Gyathuk, and pan-fried momos.',
      averageCost: 400.0,
    ),
    CatalogDining(
      id: 'dine-manali-dinner-2',
      destination: 'Manali',
      mealType: 'Dinner',
      restaurantName: 'Il Forno Wood Fired Pizza',
      description: 'Rustic stone mountain cottage among apple trees serving authentic Neapolitan pizzas and lasagna.',
      averageCost: 800.0,
    ),
    CatalogDining(
      id: 'dine-manali-lunch-3',
      destination: 'Manali',
      mealType: 'Lunch',
      restaurantName: 'Dylan\'s Toasted & Roasted Coffee House',
      description: 'Legendary Old Manali cafe renowned for freshly baked warm chocolate chip cookies and mountain roast.',
      averageCost: 350.0,
    ),
    CatalogDining(
      id: 'dine-manali-dinner-3',
      destination: 'Manali',
      mealType: 'Dinner',
      restaurantName: 'Mount View Restaurant',
      description: 'Warm multi-cuisine retreat serving piping hot trout curries, Peking soup, and Himachali siddu.',
      averageCost: 650.0,
    ),

    // Kerala, India
    CatalogDining(
      id: 'dine-kerala-lunch-1',
      destination: 'Kerala',
      mealType: 'Lunch',
      restaurantName: 'Paragon Coastal Kitchen',
      description: 'Acclaimed Malabar establishment famous for fragrant Kozhikode biryani, appam, and fish moilee.',
      averageCost: 500.0,
    ),
    CatalogDining(
      id: 'dine-kerala-dinner-1',
      destination: 'Kerala',
      mealType: 'Dinner',
      restaurantName: 'Malabar Junction Heritage Dining',
      description: 'Courtyard candlelit dining serving coastal seafood thali, coconut stews, and Kerala parottas.',
      averageCost: 950.0,
    ),
    CatalogDining(
      id: 'dine-kerala-lunch-2',
      destination: 'Kerala',
      mealType: 'Lunch',
      restaurantName: 'Saravana Bhavan Traditional Sadya',
      description: 'Authentic 24-dish Kerala banana leaf sadya featuring avial, thoran, sambar, and payasam.',
      averageCost: 350.0,
    ),
    CatalogDining(
      id: 'dine-kerala-dinner-2',
      destination: 'Kerala',
      mealType: 'Dinner',
      restaurantName: 'Kashi Art Cafe (Fort Kochi)',
      description: 'Artsy open-courtyard cafe serving organic Kerala salads, freshly roasted coffee, and chocolate pie.',
      averageCost: 600.0,
    ),
    CatalogDining(
      id: 'dine-kerala-lunch-3',
      destination: 'Kerala',
      mealType: 'Lunch',
      restaurantName: 'Dhe Puttu Heritage Restaurant',
      description: 'Unique culinary spot dedicated to traditional steamed rice cakes served with spicy kadala curry.',
      averageCost: 450.0,
    ),
    CatalogDining(
      id: 'dine-kerala-dinner-3',
      destination: 'Kerala',
      mealType: 'Dinner',
      restaurantName: 'Grand Pavilion Cochin',
      description: 'Beloved local dining room known for Malabar chicken roast, fish pollichathu, and pathiri.',
      averageCost: 750.0,
    ),
  ];

  /// Supported destinations in the local database travel catalog.
  static const List<String> supportedDestinations = [
    'Paris',
    'Rome',
    'Tokyo',
    'Swiss Alps',
    'Goa',
    'Jaipur',
    'Manali',
    'Kerala',
  ];

  /// Checks if a destination name is supported in our database catalog.
  static bool isSupported(String? destination) {
    if (destination == null || destination.trim().isEmpty) return false;
    final destLower = destination.trim().toLowerCase();
    return supportedDestinations.any((d) =>
        d.toLowerCase() == destLower ||
        destLower.contains(d.toLowerCase()) ||
        d.toLowerCase().contains(destLower));
  }

  /// Attempts to extract or match a supported destination from a text prompt.
  /// Returns the canonical destination name if matched, or null if no supported destination is found.
  static String? matchDestination(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('tokyo') || lower.contains('japan') || lower.contains('shibuya') || lower.contains('akihabara')) {
      return 'Tokyo';
    }
    if (lower.contains('swiss') || lower.contains('alps') || lower.contains('zermatt') || lower.contains('matterhorn') || lower.contains('jungfrau')) {
      return 'Swiss Alps';
    }
    if (lower.contains('rome') || lower.contains('italy') || lower.contains('colosseum') || lower.contains('vatican')) {
      return 'Rome';
    }
    if (lower.contains('goa') || lower.contains('baga beach') || lower.contains('calangute')) {
      return 'Goa';
    }
    if (lower.contains('jaipur') || lower.contains('rajasthan') || lower.contains('amber fort') || lower.contains('amer fort') || lower.contains('hawa mahal')) {
      return 'Jaipur';
    }
    if (lower.contains('manali') || lower.contains('himachal') || lower.contains('solang') || lower.contains('hadimba')) {
      return 'Manali';
    }
    if (lower.contains('kerala') || lower.contains('munnar') || lower.contains('alleppey') || lower.contains('backwaters')) {
      return 'Kerala';
    }
    if (lower.contains('paris') || lower.contains('france') || lower.contains('eiffel') || lower.contains('louvre')) {
      return 'Paris';
    }
    return null;
  }
}

