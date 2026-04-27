import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/presentation/providers/training_provider.dart';
import 'package:artificial_flash/presentation/providers/model_provider.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/domain/entities/training.dart';
import 'package:artificial_flash/domain/entities/model.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  TrainingMode _selectedMode = TrainingMode.local;

  @override
  Widget build(BuildContext context) {
    final models = ref.watch(modelsProvider);
    final trainingSession = ref.watch(trainingSessionProvider);
    final connectionConfig = ref.watch(connectionConfigProvider);
    final isTraining = ref.watch(isTrainingProvider);
    final selectedModel = ref.watch(selectedModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (isTraining)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _stopTraining,
              tooltip: 'Stop Training',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTrainingConfig(
              models,
              connectionConfig,
              isTraining,
              selectedModel,
            ),
            const SizedBox(height: 16),
            if (isTraining || trainingSession.value != null) ...[
              _buildProgressSection(trainingSession),
              const SizedBox(height: 16),
              _buildMetricsChart(trainingSession),
              const SizedBox(height: 16),
              _buildLogsSection(trainingSession),
            ] else
              _buildNoTrainingState(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingConfig(
    AsyncValue<List<Model>> models,
    ConnectionConfig connectionConfig,
    bool isTraining,
    Model? selectedModel,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Configuration',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            models.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (data) {
                final pendingModels = data
                    .where(
                      (m) =>
                          m.status == ModelStatus.pending ||
                          m.status == ModelStatus.ready,
                    )
                    .toList();

                if (pendingModels.isEmpty) {
                  return const Text(
                    'No models available. Please create a model first.',
                  );
                }

                final currentSelected = pendingModels.contains(selectedModel)
                    ? selectedModel
                    : (pendingModels.isNotEmpty ? pendingModels.first : null);

                return DropdownButtonFormField<Model>(
                  value: currentSelected,
                  decoration: const InputDecoration(
                    labelText: 'Select Model',
                    prefixIcon: Icon(Icons.model_training),
                  ),
                  items: pendingModels.map<DropdownMenuItem<Model>>((model) {
                    return DropdownMenuItem<Model>(
                      value: model,
                      child: Text(model.name),
                    );
                  }).toList(),
                  onChanged: isTraining
                      ? null
                      : (value) {
                          ref.read(selectedModelProvider.notifier).state =
                              value;
                        },
                );
              },
            ),
            const SizedBox(height: 16),
            const Text('Training Mode'),
            const SizedBox(height: 8),
            SegmentedButton<TrainingMode>(
              segments: [
                const ButtonSegment(
                  value: TrainingMode.local,
                  label: Text('Local'),
                  icon: Icon(Icons.computer),
                ),
                const ButtonSegment(
                  value: TrainingMode.remote,
                  label: Text('Remote'),
                  icon: Icon(Icons.cloud),
                ),
              ],
              selected: {_selectedMode},
              onSelectionChanged: isTraining
                  ? null
                  : (selected) =>
                        setState(() => _selectedMode = selected.first),
            ),
            if (_selectedMode == TrainingMode.local &&
                (connectionConfig.host != 'localhost' &&
                    connectionConfig.host != '127.0.0.1')) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: AppColors.warning, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Local training works best with localhost',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isTraining || selectedModel == null
                    ? null
                    : () => _startTraining(selectedModel),
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  isTraining ? 'Training in Progress...' : 'Start Training',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(AsyncValue<TrainingSession?> session) {
    return session.when(
      loading: () => const SizedBox(),
      error: (e, _) => Text('Error: $e'),
      data: (data) {
        if (data == null) return const SizedBox();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Training Progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _StatusChip(status: data.status),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: data.progress,
                  backgroundColor: Colors.grey[300],
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Epoch ${data.currentEpoch} / ${data.totalEpochs}'),
                    Text('${(data.progress * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Loss',
                        value: data.currentLoss.toStringAsFixed(4),
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        label: 'Accuracy',
                        value: data.currentAccuracy?.toStringAsFixed(4) ?? '-',
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                if (data.status == TrainingStatus.training) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          if (data.status == TrainingStatus.paused) {
                            ref
                                .read(trainingSessionProvider.notifier)
                                .resumeTraining();
                          } else {
                            ref
                                .read(trainingSessionProvider.notifier)
                                .pauseTraining();
                          }
                        },
                        icon: Icon(
                          data.status == TrainingStatus.paused
                              ? Icons.play_arrow
                              : Icons.pause,
                        ),
                        label: Text(
                          data.status == TrainingStatus.paused
                              ? 'Resume'
                              : 'Pause',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricsChart(AsyncValue<TrainingSession?> session) {
    return session.when(
      loading: () => const SizedBox(),
      error: (e, _) => const SizedBox(),
      data: (data) {
        if (data == null || data.logs.isEmpty) return const SizedBox();

        final lossData = data.logs.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.loss);
        }).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loss Curve',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: lossData,
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withAlpha(51),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogsSection(AsyncValue<TrainingSession?> session) {
    return session.when(
      loading: () => const SizedBox(),
      error: (e, _) => const SizedBox(),
      data: (data) {
        if (data == null || data.logs.isEmpty) return const SizedBox();

        final recentLogs = data.logs.reversed.take(50).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Training Logs',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${data.logs.length} entries',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: recentLogs.length,
                    itemBuilder: (context, index) {
                      final log = recentLogs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '[${log.timestamp.toString().substring(11, 19)}] Epoch ${log.epoch}, Step ${log.step}: Loss=${log.loss.toStringAsFixed(4)}${log.accuracy != null ? ', Acc=${log.accuracy!.toStringAsFixed(4)}' : ''}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.greenAccent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoTrainingState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.model_training, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Active Training',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a model and click Start Training to begin',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _startTraining(Model model) {
    ref
        .read(trainingSessionProvider.notifier)
        .startTraining(model: model, mode: _selectedMode);
  }

  void _stopTraining() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Training'),
        content: const Text(
          'Are you sure you want to stop the training? Progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(trainingSessionProvider.notifier).stopTraining();
            },
            child: const Text('Stop', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TrainingStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case TrainingStatus.idle:
        color = Colors.grey;
        text = 'Idle';
        icon = Icons.pause;
        break;
      case TrainingStatus.preparing:
        color = AppColors.warning;
        text = 'Preparing';
        icon = Icons.hourglass_empty;
        break;
      case TrainingStatus.training:
        color = AppColors.primary;
        text = 'Training';
        icon = Icons.sync;
        break;
      case TrainingStatus.paused:
        color = AppColors.accent;
        text = 'Paused';
        icon = Icons.pause_circle;
        break;
      case TrainingStatus.completed:
        color = AppColors.success;
        text = 'Completed';
        icon = Icons.check_circle;
        break;
      case TrainingStatus.error:
        color = AppColors.error;
        text = 'Error';
        icon = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
