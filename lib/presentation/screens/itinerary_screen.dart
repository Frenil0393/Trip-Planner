import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/trip_model.dart';
import '../../providers/trip_provider.dart';

import '../widgets/timeline_card.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';

class ItineraryScreen extends StatefulWidget {
  final TripModel trip;

  const ItineraryScreen({super.key, required this.trip});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  // 0 means "All Days", 1 means Day 1, 2 means Day 2, etc.
  int _selectedDayFilter = 0;
  bool _isBudgetPanelExpanded = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<TripProvider>(context, listen: false)
          .loadActivitiesForTrip(widget.trip.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<TripProvider>(
      builder: (context, provider, child) {
        final isTripActive = widget.trip.status == 'ACTIVE';
        final isTripCompleted = widget.trip.status == 'COMPLETED';

        // Budget Calculations by Category
        double transitCost = 0.0;
        double hotelCost = 0.0;
        double foodCost = 0.0;
        double sightseeingCost = 0.0;
        int completedCount = 0;

        for (final act in provider.currentActivities) {
          if (act.isCompleted) completedCount++;
          final type = act.activityType.toUpperCase();
          if (type == 'TRANSPORT') {
            transitCost += act.cost;
          } else if (type == 'HOTEL') {
            hotelCost += act.cost;
          } else if (type == 'FOOD') {
            foodCost += act.cost;
          } else if (type == 'SIGHTSEEING') {
            sightseeingCost += act.cost;
          }
        }

        final totalCost = transitCost + hotelCost + foodCost + sightseeingCost;

        // Group activities by day
        final Map<int, List> grouped = {};
        for (final act in provider.currentActivities) {
          grouped.putIfAbsent(act.dayNumber, () => []).add(act);
        }

        final availableDays = grouped.keys.toList()..sort();

        // Filtered activities list
        List activitiesToDisplay;
        if (_selectedDayFilter == 0) {
          activitiesToDisplay = provider.currentActivities;
        } else {
          activitiesToDisplay = grouped[_selectedDayFilter] ?? [];
        }

        return Scaffold(
          backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvas,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              widget.trip.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            actions: [
              // Active status badge
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isTripCompleted
                      ? const Color(0xFF34C759).withValues(alpha: 0.15)
                      : (isTripActive
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : (isDark ? Colors.white12 : AppColors.hairline)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.trip.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isTripCompleted
                        ? const Color(0xFF34C759)
                        : (isTripActive
                            ? AppColors.primary
                            : (isDark ? AppColors.canvas : AppColors.ink)),
                  ),
                ),
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    // 1. Overall Trip Header
                    SliverToBoxAdapter(
                      child: _buildOverallTripHeader(
                        context,
                        isDark,
                        totalCost,
                        completedCount,
                        provider.currentActivities.length,
                      ),
                    ),

                    // 2. Financial Summary & Cost Estimator Panel
                    SliverToBoxAdapter(
                      child: _buildFinancialSummaryPanel(
                        context,
                        isDark,
                        transitCost: transitCost,
                        hotelCost: hotelCost,
                        foodCost: foodCost,
                        sightseeingCost: sightseeingCost,
                        totalCost: totalCost,
                      ),
                    ),

                    // 3. Scrollable Days Navigation Bar
                    SliverToBoxAdapter(
                      child: _buildScrollableDaysNavigation(
                        isDark,
                        availableDays,
                        grouped,
                      ),
                    ),

                    // 4. Chronological Activity Cards List
                    if (activitiesToDisplay.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'No activities scheduled for this day.',
                            style: TextStyle(
                              color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 96, top: 12),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final act = activitiesToDisplay[index];
                              return TimelineCard(
                                activity: act,
                                isTripActive: isTripActive,
                                onToggleComplete: () {
                                  provider.toggleActivityCompletion(
                                    act.id,
                                    widget.trip.id,
                                  );
                                },
                              );
                            },
                            childCount: activitiesToDisplay.length,
                          ),
                        ),
                      ),
                  ],
                ),
          bottomNavigationBar: _buildBottomActionBar(
            context,
            provider,
            isTripActive,
            isTripCompleted,
          ),
        );
      },
    );
  }

  /// 1. Overall Trip Header
  Widget _buildOverallTripHeader(
    BuildContext context,
    bool isDark,
    double totalCost,
    int completedCount,
    int totalCount,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTile2 : AppColors.canvasParchment,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.transparent : AppColors.hairline,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Title & Destination
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.trip.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Prominent Departure Date & Meta Row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceTile3 : AppColors.surfacePearl,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.white10 : AppColors.hairline,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flight_takeoff,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Departure: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                            ),
                          ),
                          Text(
                            AppUtils.formatDepartureDate(widget.trip.startDate),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.ink,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${widget.trip.durationInDays} Days (${widget.trip.formattedDateRange})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.primaryOnDark : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),

          // Active Completion Tracking Progress Bar
          if (totalCount > 0) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trip Progress: $completedCount of $totalCount activities completed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                  ),
                ),
                Text(
                  '${((completedCount / totalCount) * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: totalCount > 0 ? completedCount / totalCount : 0.0,
                minHeight: 6,
                backgroundColor: isDark ? Colors.white10 : AppColors.hairline,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 2. Dedicated Financial Summary & Cost Estimator Panel
  Widget _buildFinancialSummaryPanel(
    BuildContext context,
    bool isDark, {
    required double transitCost,
    required double hotelCost,
    required double foodCost,
    required double sightseeingCost,
    required double totalCost,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTile2 : AppColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel Title & Toggle
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            onTap: () {
              setState(() {
                _isBudgetPanelExpanded = !_isBudgetPanelExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Financial Summary',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Estimated budget by category',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Total: ${AppUtils.formatCurrency(totalCost)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isBudgetPanelExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Breakdown Grid
          if (_isBudgetPanelExpanded) ...[
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : AppColors.hairline,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildBudgetCategoryTile(
                        icon: Icons.train,
                        category: 'Transit',
                        amount: transitCost,
                        color: const Color(0xFF007AFF),
                        isDark: isDark,
                        width: (constraints.maxWidth - 12) / 2 > 150
                            ? (constraints.maxWidth - 12) / 2
                            : constraints.maxWidth,
                      ),
                      _buildBudgetCategoryTile(
                        icon: Icons.hotel,
                        category: 'Hotel Stays',
                        amount: hotelCost,
                        color: const Color(0xFF5856D6),
                        isDark: isDark,
                        width: (constraints.maxWidth - 12) / 2 > 150
                            ? (constraints.maxWidth - 12) / 2
                            : constraints.maxWidth,
                      ),
                      _buildBudgetCategoryTile(
                        icon: Icons.restaurant,
                        category: 'Food & Dining',
                        amount: foodCost,
                        color: const Color(0xFF34C759),
                        isDark: isDark,
                        width: (constraints.maxWidth - 12) / 2 > 150
                            ? (constraints.maxWidth - 12) / 2
                            : constraints.maxWidth,
                      ),
                      _buildBudgetCategoryTile(
                        icon: Icons.camera_alt,
                        category: 'Sightseeing Entry',
                        amount: sightseeingCost,
                        color: const Color(0xFFFF9500),
                        isDark: isDark,
                        width: (constraints.maxWidth - 12) / 2 > 150
                            ? (constraints.maxWidth - 12) / 2
                            : constraints.maxWidth,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBudgetCategoryTile({
    required IconData icon,
    required String category,
    required double amount,
    required Color color,
    required bool isDark,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTile3 : AppColors.surfacePearl,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.hairline,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppUtils.formatCurrency(amount),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Scrollable Days Navigation Tabs/Pills
  Widget _buildScrollableDaysNavigation(
    bool isDark,
    List<int> availableDays,
    Map<int, List> grouped,
  ) {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // "All Days" Pill
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                'All Days',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: _selectedDayFilter == 0
                      ? Colors.white
                      : (isDark ? AppColors.canvas : AppColors.ink),
                ),
              ),
              selected: _selectedDayFilter == 0,
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedDayFilter = 0;
                  });
                }
              },
            ),
          ),

          // Day 1, Day 2, Day 3... Pills
          ...availableDays.map((day) {
            final count = grouped[day]?.length ?? 0;
            final isSelected = _selectedDayFilter == day;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                avatar: isSelected
                    ? null
                    : const Icon(Icons.event_note, size: 14, color: AppColors.primary),
                label: Text(
                  'Day $day ($count)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.canvas : AppColors.ink),
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
                onSelected: (selected) {
                  setState(() {
                    _selectedDayFilter = selected ? day : 0;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Bottom Action Bar for Active Tracking
  Widget? _buildBottomActionBar(
    BuildContext context,
    TripProvider provider,
    bool isTripActive,
    bool isTripCompleted,
  ) {
    if (isTripCompleted) return null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: isTripActive
            ? ElevatedButton.icon(
                onPressed: () {
                  provider.completeTrip(widget.trip.id);
                  widget.trip.status = 'COMPLETED';
                  setState(() {});
                },
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: const Text('Complete Trip'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34C759),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )
            : ElevatedButton.icon(
                onPressed: () {
                  provider.startTrip(widget.trip.id);
                  widget.trip.status = 'ACTIVE';
                  setState(() {});
                },
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text('Start Trip (Active Tracking)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
      ),
    );
  }
}
