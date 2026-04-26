import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:artificial_flash/domain/entities/model.dart';

class LocalStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final appDir = Directory('${directory.path}/ArtificialFlash');
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }
    return appDir.path;
  }

  Future<File> _getFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<List<Model>> loadModels() async {
    try {
      final file = await _getFile('models.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        return jsonList.map((e) => Model.fromJson(e)).toList();
      }
    } catch (e) {
      // Return empty list on error
    }
    return [];
  }

  Future<void> saveModels(List<Model> models) async {
    final file = await _getFile('models.json');
    final jsonList = models.map((e) => e.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  Future<List<Map<String, dynamic>>> loadDatasets() async {
    try {
      final file = await _getFile('datasets.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        return List<Map<String, dynamic>>.from(json.decode(contents));
      }
    } catch (e) {
      // Return empty list on error
    }
    return [];
  }

  Future<void> saveDatasets(List<Map<String, dynamic>> datasets) async {
    final file = await _getFile('datasets.json');
    await file.writeAsString(json.encode(datasets));
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    try {
      final file = await _getFile('settings.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        return json.decode(contents);
      }
    } catch (e) {
      // Return null on error
    }
    return null;
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final file = await _getFile('settings.json');
    await file.writeAsString(json.encode(settings));
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final localModelsProvider =
    StateNotifierProvider<LocalModelsNotifier, List<Model>>((ref) {
      return LocalModelsNotifier(ref);
    });

class LocalModelsNotifier extends StateNotifier<List<Model>> {
  final Ref _ref;

  LocalModelsNotifier(this._ref) : super([]) {
    _loadModels();
  }

  Future<void> _loadModels() async {
    final storage = _ref.read(localStorageServiceProvider);
    final models = await storage.loadModels();
    state = models;
  }

  Future<void> addModel(Model model) async {
    state = [...state, model];
    await _saveModels();
  }

  Future<void> updateModel(Model model) async {
    state = state.map((m) => m.id == model.id ? model : m).toList();
    await _saveModels();
  }

  Future<void> deleteModel(String id) async {
    state = state.where((m) => m.id != id).toList();
    await _saveModels();
  }

  Future<void> _saveModels() async {
    final storage = _ref.read(localStorageServiceProvider);
    await storage.saveModels(state);
  }
}

final localDatasetsProvider =
    StateNotifierProvider<LocalDatasetsNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return LocalDatasetsNotifier(ref);
    });

class LocalDatasetsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref _ref;

  LocalDatasetsNotifier(this._ref) : super([]) {
    _loadDatasets();
  }

  Future<void> _loadDatasets() async {
    final storage = _ref.read(localStorageServiceProvider);
    final datasets = await storage.loadDatasets();
    state = datasets;
  }

  Future<void> addDataset(Map<String, dynamic> dataset) async {
    state = [...state, dataset];
    await _saveDatasets();
  }

  Future<void> removeDataset(String id) async {
    state = state.where((d) => d['id'] != id).toList();
    await _saveDatasets();
  }

  Future<void> _saveDatasets() async {
    final storage = _ref.read(localStorageServiceProvider);
    await storage.saveDatasets(state);
  }
}
