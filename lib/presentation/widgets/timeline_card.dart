import 'package:flutter/material.dart';
import '../../core/utils.dart';
import '../../data/models/activity_model.dart';
import '../../core/theme.dart';
import 'spot_details_sheet.dart';

class TimelineCard extends StatelessWidget {
  final ActivityModel activity;
  final bool isTripActive;
  final VoidCallback? onToggleComplete;

  const TimelineCard({
    super.key,
    required this.activity,
    required this.isTripActive,
    this.onToggleComplete,
  });

  /// Visual icon matching the activity type as specified:
  /// - Plane or train for transport
  /// - Bed for hotel
  /// - Camera for sightseeing
  /// - Plate/fork for food
  IconData _getIconForType() {
    final type = activity.activityType.toUpperCase();
    final lowerTitle = activity.title.toLowerCase();

    switch (type) {
      case 'TRANSPORT':
        if (lowerTitle.contains('train') || lowerTitle.contains('rail') || lowerTitle.contains('eurostar')) {
          return Icons.train;
        }
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

  Color _getCategoryColor(bool isDark) {
    switch (activity.activityType.toUpperCase()) {
      case 'TRANSPORT':
        return const Color(0xFF007AFF); // Blue
      case 'HOTEL':
        return const Color(0xFF5856D6); // Purple/Indigo
      case 'SIGHTSEEING':
        return const Color(0xFFFF9500); // Amber/Orange
      case 'FOOD':
        return const Color(0xFF34C759); // Green
      default:
        return AppColors.primary;
    }
  }

  String _getCategoryLabel() {
    final type = activity.activityType.toUpperCase();
    final lower = activity.title.toLowerCase();

    switch (type) {
      case 'TRANSPORT':
        return lower.contains('train') ? 'Train Transit' : 'Flight Transit';
      case 'HOTEL':
        return 'Accommodation';
      case 'SIGHTSEEING':
        return 'Point of Interest';
      case 'FOOD':
        if (lower.contains('lunch')) return 'Lunch';
        if (lower.contains('dinner')) return 'Dinner';
        return 'Dining';
      default:
        return 'Activity';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = isTripActive &&
        AppUtils.isCurrentActivity(activity.startTime, activity.endTime);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryColor = _getCategoryColor(isDark);
    final timeRange =
        '${AppUtils.formatTime(activity.startTime)} – ${AppUtils.formatTime(activity.endTime)}';

    return GestureDetector(
      onTap: () {
        SpotDetailsSheet.show(context, activity);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: activity.isCompleted
              ? (isDark ? AppColors.surfaceTile2.withValues(alpha: 0.6) : AppColors.surfacePearl)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrent
                ? AppColors.primaryFocus
                : (isDark
                    ? (activity.isCompleted ? Colors.transparent : Colors.white12)
                    : (activity.isCompleted ? AppColors.dividerSoft : AppColors.hairline)),
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Meta Row: Time Tag + Category Badge + Cost Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceTile3 : AppColors.surfacePearl,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white10 : AppColors.hairline,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 13,
                        color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeRange,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.canvas : AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),

                // Cost Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: activity.cost > 0
                        ? categoryColor.withValues(alpha: 0.12)
                        : (isDark ? Colors.white10 : AppColors.surfacePearl),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    activity.cost > 0
                        ? '\$${activity.cost.toStringAsFixed(2)}'
                        : 'Free Entry',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: activity.cost > 0
                          ? categoryColor
                          : (isDark ? AppColors.bodyMuted : AppColors.inkMuted80),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Middle Main Row: Category Icon + Title/Description + Interactive Check
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Icon with tinted circular container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: categoryColor.withValues(alpha: 0.15),
                    border: Border.all(
                      color: categoryColor.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _getIconForType(),
                    color: categoryColor,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 16),

                // Title & Details Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag Label
                      Row(
                        children: [
                          Text(
                            _getCategoryLabel().toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: categoryColor,
                            ),
                          ),
                          if (isCurrent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.primaryFocus,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NOW HAPPENING',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Card Title
                      Text(
                        activity.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              decoration: activity.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: activity.isCompleted
                                  ? (isDark ? AppColors.bodyMuted : AppColors.inkMuted48)
                                  : null,
                            ),
                      ),
                      const SizedBox(height: 6),

                      // Description Details
                      Text(
                        activity.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                            ),
                      ),

                      // Specific Activity Details (Notes / Entry / Location)
                      if (activity.location != null && activity.location!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: isDark ? AppColors.bodyMuted : AppColors.inkMuted48,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                activity.location!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted48,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Checkbox / Completion Toggle for active tracking
                if (onToggleComplete != null || isTripActive) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      activity.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: activity.isCompleted
                          ? const Color(0xFF34C759)
                          : (isDark ? Colors.white24 : AppColors.hairline),
                      size: 24,
                    ),
                    tooltip: activity.isCompleted ? 'Mark as incomplete' : 'Mark as completed',
                    onPressed: onToggleComplete,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
