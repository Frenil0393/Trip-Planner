import 'package:flutter/material.dart';
import '../../core/utils.dart';
import '../../data/models/activity_model.dart';

class TimelineCard extends StatefulWidget {
  final ActivityModel activity;
  final bool isTripActive;

  const TimelineCard({
    Key? key,
    required this.activity,
    required this.isTripActive,
  }) : super(key: key);

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'TRANSPORT':
        return Icons.flight_takeoff;
      case 'HOTEL':
        return Icons.hotel;
      case 'SIGHTSEEING':
        return Icons.camera_alt;
      case 'FOOD':
        return Icons.restaurant;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = widget.isTripActive && 
        AppUtils.isCurrentActivity(widget.activity.startTime, widget.activity.endTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isCurrent ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Text(
                  AppUtils.formatTime(widget.activity.startTime),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text('|', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  AppUtils.formatTime(widget.activity.endTime),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Icon
          isCurrent
              ? ScaleTransition(
                  scale: _pulseAnimation,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(_getIconForType(widget.activity.activityType), color: Colors.white),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  child: Icon(_getIconForType(widget.activity.activityType), color: Theme.of(context).primaryColor),
                ),
          
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.activity.title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.activity.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${widget.activity.cost.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
