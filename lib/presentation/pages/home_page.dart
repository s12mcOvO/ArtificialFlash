import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/presentation/providers/dataset_provider.dart';
import 'package:artificial_flash/presentation/providers/model_provider.dart';
import 'package:artificial_flash/presentation/providers/training_provider.dart';
import 'package:artificial_flash/domain/entities/training.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionConfig = ref.watch(connectionConfigProvider);
    final datasets = ref.watch(datasetsProvider);
    final models = ref.watch(modelsProvider);
    final trainingSession = ref.watch(trainingSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ArtificialFlash'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(context, connectionConfig),
            const SizedBox(height: 16),
            _buildQuickActions(context, ref),
            const SizedBox(height: 16),
            _buildStatsRow(context, datasets, models, trainingSession),
            const SizedBox(height: 16),
            _buildRecentActivity(context, datasets, models),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, ConnectionConfig config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: config.isConnected
                    ? AppColors.success.withAlpha(26)
                    : AppColors.warning.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                config.isConnected ? Icons.cloud_done : Icons.cloud_off,
                color: config.isConnected
                    ? AppColors.success
                    : AppColors.warning,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.isConnected ? 'Connected' : 'Disconnected',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${config.isRemote ? "Remote" : "Local"}: ${config.host}:${config.port}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Configure')),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.upload_file,
                title: 'Upload Data',
                color: AppColors.primary,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.add_circle,
                title: 'New Model',
                color: AppColors.secondary,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.play_arrow,
                title: 'Start Train',
                color: AppColors.accent,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AsyncValue datasets,
    AsyncValue models,
    AsyncValue trainingSession,
  ) {
    final datasetCount = datasets.whenData((d) => d.length).value ?? 0;
    final modelCount = models.whenData((m) => m.length).value ?? 0;
    final isTraining =
        trainingSession
            .whenData((s) => s?.status == TrainingStatus.training)
            .value ??
        false;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.folder,
            label: 'Datasets',
            value: datasetCount.toString(),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.model_training,
            label: 'Models',
            value: modelCount.toString(),
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.sync,
            label: isTraining ? 'Training' : 'Idle',
            value: isTraining ? '1' : '0',
            color: isTraining ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    AsyncValue datasets,
    AsyncValue models,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Getting Started',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GuideStep(
                  number: '1',
                  title: 'Upload Your Data',
                  description:
                      'Go to Data tab to upload images or text files for training.',
                ),
                const Divider(),
                _GuideStep(
                  number: '2',
                  title: 'Configure Model',
                  description:
                      'Choose model type and customize parameters in Model tab.',
                ),
                const Divider(),
                _GuideStep(
                  number: '3',
                  title: 'Start Training',
                  description:
                      'Begin training your model and monitor progress in Train tab.',
                ),
                const Divider(),
                _GuideStep(
                  number: '4',
                  title: 'Export & Use',
                  description:
                      'View and export your trained models in Models tab.',
                ),
              ],
            ),
          ),
        ),
      ],
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _GuideStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
