import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/domain/entities/model.dart';
import 'package:artificial_flash/core/network/api_service.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/core/utils/local_storage.dart';
import 'package:uuid/uuid.dart';

final modelsProvider =
    StateNotifierProvider<ModelsNotifier, AsyncValue<List<Model>>>((ref) {
      return ModelsNotifier(ref);
    });

class ModelsNotifier extends StateNotifier<AsyncValue<List<Model>>> {
  final Ref _ref;
  final _uuid = const Uuid();

  ModelsNotifier(this._ref) : super(const AsyncValue.data([])) {
    _init();
  }

  Future<void> _init() async {
    final config = _ref.read(connectionConfigProvider);
    if (config.isConnected) {
      await loadModelsFromServer();
    } else {
      await loadLocalModels();
    }
  }

  Future<void> loadModelsFromServer() async {
    state = const AsyncValue.loading();
    try {
      final api = _ref.read(apiServiceProvider);
      final response = await api.get('/models');
      final List<dynamic> data = response.data as List<dynamic>? ?? [];
      final models = data
          .map((e) => Model.fromJson(e as Map<String, dynamic>))
          .toList();
      state = AsyncValue.data(models);
    } catch (e) {
      await loadLocalModels();
    }
  }

  Future<void> loadLocalModels() async {
    final storage = _ref.read(localStorageServiceProvider);
    final localModels = await storage.loadModels();
    state = AsyncValue.data(localModels);
  }

  Future<void> createModel({
    required String name,
    required String type,
    String? baseModel,
    String? datasetId,
    TrainingParams? params,
  }) async {
    final config = _ref.read(connectionConfigProvider);
    final newModel = Model(
      id: _uuid.v4(),
      name: name,
      type: type,
      baseModel: baseModel,
      status: ModelStatus.pending,
      datasetId: datasetId,
      params: params,
      createdAt: DateTime.now(),
    );

    if (config.isConnected) {
      try {
        final api = _ref.read(apiServiceProvider);
        final response = await api.post(
          '/models',
          data: {
            'name': name,
            'type': type,
            'base_model': baseModel,
            'dataset_id': datasetId,
            'params': params?.toJson(),
          },
        );
        final model = Model.fromJson(response.data as Map<String, dynamic>);
        state.whenData((models) {
          state = AsyncValue.data([...models, model]);
        });
      } catch (e) {
        state.whenData((models) {
          final list = [...models, newModel];
          state = AsyncValue.data(list);
          _saveToLocalStorage(list);
        });
      }
    } else {
      state.whenData((models) {
        final list = [...models, newModel];
        state = AsyncValue.data(list);
        _saveToLocalStorage(list);
      });
    }
  }

  Future<void> deleteModel(String id) async {
    final config = _ref.read(connectionConfigProvider);

    if (config.isConnected) {
      try {
        final api = _ref.read(apiServiceProvider);
        await api.delete('/models/$id');
      } catch (e) {
        // Continue with local delete
      }
    }

    state.whenData((models) {
      final list = models.where((m) => m.id != id).toList();
      state = AsyncValue.data(list);
      _saveToLocalStorage(list);
    });
  }

  void updateModel(Model model) {
    state.whenData((models) {
      final index = models.indexWhere((m) => m.id == model.id);
      if (index != -1) {
        final newList = [...models];
        newList[index] = model;
        state = AsyncValue.data(newList);
        _saveToLocalStorage(newList);
      }
    });
  }

  Future<void> exportModel(String id, String format) async {
    final config = _ref.read(connectionConfigProvider);

    if (config.isConnected) {
      try {
        final api = _ref.read(apiServiceProvider);
        await api.post('/models/$id/export', data: {'format': format});
        state.whenData((models) {
          final index = models.indexWhere((m) => m.id == id);
          if (index != -1) {
            final newList = [...models];
            newList[index] = newList[index].copyWith(
              status: ModelStatus.exported,
            );
            state = AsyncValue.data(newList);
            _saveToLocalStorage(newList);
          }
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> _saveToLocalStorage(List<Model> models) async {
    final storage = _ref.read(localStorageServiceProvider);
    await storage.saveModels(models);
  }

  Future<void> loadModels() async {
    final config = _ref.read(connectionConfigProvider);
    if (config.isConnected) {
      await loadModelsFromServer();
    } else {
      await loadLocalModels();
    }
  }
}

final selectedModelProvider = StateProvider<Model?>((ref) => null);
