import 'package:flutter/material.dart';
import '../../core/theme.dart';

class DestinationDetailsScreen extends StatelessWidget {
  final String destinationName;
  
  const DestinationDetailsScreen({
    Key? key,
    required this.destinationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  Image.network(
                    'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?q=80&w=2020&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.7),
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
                          destinationName,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 56,
                                letterSpacing: -0.28,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'The city of light, love, and endless inspiration.',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return _buildSpotCard(
                          context,
                          title: 'Eiffel Tower',
                          description: 'Iconic wrought-iron spire.',
                          imageUrl: 'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?q=80&w=600&auto=format&fit=crop',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return _buildSpotCard(
                          context,
                          title: 'Le Jules Verne',
                          description: 'Fine dining with a view.',
                          imageUrl: 'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?q=80&w=600&auto=format&fit=crop',
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
    );
  }

  Widget _buildSpotCard(BuildContext context, {required String title, required String description, required String imageUrl}) {
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
