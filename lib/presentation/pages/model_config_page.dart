import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/presentation/providers/model_provider.dart';
import 'package:artificial_flash/presentation/providers/dataset_provider.dart';
import 'package:artificial_flash/domain/entities/model.dart';
import 'package:artificial_flash/core/constants/app_constants.dart';

class ModelConfigPage extends ConsumerStatefulWidget {
  const ModelConfigPage({super.key});

  @override
  ConsumerState<ModelConfigPage> createState() => _ModelConfigPageState();
}

class _ModelConfigPageState extends ConsumerState<ModelConfigPage> {
  final _nameController = TextEditingController();
  String _selectedCategory = ModelTypes.visual;
  String _selectedModelType = ModelTypes.visualModels.first;
  String? _selectedDatasetId;
  final _learningRateController = TextEditingController(text: '0.001');
  final _epochsController = TextEditingController(text: '10');
  final _batchSizeController = TextEditingController(text: '32');
  final _imageSizeController = TextEditingController(text: '224');
  bool _dataAugmentation = true;
  int _trainSplit = 80;
  int _valSplit = 20;

  @override
  void dispose() {
    _nameController.dispose();
    _learningRateController.dispose();
    _epochsController.dispose();
    _batchSizeController.dispose();
    _imageSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final datasets = ref.watch(datasetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Configuration'),
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
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildModelTypeSection(),
            const SizedBox(height: 24),
            _buildDatasetSection(datasets),
            const SizedBox(height: 24),
            _buildTrainingParamsSection(),
            const SizedBox(height: 32),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Model Name',
                hintText: 'Enter a name for your model',
                prefixIcon: Icon(Icons.model_training),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelTypeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model Type',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Category'),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: ModelTypes.visual, label: Text('Visual')),
                ButtonSegment(value: ModelTypes.nlp, label: Text('NLP')),
                ButtonSegment(
                  value: ModelTypes.generative,
                  label: Text('Generative'),
                ),
                ButtonSegment(value: ModelTypes.custom, label: Text('Custom')),
              ],
              selected: {_selectedCategory},
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedCategory = selected.first;
                  _updateModelTypeOptions();
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Model Architecture'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedModelType,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.architecture),
              ),
              items: _getModelTypeOptions().map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_formatModelType(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedModelType = value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatasetSection(AsyncValue datasets) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Data',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            datasets.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error loading datasets: $e'),
              data: (data) {
                if (data.isEmpty) {
                  return const Text(
                    'No datasets available. Please upload data first.',
                  );
                }
                return DropdownButtonFormField<String>(
                  value: _selectedDatasetId,
                  decoration: const InputDecoration(
                    labelText: 'Select Dataset',
                    prefixIcon: Icon(Icons.folder),
                  ),
                  items: data.map((dataset) {
                    return DropdownMenuItem(
                      value: dataset.id,
                      child: Text(dataset.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedDatasetId = value);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingParamsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Parameters',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _learningRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Learning Rate',
                      prefixIcon: Icon(Icons.speed),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _epochsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Epochs',
                      prefixIcon: Icon(Icons.repeat),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _batchSizeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Batch Size',
                      prefixIcon: Icon(Icons.layers),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _imageSizeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Image Size',
                      prefixIcon: Icon(Icons.photo_size_select_large),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Data Augmentation'),
              subtitle: const Text(
                'Apply random transformations to training data',
              ),
              value: _dataAugmentation,
              onChanged: (value) => setState(() => _dataAugmentation = value),
            ),
            const SizedBox(height: 16),
            const Text('Data Split'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _trainSplit.toDouble(),
                    min: 50,
                    max: 90,
                    divisions: 8,
                    label: 'Train: $_trainSplit%',
                    onChanged: (value) {
                      setState(() {
                        _trainSplit = value.round();
                        _valSplit = 100 - _trainSplit;
                      });
                    },
                  ),
                ),
                Text('$_trainSplit% / $_valSplit%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _createModel,
        icon: const Icon(Icons.add),
        label: const Text('Create Model'),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
      ),
    );
  }

  List<String> _getModelTypeOptions() {
    switch (_selectedCategory) {
      case ModelTypes.visual:
        return ModelTypes.visualModels;
      case ModelTypes.nlp:
        return ModelTypes.nlpModels;
      case ModelTypes.generative:
        return ModelTypes.generativeModels;
      case ModelTypes.custom:
        return ['custom_model'];
      default:
        return ModelTypes.visualModels;
    }
  }

  void _updateModelTypeOptions() {
    final options = _getModelTypeOptions();
    if (!options.contains(_selectedModelType)) {
      _selectedModelType = options.first;
    }
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

  void _createModel() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a model name')),
      );
      return;
    }

    final params = TrainingParams(
      learningRate: double.tryParse(_learningRateController.text) ?? 0.001,
      epochs: int.tryParse(_epochsController.text) ?? 10,
      batchSize: int.tryParse(_batchSizeController.text) ?? 32,
      imageSize: int.tryParse(_imageSizeController.text),
      dataAugmentation: _dataAugmentation,
      trainSplit: _trainSplit,
      valSplit: _valSplit,
    );

    ref
        .read(modelsProvider.notifier)
        .createModel(
          name: _nameController.text,
          type: _selectedModelType,
          datasetId: _selectedDatasetId,
          params: params,
        );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Model created successfully')));

    _nameController.clear();
    setState(() {
      _selectedDatasetId = null;
    });
  }
}
