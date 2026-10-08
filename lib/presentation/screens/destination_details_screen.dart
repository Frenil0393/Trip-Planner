import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../data/models/destination_model.dart';
import '../../providers/trip_provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/app_image.dart';
import 'itinerary_screen.dart';

class DestinationDetailsScreen extends StatefulWidget {
  final String destinationName;
  final DestinationModel? destination;

  const DestinationDetailsScreen({
    super.key,
    required this.destinationName,
    this.destination,
  });

  @override
  State<DestinationDetailsScreen> createState() => _DestinationDetailsScreenState();
}

class _DestinationDetailsScreenState extends State<DestinationDetailsScreen> {
  late DateTime _departureDate;
  int _durationDays = 3;

  @override
  void initState() {
    super.initState();
    _departureDate = DateTime.now().add(const Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dest = widget.destination ?? DestinationModel.findByName(widget.destinationName);

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450.0,
            pinned: true,
            backgroundColor: isDark ? AppColors.surfaceBlack : AppColors.canvas,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    imagePath: dest.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 48,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dest.name,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 56,
                                letterSpacing: -0.28,
                              ),
                        ),
                        const SizedBox(height: 8),
                        if (dest.country.isNotEmpty)
                          Text(
                            dest.country,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          dest.tagline.isNotEmpty
                              ? dest.tagline
                              : dest.description,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Quick Stats Pill Row
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatPill(
                      icon: Icons.star,
                      label: '${dest.rating} Rating',
                      color: const Color(0xFFFF9500),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),
                    _buildStatPill(
                      icon: Icons.wb_sunny_outlined,
                      label: dest.bestTimeToVisit,
                      color: AppColors.primary,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),
                    _buildStatPill(
                      icon: Icons.payments_outlined,
                      label: 'Currency: ${dest.currency}',
                      color: const Color(0xFF34C759),
                      isDark: isDark,
                    ),
                    if (dest.tags.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      ...dest.tags.map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(
                                color: isDark ? Colors.white10 : AppColors.hairline,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.canvas : AppColors.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Must-See Spots Section
          if (dest.spots.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                color: isDark ? AppColors.surfaceTile2 : AppColors.canvasParchment,
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Must-See Spots',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Iconic landmarks and essential attractions in ${dest.name}.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                ),
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
                        itemCount: dest.spots.length,
                        itemBuilder: (context, index) {
                          final spot = dest.spots[index];
                          return _buildSpotCard(
                            context,
                            title: spot.title,
                            description: spot.description,
                            imageUrl: spot.imageUrl,
                            tag: spot.category,
                            rating: spot.rating,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Top Dining Section
          if (dest.dining.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                color: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Top Dining & Cuisine',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Authentic gastronomic spots and acclaimed eateries.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                ),
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
                        itemCount: dest.dining.length,
                        itemBuilder: (context, index) {
                          final restaurant = dest.dining[index];
                          return _buildSpotCard(
                            context,
                            title: restaurant.title,
                            description: restaurant.description,
                            imageUrl: restaurant.imageUrl,
                            tag: restaurant.cuisine,
                            priceText: restaurant.priceRange,
                            rating: restaurant.rating,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Accommodations / Where to Stay
          if (dest.hotels.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                color: isDark ? AppColors.surfaceTile2 : AppColors.canvasParchment,
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Where to Stay',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Curated boutique accommodations and luxury retreats.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                ),
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
                        itemCount: dest.hotels.length,
                        itemBuilder: (context, index) {
                          final hotel = dest.hotels[index];
                          return _buildSpotCard(
                            context,
                            title: hotel.title,
                            description: hotel.description,
                            imageUrl: hotel.imageUrl,
                            tag: 'Accommodation',
                            priceText: '${AppUtils.formatCurrency(hotel.pricePerNight)} / night',
                            rating: hotel.rating,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceBlack : AppColors.canvas,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white12 : AppColors.hairline,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Interactive Departure Date Pill
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final now = DateTime.now();
                  final firstAllowed = DateTime(now.year, now.month, now.day);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _departureDate.isBefore(firstAllowed) ? firstAllowed : _departureDate,
                    firstDate: firstAllowed,
                    lastDate: now.add(const Duration(days: 365)),
                    helpText: 'SELECT DEPARTURE DATE',
                    confirmText: 'SET DEPARTURE',
                  );
                  if (picked != null) {
                    setState(() => _departureDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : AppColors.hairline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: isDark ? AppColors.primaryOnDark : AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Departure: ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                        ),
                      ),
                      Text(
                        AppUtils.formatDepartureDate(_departureDate),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.primaryOnDark : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Interactive Duration Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : AppColors.hairline,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 16,
                      color: isDark ? AppColors.primaryOnDark : AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Duration: ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                      ),
                    ),
                    Text(
                      '$_durationDays Days',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.ink,
                      ),
                    ),
                    const Spacer(),
                    ...[2, 3, 4, 5, 7].map((days) {
                      final isSelected = _durationDays == days;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: InkWell(
                          onTap: () => setState(() => _durationDays = days),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${days}D',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : AppColors.ink),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final prompt = 'Plan a $_durationDays-day travel itinerary to ${dest.name} exploring top attractions, culture, and dining.';
                    final tripProvider = Provider.of<TripProvider>(context, listen: false);
                    
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => Center(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'Crafting $_durationDays-day itinerary for ${dest.name}...',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    tripProvider.createTrip(prompt, _departureDate, userId: authProvider.currentUser?.id).then((success) {
                      if (!context.mounted) return;
                      Navigator.pop(context); // Dismiss loading dialog
                      if (success && tripProvider.trips.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItineraryScreen(trip: tripProvider.trips.last),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(tripProvider.errorMessage ?? 'Trip not found'),
                            backgroundColor: Colors.redAccent.shade700,
                          ),
                        );
                      }
                    });
                  },
                  icon: const Icon(Icons.auto_awesome, size: 20),
                  label: Text('Plan a $_durationDays-Day Trip to ${dest.name} with AI'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.hairline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.canvas : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imageUrl,
    String? tag,
    String? priceText,
    double? rating,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTile3 : AppColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.transparent : AppColors.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(
            imagePath: imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (tag != null && tag.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    if (rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, size: 12, color: Color(0xFFFF9500)),
                          const SizedBox(width: 3),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (priceText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    priceText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
