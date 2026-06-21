import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'screens/ads_screen.dart';
import 'screens/charges_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/discounts_screen.dart';
import 'screens/earnings_screen.dart';
import 'screens/refunds_screen.dart';
import 'widgets/theme.dart';

void main() {
  runApp(const RestoApp());
}

class RestoApp extends StatefulWidget {
  const RestoApp({super.key});

  @override
  State<RestoApp> createState() => _RestoAppState();
}

class _RestoAppState extends State<RestoApp> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;
  bool _isNavExpanded = false;

  final _screens = const [
    DashboardScreen(),
    EarningsScreen(),
    AdsScreen(),
    ChargesScreen(),
    DiscountsScreen(),
    RefundsScreen(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showAboutApp(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black26,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.78,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'About Resto',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Resto is a restaurant management dashboard designed to help small restaurant owners track earnings, ads, charges, discounts, refunds and overall performance in one place.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'What you can do',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailBullet('View live sales and earnings summaries.'),
                  _buildDetailBullet(
                    'Monitor ads, discounts and refund activity.',
                  ),
                  _buildDetailBullet('Manage charges and promotional pricing.'),
                  _buildDetailBullet(
                    'Securely sign in to access personalized settings.',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Why it helps',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Resto helps you stay focused on your restaurant business by presenting the most important financial metrics and workflows in a clean, easy-to-use interface.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  Widget _buildDetailBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4, right: 10),
            child: Icon(Icons.check_circle_outline, size: 18),
          ),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.62;
        return SafeArea(
          child: Container(
            height: height,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your account and learn more about the app.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: theme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in or log in to access your restaurant dashboard settings and saved preferences.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Sign In'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text('Log In'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: theme.cardColor,
                  leading: Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('About the application'),
                  subtitle: const Text(
                    'Read the full app documentation and details',
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onBackground,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showAboutApp(context);
                  },
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = _isDarkMode ? AppTheme.dark : AppTheme.light;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final expandedNavWidth = math.min(
      450.0,
      math.max(74.0, screenWidth - 32.0),
    );

    Widget buildNavItem(IconData icon, String label, int index) {
      final isSelected = _selectedIndex == index;
      return Tooltip(
        message: label,
        child: IconButton(
          icon: Icon(
            icon,
            color: isSelected
                ? currentTheme.colorScheme.primary
                : (currentTheme.brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.black54),
          ),
          onPressed: () => _onNavTap(index),
        ),
      );
    }

    return MaterialApp(
      title: 'Resto Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Listener(
            onPointerDown: (_) {
              if (_isNavExpanded) {
                setState(() => _isNavExpanded = false);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: AppBar(
              elevation: 0,
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              centerTitle: false,
              title: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: currentTheme.colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: currentTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Resto',
                        style: TextStyle(
                          color: currentTheme.colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Restaurant dashboard',
                        style: TextStyle(
                          color: currentTheme.textTheme.bodyMedium?.color,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: _toggleTheme,
                  tooltip: _isDarkMode
                      ? 'Switch to light mode'
                      : 'Switch to dark mode',
                ),
                IconButton(
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: currentTheme.colorScheme.primary
                        .withValues(alpha: 0.12),
                    child: Icon(
                      Icons.person,
                      size: 18,
                      color: currentTheme.colorScheme.primary,
                    ),
                  ),
                  onPressed: () => _showProfileSheet(context),
                  tooltip: 'Profile',
                ),
                const SizedBox(width: 8),
              ],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
            ),
          ),
        ),
        body: Listener(
          onPointerDown: (_) {
            if (_isNavExpanded) {
              setState(() => _isNavExpanded = false);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Container(
              color: currentTheme.scaffoldBackgroundColor,
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 74,
          width: _isNavExpanded ? expandedNavWidth : 74.0,
          decoration: BoxDecoration(
            color: currentTheme.cardColor,
            borderRadius: BorderRadius.circular(37),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(37),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: math.max(0.0, expandedNavWidth - 74.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildNavItem(Icons.dashboard, 'Dash', 0),
                            buildNavItem(Icons.show_chart, 'Earnings', 1),
                            buildNavItem(Icons.campaign, 'Ads', 2),
                            buildNavItem(
                              Icons.account_balance_wallet,
                              'Charges',
                              3,
                            ),
                            buildNavItem(Icons.local_offer, 'Discounts', 4),
                            buildNavItem(Icons.refresh, 'Refunds', 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 74,
                    child: Center(
                      child: IconButton(
                        iconSize: 28,
                        icon: Icon(
                          _isNavExpanded ? Icons.arrow_forward_ios : Icons.apps,
                          color: currentTheme.colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNavExpanded = !_isNavExpanded;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
