import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/ui_provider.dart';
import 'auth_gate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.person, size: 48, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Traveler',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'traveler@example.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.bodyMuted : AppColors.inkMuted80,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _buildSectionHeader(context, 'Preferences'),
          _buildUtilityCard(
            context,
            child: Consumer<UiProvider>(
              builder: (context, uiProvider, child) {
                return SwitchListTile.adaptive(
                  title: Text('Dark Mode', style: Theme.of(context).textTheme.bodyLarge),
                  value: uiProvider.isDarkMode,
                  onChanged: (val) {
                    uiProvider.toggleTheme();
                  },
                  activeColor: AppColors.primary,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Account'),
          _buildUtilityCard(
            context,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.payment),
                  title: Text('Payment Methods', style: Theme.of(context).textTheme.bodyLarge),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                Divider(height: 1, color: isDark ? AppColors.surfaceTile3 : AppColors.dividerSoft),
                ListTile(
                  leading: const Icon(Icons.card_travel),
                  title: Text('Travel Preferences', style: Theme.of(context).textTheme.bodyLarge),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                  (route) => false,
                );
              },
              child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
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
