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
    // Paris
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
      name: 'Louvre Museum',
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

    // Rome
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
      name: 'Vatican Museums & St. Peter\'s',
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

    // Tokyo
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
      name: 'Hawa Mahal & City Palace',
      description: 'Iconic five-story pink sandstone Palace of Winds featuring 953 ornate latticework jharokhas.',
      entryFee: 400.0,
      durationMinutes: 120,
      keywords: ['hawa', 'mahal', 'city', 'palace'],
    ),

    // Manali, India
    CatalogSpot(
      id: 'spot-manali-solang',
      destination: 'Manali',
      name: 'Solang Valley Adventure',
      description: 'High-altitude snow adventure hub with paragliding, zorbing, ropeways, and ski slopes.',
      entryFee: 1200.0,
      durationMinutes: 180,
      keywords: ['solang', 'valley', 'snow', 'adventure'],
    ),
    CatalogSpot(
      id: 'spot-manali-hadimba',
      destination: 'Manali',
      name: 'Hadimba Devi Temple',
      description: 'Historic 16th-century pagoda-style wooden temple nestled amidst towering cedar and pine forests.',
      entryFee: 0.0,
      durationMinutes: 90,
      keywords: ['hadimba', 'temple', 'forest', 'pine'],
    ),

    // Kerala, India
    CatalogSpot(
      id: 'spot-kerala-backwaters',
      destination: 'Kerala',
      name: 'Alleppey Backwaters Houseboat',
      description: 'Cruising through tranquil emerald lagoons, coconut palm groves, and village waterways.',
      entryFee: 2500.0,
      durationMinutes: 200,
      keywords: ['alleppey', 'backwaters', 'houseboat', 'lagoon'],
    ),
    CatalogSpot(
      id: 'spot-kerala-tea',
      destination: 'Kerala',
      name: 'Munnar Tea Plantations',
      description: 'Rolling mist-covered green hills, colonial tea estates, and tea tasting workshops.',
      entryFee: 350.0,
      durationMinutes: 120,
      keywords: ['munnar', 'tea', 'plantations', 'hills'],
    ),
  ];

  // Dining (Calculated in INR ₹ average cost per person)
  static const List<CatalogDining> dinings = [
    // Paris
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

    // Rome
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

    // Tokyo
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
  ];
}
