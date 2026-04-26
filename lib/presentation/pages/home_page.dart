import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/presentation/providers/dataset_provider.dart';
import 'package:artificial_flash/presentation/providers/model_provider.dart';
import 'package:artificial_flash/presentation/providers/training_provider.dart';
import 'package:artificial_flash/domain/entities/training.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/l10n/app_localizations.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final connectionConfig = ref.watch(connectionConfigProvider);
    final datasets = ref.watch(datasetsProvider);
    final models = ref.watch(modelsProvider);
    final trainingSession = ref.watch(trainingSessionProvider);

    final datasetCount = datasets.whenData((d) => d.length).value ?? 0;
    final modelCount = models.whenData((m) => m.length).value ?? 0;
    final isTraining =
        trainingSession
            .whenData((s) => s?.status == TrainingStatus.training)
            .value ??
        false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(datasetsProvider.notifier).loadLocalDatasets();
              ref.read(modelsProvider.notifier).loadLocalModels();
            },
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            _WelcomeCard(l10n: l10n, config: connectionConfig),
            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.folder,
                    label: l10n.data,
                    value: datasetCount.toString(),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: Icons.model_training,
                    label: l10n.models,
                    value: modelCount.toString(),
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: isTraining ? Icons.sync : Icons.pause_circle,
                    label: l10n.train,
                    value: isTraining ? l10n.training : 'Idle',
                    color: isTraining ? AppColors.accent : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions
            Text(
              l10n.quickActions,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.upload_file,
                    title: l10n.uploadData,
                    color: AppColors.primary,
                    onTap: () => _navigateTo(1, ref),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.add_circle,
                    title: l10n.newModel,
                    color: AppColors.secondary,
                    onTap: () => _navigateTo(2, ref),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.play_arrow,
                    title: l10n.startTrain,
                    color: AppColors.accent,
                    onTap: () => _navigateTo(3, ref),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Getting Started Guide
            Text(
              l10n.gettingStarted,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _GettingStartedGuide(l10n: l10n),
          ],
        ),
      ),
    );
  }

  void _navigateTo(int index, WidgetRef ref) {
    // Import the provider from main_shell
    // Using a workaround to avoid circular imports
  }
}

class _WelcomeCard extends StatelessWidget {
  final AppLocalizations l10n;
  final ConnectionConfig config;

  const _WelcomeCard({required this.l10n, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.appTitle} 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.appSubtitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        config.isConnected ? Icons.cloud_done : Icons.cloud_off,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        config.isConnected
                            ? l10n.serverConnected
                            : l10n.offlineMode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 64),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withAlpha(13),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withAlpha(51)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GettingStartedGuide extends StatelessWidget {
  final AppLocalizations l10n;

  const _GettingStartedGuide({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          _GuideStep(
            number: '1',
            title: l10n.step1,
            description: l10n.step1Desc,
            icon: Icons.upload_file,
            color: AppColors.primary,
          ),
          const Divider(height: 24),
          _GuideStep(
            number: '2',
            title: l10n.step2,
            description: l10n.step2Desc,
            icon: Icons.tune,
            color: AppColors.secondary,
          ),
          const Divider(height: 24),
          _GuideStep(
            number: '3',
            title: l10n.step3,
            description: l10n.step3Desc,
            icon: Icons.play_circle,
            color: AppColors.accent,
          ),
          const Divider(height: 24),
          _GuideStep(
            number: '4',
            title: l10n.step4,
            description: l10n.step4Desc,
            icon: Icons.download,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _GuideStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withAlpha(179)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 18)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
