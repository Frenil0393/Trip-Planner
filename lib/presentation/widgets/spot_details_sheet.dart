import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/models/activity_model.dart';
import '../../core/utils.dart';
import 'app_image.dart';

class SpotDetailsSheet extends StatelessWidget {
  final ActivityModel activity;

  const SpotDetailsSheet({super.key, required this.activity});

  static void show(BuildContext context, ActivityModel activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SpotDetailsSheet(activity: activity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceTile2 : AppColors.canvas,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.transparent,
            ),
          ),
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white30 : Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppImage(
                        imagePath: activity.imageUrl ?? 'assets/images/spot_default.jpg',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              activity.activityType.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceTile3 : AppColors.surfacePearl,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? Colors.white10 : AppColors.hairline,
                              ),
                            ),
                            child: Text(
                              AppUtils.formatCurrency(activity.cost),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: activity.cost > 0
                                    ? (isDark ? AppColors.primaryOnDark : AppColors.primary)
                                    : (isDark ? AppColors.bodyMuted : AppColors.inkMuted80),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        activity.title,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 26,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80),
                          const SizedBox(width: 8),
                          Text(
                            '${AppUtils.formatTime(activity.startTime)} - ${AppUtils.formatTime(activity.endTime)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (activity.location != null && activity.location!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                activity.location!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        'About this Activity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                      if (activity.notes != null && activity.notes!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  activity.notes!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? AppColors.canvas : AppColors.ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
