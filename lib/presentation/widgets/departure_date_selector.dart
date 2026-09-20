import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';

/// Reusable Apple-style Departure Date Selector Tile.
///
/// Provides a clear, high-contrast visual display of the selected departure date,
/// a relative time pill (e.g., 'Today', 'Tomorrow', 'In X days'), and an interactive
/// calendar picker dialog tuned for both Light and Dark themes.
class DepartureDateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String label;

  const DepartureDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label = 'DEPARTURE DATE',
  });

  String _getRelativeLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff > 1 && diff <= 30) return 'In $diff days';
    if (diff > 30) return 'In ${(diff / 30).round()} months';
    return 'Selected Date';
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final firstAllowed = DateTime(now.year, now.month, now.day);
    final lastAllowed = now.add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(firstAllowed) ? firstAllowed : selectedDate,
      firstDate: firstAllowed,
      lastDate: lastAllowed,
      helpText: 'SELECT DEPARTURE DATE',
      confirmText: 'SET DEPARTURE',
      cancelText: 'CANCEL',
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final relativeText = _getRelativeLabel(selectedDate);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _pickDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? Colors.white12 : AppColors.hairline,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Calendar icon badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Date text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isDark ? AppColors.primaryOnDark : AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          relativeText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppUtils.formatDepartureDate(selectedDate),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            // Action Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : AppColors.canvas,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: isDark ? Colors.white24 : AppColors.hairline,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit_calendar_outlined,
                    size: 14,
                    color: isDark ? AppColors.primaryOnDark : AppColors.primary,
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
