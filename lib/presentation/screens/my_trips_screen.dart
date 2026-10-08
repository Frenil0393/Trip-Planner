import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trip_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils.dart';
import '../../core/theme.dart';
import '../widgets/app_image.dart';
import 'itinerary_screen.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      if (!mounted) return;
      final auth = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<TripProvider>(context, listen: false)
          .loadTrips(userId: auth.currentUser?.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTripImage(String? destinationName, String title) {
    final query = '${destinationName ?? ''} $title'.toLowerCase();
    if (query.contains('paris')) return 'assets/images/paris.jpg';
    if (query.contains('tokyo')) return 'assets/images/tokyo.jpg';
    if (query.contains('rome')) return 'assets/images/rome.jpg';
    if (query.contains('swiss') || query.contains('alps')) return 'assets/images/swiss_alps.jpg';
    if (query.contains('goa')) return 'assets/images/goa.jpg';
    if (query.contains('jaipur') || query.contains('rajasthan')) return 'assets/images/jaipur.jpg';
    if (query.contains('manali') || query.contains('himachal')) return 'assets/images/manali.jpg';
    if (query.contains('kerala')) return 'assets/images/kerala.jpg';
    return 'assets/images/trip_placeholder.jpg';
  }

  void _confirmDeleteTrip(BuildContext context, String tripId, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "$title"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () {
              Navigator.pop(ctx);
              Provider.of<TripProvider>(context, listen: false).deleteTrip(tripId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted "$title"')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvasParchment,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceBlack : AppColors.canvas,
        title: Text(
          'My Trips',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 26),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.bodyMuted : AppColors.inkMuted48,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Active'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Consumer<TripProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final upcomingTrips = provider.trips.where((t) => t.status == 'UPCOMING').toList();
          final activeTrips = provider.trips.where((t) => t.status == 'ACTIVE').toList();
          final pastTrips = provider.trips.where((t) => t.status == 'COMPLETED' || t.status == 'PAST').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTripGrid(upcomingTrips, isDark, 'No upcoming trips planned yet.'),
              _buildTripGrid(activeTrips, isDark, 'No active trips right now.'),
              _buildTripGrid(pastTrips, isDark, 'No past journeys in your history.'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTripGrid(List trips, bool isDark, String emptyMessage) {
    if (trips.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flight_takeoff,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Explore & Plan a Trip'),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 380,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 0.88,
      ),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        final imagePath = _getTripImage(trip.destinationName, trip.title);
        final isCompleted = trip.status == 'COMPLETED';
        final isActive = trip.status == 'ACTIVE';

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceTile2 : AppColors.canvas,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white12 : AppColors.hairline,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ItineraryScreen(trip: trip)),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AppImage(
                      imagePath: imagePath,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          trip.status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isCompleted
                                ? const Color(0xFF34C759)
                                : (isActive ? const Color(0xFF2997FF) : Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          padding: const EdgeInsets.all(6),
                        ),
                        tooltip: 'Delete Trip',
                        onPressed: () => _confirmDeleteTrip(context, trip.id, trip.title),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.flight_takeoff,
                            size: 14,
                            color: isDark ? AppColors.primaryOnDark : AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Departs: ${AppUtils.formatDepartureDate(trip.startDate)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${trip.durationInDays} Days Itinerary',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                            ),
                          ),
                          const Text(
                            'View Plan →',
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
        );
      },
    );
  }
}
