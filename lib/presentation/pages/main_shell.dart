import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/presentation/widgets/responsive_layout.dart';
import 'package:artificial_flash/presentation/pages/home_page.dart';
import 'package:artificial_flash/presentation/pages/data_page.dart';
import 'package:artificial_flash/presentation/pages/model_config_page.dart';
import 'package:artificial_flash/presentation/pages/training_page.dart';
import 'package:artificial_flash/presentation/pages/models_page.dart';
import 'package:artificial_flash/presentation/pages/settings_page.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    final pages = [
      const HomePage(),
      const DataPage(),
      const ModelConfigPage(),
      const TrainingPage(),
      const ModelsPage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        if (isDesktop) {
          return _DesktopShell(currentIndex: currentIndex, pages: pages);
        }

        return Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              ref.read(currentIndexProvider.notifier).state = index;
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.folder_outlined),
                selectedIcon: Icon(Icons.folder),
                label: 'Data',
              ),
              NavigationDestination(
                icon: Icon(Icons.model_training_outlined),
                selectedIcon: Icon(Icons.model_training),
                label: 'Model',
              ),
              NavigationDestination(
                icon: Icon(Icons.play_circle_outline),
                selectedIcon: Icon(Icons.play_circle),
                label: 'Train',
              ),
              NavigationDestination(
                icon: Icon(Icons.storage_outlined),
                selectedIcon: Icon(Icons.storage),
                label: 'Models',
              ),
            ],
          ),
          drawer: _buildDrawer(context),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.psychology, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'ArtificialFlash',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'AI Training Assistant',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
              _showHelpDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to ArtificialFlash!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Go to Data to upload your training dataset'),
              Text('2. Go to Model to configure your AI model'),
              Text('3. Go to Train to start training'),
              Text('4. Check Models to view trained models'),
              SizedBox(height: 16),
              Text('For more help, visit our documentation.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'ArtificialFlash',
        applicationVersion: '1.0.0',
        applicationIcon: const Icon(Icons.psychology, size: 48),
        children: const [
          Text('A beginner-friendly AI model training assistant.'),
          SizedBox(height: 8),
          Text('Supports Visual, NLP, and Generative models.'),
        ],
      ),
    );
  }
}

class _DesktopShell extends ConsumerWidget {
  final int currentIndex;
  final List<Widget> pages;

  const _DesktopShell({required this.currentIndex, required this.pages});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(connectionConfigProvider);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 220,
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'ArtificialFlash',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'AI Training Assistant',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _NavItem(
                        icon: Icons.home,
                        label: 'Home',
                        isSelected: currentIndex == 0,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 0,
                      ),
                      _NavItem(
                        icon: Icons.folder,
                        label: 'Data',
                        isSelected: currentIndex == 1,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 1,
                      ),
                      _NavItem(
                        icon: Icons.model_training,
                        label: 'Model',
                        isSelected: currentIndex == 2,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 2,
                      ),
                      _NavItem(
                        icon: Icons.play_circle,
                        label: 'Train',
                        isSelected: currentIndex == 3,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 3,
                      ),
                      _NavItem(
                        icon: Icons.storage,
                        label: 'Models',
                        isSelected: currentIndex == 4,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 4,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _NavItem(
                        icon: Icons.settings,
                        label: 'Settings',
                        isSelected: false,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: config.isConnected
                              ? AppColors.success.withAlpha(26)
                              : AppColors.error.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              config.isConnected
                                  ? Icons.cloud_done
                                  : Icons.cloud_off,
                              color: config.isConnected
                                  ? AppColors.success
                                  : AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              config.isConnected
                                  ? 'Server Connected'
                                  : 'Offline Mode',
                              style: TextStyle(
                                color: config.isConnected
                                    ? AppColors.success
                                    : AppColors.error,
                                fontSize: 12,
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
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: pages[currentIndex]),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected
            ? AppColors.primary.withAlpha(26)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : Colors.grey,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
