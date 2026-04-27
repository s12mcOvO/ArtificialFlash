import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/domain/entities/dataset.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/core/utils/local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DownloadProgress {
  final String datasetName;
  final double progress;
  final bool isDownloading;
  final bool isCompleted;
  final String? error;

  const DownloadProgress({
    required this.datasetName,
    this.progress = 0.0,
    this.isDownloading = false,
    this.isCompleted = false,
    this.error,
  });

  DownloadProgress copyWith({
    String? datasetName,
    double? progress,
    bool? isDownloading,
    bool? isCompleted,
    String? error,
  }) {
    return DownloadProgress(
      datasetName: datasetName ?? this.datasetName,
      progress: progress ?? this.progress,
      isDownloading: isDownloading ?? this.isDownloading,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error,
    );
  }
}

final downloadProgressProvider =
    StateNotifierProvider<DownloadProgressNotifier, DownloadProgress?>((ref) {
      return DownloadProgressNotifier(ref);
    });

class DownloadProgressNotifier extends StateNotifier<DownloadProgress?> {
  final Ref _ref;
  Timer? _simulationTimer;

  DownloadProgressNotifier(this._ref) : super(null);

  final Map<String, Map<String, dynamic>> _datasetInfo = {
    'MNIST': {
      'url': 'http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz',
      'size': 45,
    },
    'CIFAR-10': {
      'url': 'https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz',
      'size': 170,
    },
    'Fashion-MNIST': {
      'url':
          'http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/train-images-idx3-ubyte.gz',
      'size': 26,
    },
    'WanJuan2.0': {
      'url': 'https://opendatalab.org.cn/OpenDataLab/WanJuanCC',
      'size': 500000,
    },
    'IMDB Reviews': {
      'url': 'http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz',
      'size': 80,
    },
    'SST-2': {
      'url': 'https://nlp.stanford.edu/sentiment/train.zip',
      'size': 10,
    },
  };

  Future<void> downloadDataset(String name) async {
    if (state?.isDownloading == true) return;
    if (!_datasetInfo.containsKey(name) && !_isUrlDownload(name)) return;

    final isUrl = _isUrlDownload(name);
    final info = isUrl ? null : _datasetInfo[name];
    final url = isUrl ? name : info?['url'] as String?;

    if (url == null || url.isEmpty) {
      state = state?.copyWith(error: 'Invalid URL');
      return;
    }

    state = DownloadProgress(
      datasetName: isUrl ? 'URL Download' : name,
      isDownloading: true,
      progress: 0.0,
    );

    try {
      final downloadsDir = await _getDownloadsDirectory();
      final fileName = _getFileNameFromUrl(url);
      final filePath = '${downloadsDir.path}/$fileName';

      final httpClient = HttpClient();
      httpClient.connectionTimeout = const Duration(seconds: 30);

      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      final totalBytes = response.contentLength;
      if (totalBytes <= 0) {
        throw Exception('Could not determine file size');
      }

      final file = File(filePath);
      final sink = file.openWrite();
      var receivedBytes = 0;
      var lastUpdateTime = DateTime.now();

      await for (final chunk in response) {
        sink.add(chunk);
        receivedBytes += chunk.length;

        final now = DateTime.now();
        if (now.difference(lastUpdateTime).inMilliseconds > 100) {
          final progress = receivedBytes / totalBytes;
          state = state?.copyWith(progress: progress);
          lastUpdateTime = now;
        }
      }

      await sink.close();
      httpClient.close();

      final datasetName = isUrl ? 'Downloaded Dataset' : name;
      _addDownloadedDataset(datasetName, filePath);

      state = state?.copyWith(
        progress: 1.0,
        isDownloading: false,
        isCompleted: true,
      );
    } catch (e) {
      state = state?.copyWith(isDownloading: false, error: e.toString());
    }
  }

  bool _isUrlDownload(String name) {
    return name.startsWith('http://') || name.startsWith('https://');
  }

  String _getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    }
    return 'dataset_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<Directory> _getDownloadsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${appDir.path}/ArtificialFlash/datasets');
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }
    return downloadsDir;
  }

  void _addDownloadedDataset(String name, String filePath) {
    final isText =
        name == 'IMDB Reviews' ||
        name == 'SST-2' ||
        name == 'Downloaded Dataset';
    final type = isText ? DatasetType.text : DatasetType.image;

    final notifier = _ref.read(datasetsProvider.notifier);
    notifier.addDataset(name: name, path: filePath, type: type);
  }

  void cancelDownload() {
    state = null;
  }

  void clear() {
    _simulationTimer?.cancel();
    state = null;
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}

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
