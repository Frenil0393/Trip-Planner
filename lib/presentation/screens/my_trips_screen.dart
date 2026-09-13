import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trip_provider.dart';
import '../../core/utils.dart';
import '../../core/theme.dart';
import 'itinerary_screen.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({Key? key}) : super(key: key);

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => Provider.of<TripProvider>(context, listen: false).loadTrips());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
      appBar: AppBar(
        title: Text('My Trips', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.bodyMuted : AppColors.inkMuted48,
          indicatorColor: AppColors.primary,
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
          final pastTrips = provider.trips.where((t) => t.status == 'PAST').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTripGrid(upcomingTrips, isDark),
              _buildTripGrid(activeTrips, isDark),
              _buildTripGrid(pastTrips, isDark),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTripGrid(List trips, bool isDark) {
    if (trips.isEmpty) {
      return Center(
        child: Text(
          'No trips found.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
              ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 0.85,
      ),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ItineraryScreen(trip: trip)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1501504905252-473c47e087f8?q=80&w=600&auto=format&fit=crop', // Placeholder for trip
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    trip.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppUtils.formatDate(trip.startDate)} - ${AppUtils.formatDate(trip.endDate)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                        ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'View Plan',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
