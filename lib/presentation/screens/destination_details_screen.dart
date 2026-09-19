import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../data/models/destination_model.dart';
import '../../providers/trip_provider.dart';
import '../widgets/app_image.dart';
import 'my_trips_screen.dart';

class DestinationDetailsScreen extends StatelessWidget {
  final String destinationName;
  final DestinationModel? destination;

  const DestinationDetailsScreen({
    super.key,
    required this.destinationName,
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dest = destination ?? DestinationModel.findByName(destinationName);

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

          // Must-See Spots Section
          if (dest.spots.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                color: isDark ? AppColors.surfaceTile2 : AppColors.canvasParchment,
                padding: const EdgeInsets.symmetric(vertical: 64.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Must-See Spots',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 280,
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
                padding: const EdgeInsets.symmetric(vertical: 64.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Top Dining',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 280,
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: ElevatedButton.icon(
            onPressed: () {
              final prompt = 'Plan a 3-day travel itinerary to ${dest.name} exploring top attractions, culture, and dining.';
              final startDate = DateTime.now().add(const Duration(days: 7));
              final navigator = Navigator.of(context);
              Provider.of<TripProvider>(context, listen: false).createTrip(prompt, startDate).then((_) {
                navigator.push(
                  MaterialPageRoute(builder: (_) => const MyTripsScreen()),
                );
              });
            },
            icon: const Icon(Icons.auto_awesome),
            label: Text('Plan a Trip to ${dest.name} with AI'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpotCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imageUrl,
    String? tag,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 24),
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
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tag != null && tag.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      tag.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
