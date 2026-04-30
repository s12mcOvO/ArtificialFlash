import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/presentation/pages/home_page.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/presentation/pages/data_page.dart';
import 'package:artificial_flash/presentation/pages/data_marketplace_page.dart';
import 'package:artificial_flash/presentation/pages/model_config_page.dart';
import 'package:artificial_flash/presentation/pages/training_page.dart';
import 'package:artificial_flash/presentation/pages/models_page.dart';
import 'package:artificial_flash/presentation/pages/settings_page.dart';
import 'package:artificial_flash/l10n/app_localizations.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    final pages = [
      const HomePage(),
      const DataPage(),
      const DataMarketplacePage(),
      const ModelConfigPage(),
      const TrainingPage(),
      const ModelsPage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        if (isDesktop) {
          return _DesktopShell(
            currentIndex: currentIndex,
            pages: pages,
            l10n: l10n,
          );
        }

        return Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              ref.read(currentIndexProvider.notifier).state = index;
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: l10n.home,
              ),
              NavigationDestination(
                icon: const Icon(Icons.folder_outlined),
                selectedIcon: const Icon(Icons.folder),
                label: l10n.data,
              ),
              NavigationDestination(
                icon: const Icon(Icons.cloud_download_outlined),
                selectedIcon: const Icon(Icons.cloud_download),
                label: 'Market',
              ),
              NavigationDestination(
                icon: const Icon(Icons.model_training_outlined),
                selectedIcon: const Icon(Icons.model_training),
                label: l10n.model,
              ),
              NavigationDestination(
                icon: const Icon(Icons.play_circle_outline),
                selectedIcon: const Icon(Icons.play_circle),
                label: l10n.train,
              ),
              NavigationDestination(
                icon: const Icon(Icons.storage_outlined),
                selectedIcon: const Icon(Icons.storage),
                label: l10n.models,
              ),
            ],
          ),
          drawer: _buildDrawer(context, l10n),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, AppLocalizations l10n) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n.appSubtitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settings),
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
            title: Text(l10n.help),
            onTap: () {
              Navigator.pop(context);
              _showHelpDialog(context, l10n);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context, l10n);
            },
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.help),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to ${l10n.appTitle}!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _HelpStep(
                number: '1',
                title: l10n.step1,
                description: l10n.step1Desc,
              ),
              const SizedBox(height: 8),
              _HelpStep(
                number: '2',
                title: l10n.step2,
                description: l10n.step2Desc,
              ),
              const SizedBox(height: 8),
              _HelpStep(
                number: '3',
                title: l10n.step3,
                description: l10n.step3Desc,
              ),
              const SizedBox(height: 8),
              _HelpStep(
                number: '4',
                title: l10n.step4,
                description: l10n.step4Desc,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.appTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.version}: 1.0.0'),
            const SizedBox(height: 12),
            Text(l10n.description),
            const SizedBox(height: 12),
            Text(
              l10n.features,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _HelpStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _HelpStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopShell extends ConsumerWidget {
  final int currentIndex;
  final List<Widget> pages;
  final AppLocalizations l10n;

  const _DesktopShell({
    required this.currentIndex,
    required this.pages,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(connectionConfigProvider);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.psychology,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.appTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.appSubtitle,
                              style: TextStyle(
                                color: Colors.white.withAlpha(179),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Navigation
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: [
                      _NavItem(
                        icon: Icons.home,
                        label: l10n.home,
                        isSelected: currentIndex == 0,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 0,
                      ),
                      _NavItem(
                        icon: Icons.folder,
                        label: l10n.data,
                        isSelected: currentIndex == 1,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 1,
                      ),
                      _NavItem(
                        icon: Icons.cloud_download,
                        label: 'Market',
                        isSelected: currentIndex == 2,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 2,
                      ),
                      _NavItem(
                        icon: Icons.model_training,
                        label: l10n.model,
                        isSelected: currentIndex == 3,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 3,
                      ),
                      _NavItem(
                        icon: Icons.play_circle,
                        label: l10n.train,
                        isSelected: currentIndex == 4,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 4,
                      ),
                      _NavItem(
                        icon: Icons.storage,
                        label: l10n.models,
                        isSelected: currentIndex == 5,
                        onTap: () =>
                            ref.read(currentIndexProvider.notifier).state = 5,
                      ),
                    ],
                  ),
                ),
                // Footer
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _NavItem(
                        icon: Icons.settings,
                        label: l10n.settings,
                        isSelected: currentIndex == 6,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: config.isConnected
                              ? AppColors.success.withAlpha(26)
                              : AppColors.warning.withAlpha(26),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              config.isConnected
                                  ? Icons.cloud_done
                                  : Icons.cloud_off,
                              color: config.isConnected
                                  ? AppColors.success
                                  : AppColors.warning,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                config.isConnected
                                    ? l10n.serverConnected
                                    : l10n.offlineMode,
                                style: TextStyle(
                                  color: config.isConnected
                                      ? AppColors.success
                                      : AppColors.warning,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
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
          const VerticalDivider(width: 1, thickness: 1),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).iconTheme.color?.withAlpha(179),
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
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
