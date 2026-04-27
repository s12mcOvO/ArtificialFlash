import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/presentation/providers/model_provider.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/domain/entities/model.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ModelsPage extends ConsumerWidget {
  const ModelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(modelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trained Models'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(modelsProvider.notifier).loadModels(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: models.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storage, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No trained models yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Train a model to see it here',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final model = data[index];
              return _ModelCard(model: model);
            },
          );
        },
      ),
    );
  }
}

class _ModelCard extends ConsumerWidget {
  final Model model;

  const _ModelCard({required this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showModelDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getTypeColor(model.type).withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTypeIcon(model.type),
                      color: _getTypeColor(model.type),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _StatusBadge(status: model.status),
                            const SizedBox(width: 8),
                            Text(
                              _formatModelType(model.type),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'test',
                        child: Row(
                          children: [
                            Icon(Icons.science),
                            SizedBox(width: 8),
                            Text('Test'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'export',
                        child: Row(
                          children: [
                            Icon(Icons.download),
                            SizedBox(width: 8),
                            Text('Export'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppColors.error),
                            SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'test':
                          _showTestDialog(context, ref);
                          break;
                        case 'export':
                          _showExportDialog(context, ref);
                          break;
                        case 'delete':
                          _showDeleteConfirmation(context, ref);
                          break;
                      }
                    },
                  ),
                ],
              ),
              if (model.accuracy != null || model.loss != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (model.accuracy != null)
                      Expanded(
                        child: _MetricDisplay(
                          label: 'Accuracy',
                          value:
                              '${(model.accuracy! * 100).toStringAsFixed(2)}%',
                          color: AppColors.success,
                        ),
                      ),
                    if (model.accuracy != null && model.loss != null)
                      const SizedBox(width: 16),
                    if (model.loss != null)
                      Expanded(
                        child: _MetricDisplay(
                          label: 'Loss',
                          value: model.loss!.toStringAsFixed(4),
                          color: AppColors.error,
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Created: ${DateFormat('yyyy-MM-dd HH:mm').format(model.createdAt)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                  if (model.trainedAt != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.check_circle, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      'Trained: ${DateFormat('yyyy-MM-dd HH:mm').format(model.trainedAt!)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    if (type.contains('image') || type.contains('visual')) {
      return Icons.image;
    } else if (type.contains('text') || type.contains('nlp')) {
      return Icons.text_snippet;
    } else if (type.contains('generate')) {
      return Icons.auto_awesome;
    }
    return Icons.model_training;
  }

  Color _getTypeColor(String type) {
    if (type.contains('image') || type.contains('visual')) {
      return AppColors.primary;
    } else if (type.contains('text') || type.contains('nlp')) {
      return AppColors.secondary;
    } else if (type.contains('generate')) {
      return AppColors.accent;
    }
    return AppColors.primary;
  }

  String _formatModelType(String type) {
    return type
        .split('_')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  void _showModelDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                model.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _StatusBadge(status: model.status),
              const SizedBox(height: 24),
              _DetailRow(label: 'Type', value: _formatModelType(model.type)),
              if (model.baseModel != null)
                _DetailRow(label: 'Base Model', value: model.baseModel!),
              if (model.params != null) ...[
                _DetailRow(
                  label: 'Learning Rate',
                  value: model.params!.learningRate.toString(),
                ),
                _DetailRow(
                  label: 'Epochs',
                  value: model.params!.epochs.toString(),
                ),
                _DetailRow(
                  label: 'Batch Size',
                  value: model.params!.batchSize.toString(),
                ),
              ],
              if (model.accuracy != null)
                _DetailRow(
                  label: 'Accuracy',
                  value: '${(model.accuracy! * 100).toStringAsFixed(2)}%',
                ),
              if (model.loss != null)
                _DetailRow(
                  label: 'Loss',
                  value: model.loss!.toStringAsFixed(4),
                ),
              _DetailRow(
                label: 'Created',
                value: DateFormat('yyyy-MM-dd HH:mm').format(model.createdAt),
              ),
              if (model.trainedAt != null)
                _DetailRow(
                  label: 'Trained',
                  value: DateFormat(
                    'yyyy-MM-dd HH:mm',
                  ).format(model.trainedAt!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTestDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Test ${_formatModelType(model.type)} Model'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getTestInstructions(model.type)),
              const SizedBox(height: 16),
              if (model.type.contains('text') || model.type.contains('nlp'))
                TextField(
                  controller: textController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Input Text',
                    hintText: 'Enter text to classify/analyze',
                    border: OutlineInputBorder(),
                  ),
                ),
              if (model.type.contains('image') || model.type.contains('visual'))
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image Path',
                    hintText: '/path/to/image.jpg',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _runTest(
                    context,
                    ref,
                    text: textController.text,
                    imagePath: imageController.text,
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Run Test'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getTestInstructions(String type) {
    if (type.contains('text_classification')) {
      return 'Enter text to classify into categories.';
    } else if (type.contains('sentiment_analysis')) {
      return 'Enter text for sentiment analysis (positive/negative).';
    } else if (type.contains('question_answering')) {
      return 'Enter a question to get an answer from the model.';
    } else if (type.contains('image_classification')) {
      return 'Provide image path to classify the image.';
    } else if (type.contains('object_detection')) {
      return 'Provide image path to detect objects.';
    }
    return 'Enter input data to test the model.';
  }

  Future<void> _runTest(
    BuildContext context,
    WidgetRef ref, {
    String text = '',
    String imagePath = '',
  }) async {
    final inputData = {
      if (text.isNotEmpty) 'text': text,
      if (imagePath.isNotEmpty) 'image_path': imagePath,
    };

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Running inference on ${model.name}...')),
      );

      final api = ref.read(apiServiceProvider);
      final response = await api.post(
        '/inference/predict',
        data: {'model_id': model.id, 'input_data': inputData},
      );

      if (context.mounted) {
        _showTestResult(context, response.data);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Test failed: $e')));
      }
    }
  }

  void _showTestResult(BuildContext context, Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 12),
                  Text(
                    'Prediction: ${result['prediction']?['class'] ?? 'unknown'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.speed, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Confidence: ${((result['prediction']?['confidence'] ?? 0) * 100).toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
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

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Export Model'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select export format:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.android),
              title: const Text('TensorFlow Lite (.tflite)'),
              onTap: () => _startExport(context, ref, 'tflite'),
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('ONNX (.onnx)'),
              onTap: () => _startExport(context, ref, 'onnx'),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('PyTorch (.pt)'),
              onTap: () => _startExport(context, ref, 'pt'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _startExport(BuildContext context, WidgetRef ref, String format) async {
    Navigator.pop(context);

    try {
      await ref.read(modelsProvider.notifier).exportModel(model.id, format);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Model exported as .$format successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Model'),
        content: Text('Are you sure you want to delete "${model.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(modelsProvider.notifier).deleteModel(model.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ModelStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case ModelStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case ModelStatus.training:
        color = AppColors.primary;
        text = 'Training';
        break;
      case ModelStatus.ready:
        color = AppColors.success;
        text = 'Ready';
        break;
      case ModelStatus.error:
        color = AppColors.error;
        text = 'Error';
        break;
      case ModelStatus.exported:
        color = AppColors.secondary;
        text = 'Exported';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _MetricDisplay extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricDisplay({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
