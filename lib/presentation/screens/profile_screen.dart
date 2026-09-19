import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../providers/ui_provider.dart';
import 'auth_gate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final tripProvider = Provider.of<TripProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvasParchment,
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: isDark ? AppColors.surfaceTile1 : AppColors.canvasParchment,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    user?.initials ?? 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'Guest Traveler',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'Not logged in',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                      ),
                ),
                const SizedBox(height: 8),
                if (user != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceTile3 : AppColors.canvas,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Member since ${AppUtils.formatDate(user.createdAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Total Trips',
                  value: '${tripProvider.trips.length}',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Upcoming',
                  value: '${tripProvider.trips.where((t) => t.isUpcoming).length}',
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          _buildSectionHeader(context, 'Preferences'),
          _buildUtilityCard(
            context,
            child: Consumer<UiProvider>(
              builder: (context, uiProvider, child) {
                return SwitchListTile.adaptive(
                  title: Text('Dark Mode', style: Theme.of(context).textTheme.bodyLarge),
                  value: uiProvider.isDarkMode,
                  onChanged: (val) => uiProvider.toggleTheme(),
                  activeTrackColor: AppColors.primary,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Account'),
          _buildUtilityCard(
            context,
            child: ListTile(
              title: Text('Currency', style: Theme.of(context).textTheme.bodyLarge),
              trailing: Text('USD (\$)', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 48),
          Center(
            child: TextButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                  (route) => false,
                );
              },
              child: const Text('Sign Out', style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String value, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTile2 : AppColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.transparent : AppColors.hairline,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildUtilityCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTile2 : AppColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.transparent : AppColors.hairline,
        ),
      ),
      child: child,
    );
  }
}
