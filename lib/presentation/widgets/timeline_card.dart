import 'package:flutter/material.dart';
import '../../core/utils.dart';
import '../../data/models/activity_model.dart';
import '../../core/theme.dart';
import 'spot_details_sheet.dart';

class TimelineCard extends StatelessWidget {
  final ActivityModel activity;
  final bool isTripActive;

  const TimelineCard({
    Key? key,
    required this.activity,
    required this.isTripActive,
  }) : super(key: key);

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
    final bool isCurrent = isTripActive && 
        AppUtils.isCurrentActivity(activity.startTime, activity.endTime);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        SpotDetailsSheet.show(context, activity);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrent 
              ? AppColors.primaryFocus 
              : (isDark ? Colors.transparent : AppColors.hairline),
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Column
            SizedBox(
              width: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppUtils.formatTime(activity.startTime),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppUtils.formatTime(activity.endTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent ? AppColors.primary : (isDark ? AppColors.surfaceTile3 : AppColors.surfacePearl),
              ),
              child: Icon(
                _getIconForType(activity.activityType), 
                color: isCurrent ? AppColors.canvas : (isDark ? AppColors.canvas : AppColors.ink),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 24),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (activity.cost > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceTile3 : AppColors.surfacePearl,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        '\$${activity.cost.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.canvas : AppColors.ink,
                        ),
                      ),
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
