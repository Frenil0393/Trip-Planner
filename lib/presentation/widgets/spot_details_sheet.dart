import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/models/activity_model.dart';
import '../../core/utils.dart';

class SpotDetailsSheet extends StatelessWidget {
  final ActivityModel activity;

  const SpotDetailsSheet({Key? key, required this.activity}) : super(key: key);

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
            color: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1543349689-9a4d426bee8e?q=80&w=1000&auto=format&fit=crop', // Placeholder image based on activity type ideally
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        activity.title,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80),
                          const SizedBox(width: 8),
                          Text(
                            '${AppUtils.formatTime(activity.startTime)} - ${AppUtils.formatTime(activity.endTime)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Details',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        activity.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 48),
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
