import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/models.dart';
import '../../providers/trip_provider.dart';
import 'my_trips_screen.dart';
import 'profile_screen.dart';
import 'destination_details_screen.dart';
import 'itinerary_screen.dart';
import '../widgets/app_image.dart';
import '../widgets/departure_date_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _generateTrip(String prompt) {
    if (prompt.trim().isEmpty) return;
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    tripProvider
        .createTrip(prompt.trim(), _selectedDate)
        .then((_) {
      if (!mounted) return;
      if (tripProvider.trips.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItineraryScreen(trip: tripProvider.trips.last),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyTripsScreen()),
        );
      }
    });
  }

  void _scrollToDestinations() {
    _scrollController.animateTo(
      420,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tripProvider = Provider.of<TripProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? AppColors.surfaceBlack : AppColors.canvas,
            actions: [
              IconButton(
                icon: const Icon(Icons.list),
                tooltip: 'My Trips',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTripsScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                tooltip: 'Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  const AppImage(
                    imagePath: 'assets/images/hero_banner.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 48,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Where to?',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 56,
                                letterSpacing: -0.28,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Let AI craft your perfect itinerary.',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: _scrollToDestinations,
                          icon: const Icon(Icons.explore, size: 18),
                          label: const Text('Explore Destinations'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Prompt Input Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              color: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      children: [
                        TextField(
                          controller: _promptController,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'e.g. 3-day romantic weekend in Paris focusing on art',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: tripProvider.isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(12),
                                      ),
                                      onPressed: () => _generateTrip(_promptController.text),
                                      child: const Icon(Icons.arrow_upward),
                                    ),
                            ),
                          ),
                        ),
                        if (tripProvider.isLoading) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2.5),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    tripProvider.statusMessage.isNotEmpty
                                        ? tripProvider.statusMessage
                                        : 'Processing prompt with Google Gemini 2.5 Flash LLM...',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // Redesigned Departure Date Selector
                        DepartureDateSelector(
                          selectedDate: _selectedDate,
                          onDateSelected: (newDate) {
                            setState(() {
                              _selectedDate = newDate;
                            });
                          },
                        ),
                        const SizedBox(height: 16),


                        // Quick Ideas chips (Indian & International travel ideas)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildQuickChip('🏖️ Goa 3-Day Beach Escape', 'Plan a 3-day beach vacation to Goa with water sports, beach shacks, and seafood.', isDark),
                            _buildQuickChip('🏰 Jaipur 3-Day Royal Forts', 'A 3-day royal heritage trip to Jaipur exploring Amer Fort, City Palace, and bazaars.', isDark),
                            _buildQuickChip('🏔️ Manali 4-Day Snow Tour', 'A 4-day mountain getaway to Manali with Solang Valley, Rohtang Pass, and scenic cafes.', isDark),
                            _buildQuickChip('🌴 Kerala 3-Day Backwaters', 'A 3-day serene backwater tour in Kerala with houseboat stay and Munnar tea gardens.', isDark),
                            _buildQuickChip('🗼 Paris 3-Day Art & Food', 'Plan a 3-day romantic trip to Paris exploring the Eiffel Tower, Louvre, and cafes.', isDark),
                            _buildQuickChip('🏯 Tokyo 5-Day Tech Tour', 'A 5-day trip to Tokyo exploring gadgets, anime hubs, and modern culture.', isDark),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dynamic Destinations Section
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? AppColors.surfaceTile2 : AppColors.canvasParchment,
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Popular Destinations',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap any destination to explore spots and plan a trip.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 290,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: DestinationModel.sampleDestinations.length,
                      itemBuilder: (context, index) {
                        final dest = DestinationModel.sampleDestinations[index];
                        return _buildDestinationCard(context, dest, isDark);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Curated Itinerary Templates
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64.0),
              child: Column(
                children: [
                  Text(
                    'Featured Trips',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Get inspired by pre-planned itineraries curated for you.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1024),
                      child: Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: AppConstants.preBakedTemplates.map((template) {
                          final imagePath = template['image'] ?? 'assets/images/trip_placeholder.jpg';
                          return SizedBox(
                            width: 300,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceTile2 : AppColors.canvas,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : AppColors.hairline,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  _promptController.text = template['prompt'];
                                  _generateTrip(template['prompt']);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppImage(
                                      imagePath: imagePath,
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            template['title'],
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            template['prompt'],
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                                  fontSize: 13,
                                                ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${template['durationDays']} Days Plan',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                                ),
                                              ),
                                              const Text(
                                                'Generate Plan →',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label, String prompt, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(9999),
      onTap: () {
        _promptController.text = prompt;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isDark ? Colors.white12 : AppColors.hairline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.canvas : AppColors.ink,
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard(BuildContext context, DestinationModel dest, bool isDark) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTile3 : AppColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.transparent : AppColors.hairline,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DestinationDetailsScreen(
                destinationName: dest.name,
                destination: dest,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              imagePath: dest.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dest.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 12, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${dest.rating}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dest.country,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dest.tagline,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                          fontSize: 12,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
