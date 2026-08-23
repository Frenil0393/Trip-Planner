import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/trip_model.dart';
import '../../providers/trip_provider.dart';
import '../widgets/timeline_card.dart';

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
    return Consumer<TripProvider>(
      builder: (context, provider, child) {
        final isTripActive = widget.trip.status == 'ACTIVE';

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.trip.title),
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildItineraryList(provider, isTripActive),
          bottomNavigationBar: widget.trip.status == 'UPCOMING'
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      provider.startTrip(widget.trip.id);
                      widget.trip.status = 'ACTIVE';
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Start Trip', style: TextStyle(fontSize: 18)),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildItineraryList(TripProvider provider, bool isTripActive) {
    if (provider.currentActivities.isEmpty) {
      return const Center(child: Text('No activities planned yet.'));
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Day $day',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 20),
              ),
            ),
            ...activities.map((activity) => TimelineCard(
                  activity: activity,
                  isTripActive: isTripActive,
                )).toList(),
          ],
        );
      },
    );
  }
}
