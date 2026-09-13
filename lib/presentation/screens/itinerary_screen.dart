import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/trip_model.dart';
import '../../providers/trip_provider.dart';
import '../widgets/timeline_card.dart';
import '../../core/theme.dart';

class ItineraryScreen extends StatefulWidget {
  final TripModel trip;

  const ItineraryScreen({Key? key, required this.trip}) : super(key: key);

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
        Provider.of<TripProvider>(context, listen: false).loadActivitiesForTrip(widget.trip.id));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<TripProvider>(
      builder: (context, provider, child) {
        final isTripActive = widget.trip.status == 'ACTIVE';

        return Scaffold(
          backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
          appBar: AppBar(
            title: Text(widget.trip.title, style: Theme.of(context).textTheme.titleLarge),
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildItineraryList(provider, isTripActive, isDark),
          bottomNavigationBar: widget.trip.status == 'UPCOMING'
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      onPressed: () {
                        provider.startTrip(widget.trip.id);
                        widget.trip.status = 'ACTIVE';
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                      ),
                      child: const Text('Start Trip'),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildItineraryList(TripProvider provider, bool isTripActive, bool isDark) {
    if (provider.currentActivities.isEmpty) {
      return Center(
        child: Text(
          'No activities planned yet.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
              ),
        ),
      );
    }

    // Group activities by day
    Map<int, List> groupedActivities = {};
    for (var act in provider.currentActivities) {
      if (!groupedActivities.containsKey(act.dayNumber)) {
        groupedActivities[act.dayNumber] = [];
      }
      groupedActivities[act.dayNumber]!.add(act);
    }

    return ListView.builder(
      itemCount: groupedActivities.keys.length,
      itemBuilder: (context, index) {
        int day = groupedActivities.keys.elementAt(index);
        List activities = groupedActivities[day]!;

        // Alternating background colors
        bool isEven = index % 2 == 0;
        Color tileColor = isDark 
            ? (isEven ? AppColors.surfaceTile1 : AppColors.surfaceTile2)
            : (isEven ? AppColors.canvas : AppColors.canvasParchment);

        return Container(
          color: tileColor,
          padding: const EdgeInsets.symmetric(vertical: 80.0), // Section padding from DESIGN.md
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Text(
                      'Day $day',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ...activities.map((activity) => TimelineCard(
                        activity: activity,
                        isTripActive: isTripActive,
                      )).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
