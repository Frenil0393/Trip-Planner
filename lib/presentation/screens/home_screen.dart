import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/trip_provider.dart';
import 'my_trips_screen.dart';
import 'profile_screen.dart';
import 'destination_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _generateTrip(String prompt) {
    if (prompt.isEmpty) return;
    Provider.of<TripProvider>(context, listen: false).createTrip(prompt, _selectedDate).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyTripsScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? AppColors.surfaceBlack : AppColors.canvas,
            actions: [
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTripsScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
            ],
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
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 48,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Where to?',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 56,
                                letterSpacing: -0.28,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Let AI craft your perfect itinerary.',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DestinationDetailsScreen(destinationName: 'Paris')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                          ),
                          child: const Text('Explore Destinations'),
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              color: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      children: [
                        TextField(
                          controller: _promptController,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'e.g. 3-day romantic weekend in Paris focusing on art',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(12),
                                ),
                                onPressed: () => _generateTrip(_promptController.text),
                                child: const Icon(Icons.arrow_upward),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _selectDate(context),
                              icon: const Icon(Icons.calendar_today, size: 16),
                              label: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isDark ? AppColors.canvas : AppColors.ink,
                                side: BorderSide(
                                  color: isDark ? AppColors.hairline.withOpacity(0.2) : AppColors.hairline,
                                ),
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
          ),
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? AppColors.surfaceTile2 : AppColors.canvasParchment,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
              child: Column(
                children: [
                  Text(
                    'Featured Trips',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Get inspired by our curated templates.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1024),
                      child: Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: AppConstants.preBakedTemplates.map((template) {
                          return SizedBox(
                            width: 300,
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  _promptController.text = template['prompt'];
                                  _generateTrip(template['prompt']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        template['title'],
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        template['prompt'],
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                            ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 24),
                                      const Text(
                                        'Plan Trip',
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
                            ),
                          );
                        }).toList(),
                      ),
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
}
