import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/domain/entities/dataset.dart';
import 'package:artificial_flash/core/network/api_service.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/core/utils/local_storage.dart';
import 'package:uuid/uuid.dart';

final datasetsProvider =
    StateNotifierProvider<DatasetsNotifier, AsyncValue<List<Dataset>>>((ref) {
      return DatasetsNotifier(ref);
    });

class DatasetsNotifier extends StateNotifier<AsyncValue<List<Dataset>>> {
  final Ref _ref;
  final _uuid = const Uuid();

  DatasetsNotifier(this._ref) : super(const AsyncValue.data([])) {
    _init();
  }

  Future<void> _init() async {
    final config = _ref.read(connectionConfigProvider);
    if (config.isConnected) {
      await loadDatasetsFromServer();
    } else {
      await loadLocalDatasets();
    }
  }

  Future<void> loadDatasetsFromServer() async {
    state = const AsyncValue.loading();
    try {
      final api = _ref.read(apiServiceProvider);
      final response = await api.get('/datasets');
      final List<dynamic> data = response.data as List<dynamic>? ?? [];
      final datasets = data
          .map((e) => Dataset.fromJson(e as Map<String, dynamic>))
          .toList();
      state = AsyncValue.data(datasets);
    } catch (e) {
      await loadLocalDatasets();
    }
  }

  Future<void> loadLocalDatasets() async {
    final storage = _ref.read(localStorageServiceProvider);
    final localData = await storage.loadDatasets();
    final datasets = localData
        .map(
          (e) => Dataset(
            id: e['id'] as String,
            name: e['name'] as String,
            path: e['path'] as String? ?? '',
            type: DatasetType.values.firstWhere(
              (t) => t.name == e['type'],
              orElse: () => DatasetType.mixed,
            ),
            status: DatasetStatus.values.firstWhere(
              (s) => s.name == e['status'],
              orElse: () => DatasetStatus.ready,
            ),
            fileCount: e['file_count'] as int? ?? 0,
            createdAt:
                DateTime.tryParse(e['created_at'] as String? ?? '') ??
                DateTime.now(),
          ),
        )
        .toList();
    state = AsyncValue.data(datasets);
  }

  Future<void> addDataset({
    required String name,
    required String path,
    required DatasetType type,
  }) async {
    final config = _ref.read(connectionConfigProvider);

    if (config.isConnected) {
      try {
        final api = _ref.read(apiServiceProvider);
        final response = await api.post(
          '/datasets',
          data: {'name': name, 'path': path, 'type': type.name},
        );
        final dataset = Dataset.fromJson(response.data as Map<String, dynamic>);
        state.whenData((datasets) {
          state = AsyncValue.data([...datasets, dataset]);
        });
      } catch (e) {
        _addLocalDataset(name, path, type);
      }
    } else {
      _addLocalDataset(name, path, type);
    }
  }

  void _addLocalDataset(String name, String path, DatasetType type) {
    final newDataset = Dataset(
      id: _uuid.v4(),
      name: name,
      path: path,
      type: type,
      status: DatasetStatus.ready,
      fileCount: 1,
      createdAt: DateTime.now(),
    );

    state.whenData((datasets) {
      final newList = [...datasets, newDataset];
      state = AsyncValue.data(newList);
      _saveToLocalStorage(newList);
    });
  }

  Future<void> deleteDataset(String id) async {
    final config = _ref.read(connectionConfigProvider);

    if (config.isConnected) {
      try {
        final api = _ref.read(apiServiceProvider);
        await api.delete('/datasets/$id');
      } catch (e) {
        // Continue with local delete
      }
    }

    state.whenData((datasets) {
      final newList = datasets.where((d) => d.id != id).toList();
      state = AsyncValue.data(newList);
      _saveToLocalStorage(newList);
    });
  }

  Future<void> _saveToLocalStorage(List<Dataset> datasets) async {
    final storage = _ref.read(localStorageServiceProvider);
    final data = datasets
        .map(
          (d) => {
            'id': d.id,
            'name': d.name,
            'path': d.path,
            'type': d.type.name,
            'status': d.status.name,
            'file_count': d.fileCount,
            'created_at': d.createdAt.toIso8601String(),
          },
        )
        .toList();
    await storage.saveDatasets(data);
  }

  void updateDataset(Dataset dataset) {
    state.whenData((datasets) {
      final index = datasets.indexWhere((d) => d.id == dataset.id);
      if (index != -1) {
        final newList = [...datasets];
        newList[index] = dataset;
        state = AsyncValue.data(newList);
        _saveToLocalStorage(newList);
      }
    });
  }
}

final selectedDatasetProvider = StateProvider<Dataset?>((ref) => null);
