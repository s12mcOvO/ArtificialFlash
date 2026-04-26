import 'package:equatable/equatable.dart';

enum ModelType { visual, nlp, generative, custom }

enum ModelStatus { pending, training, ready, error, exported }

class TrainingParams extends Equatable {
  final double learningRate;
  final int epochs;
  final int batchSize;
  final int? imageSize;
  final String? backbone;
  final bool dataAugmentation;
  final int? trainSplit;
  final int? valSplit;

  const TrainingParams({
    this.learningRate = 0.001,
    this.epochs = 10,
    this.batchSize = 32,
    this.imageSize,
    this.backbone,
    this.dataAugmentation = true,
    this.trainSplit = 80,
    this.valSplit = 20,
  });

  TrainingParams copyWith({
    double? learningRate,
    int? epochs,
    int? batchSize,
    int? imageSize,
    String? backbone,
    bool? dataAugmentation,
    int? trainSplit,
    int? valSplit,
  }) {
    return TrainingParams(
      learningRate: learningRate ?? this.learningRate,
      epochs: epochs ?? this.epochs,
      batchSize: batchSize ?? this.batchSize,
      imageSize: imageSize ?? this.imageSize,
      backbone: backbone ?? this.backbone,
      dataAugmentation: dataAugmentation ?? this.dataAugmentation,
      trainSplit: trainSplit ?? this.trainSplit,
      valSplit: valSplit ?? this.valSplit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'learning_rate': learningRate,
      'epochs': epochs,
      'batch_size': batchSize,
      'image_size': imageSize,
      'backbone': backbone,
      'data_augmentation': dataAugmentation,
      'train_split': trainSplit,
      'val_split': valSplit,
    };
  }

  factory TrainingParams.fromJson(Map<String, dynamic> json) {
    return TrainingParams(
      learningRate: (json['learning_rate'] as num?)?.toDouble() ?? 0.001,
      epochs: json['epochs'] as int? ?? 10,
      batchSize: json['batch_size'] as int? ?? 32,
      imageSize: json['image_size'] as int?,
      backbone: json['backbone'] as String?,
      dataAugmentation: json['data_augmentation'] as bool? ?? true,
      trainSplit: json['train_split'] as int? ?? 80,
      valSplit: json['val_split'] as int? ?? 20,
    );
  }

  @override
  List<Object?> get props => [
    learningRate,
    epochs,
    batchSize,
    imageSize,
    backbone,
    dataAugmentation,
    trainSplit,
    valSplit,
  ];
}

class Model extends Equatable {
  final String id;
  final String name;
  final String type;
  final String? baseModel;
  final ModelStatus status;
  final String? datasetId;
  final TrainingParams? params;
  final String? path;
  final double? accuracy;
  final double? loss;
  final DateTime createdAt;
  final DateTime? trainedAt;
  final String? errorMessage;

  const Model({
    required this.id,
    required this.name,
    required this.type,
    this.baseModel,
    required this.status,
    this.datasetId,
    this.params,
    this.path,
    this.accuracy,
    this.loss,
    required this.createdAt,
    this.trainedAt,
    this.errorMessage,
  });

  Model copyWith({
    String? id,
    String? name,
    String? type,
    String? baseModel,
    ModelStatus? status,
    String? datasetId,
    TrainingParams? params,
    String? path,
    double? accuracy,
    double? loss,
    DateTime? createdAt,
    DateTime? trainedAt,
    String? errorMessage,
  }) {
    return Model(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      baseModel: baseModel ?? this.baseModel,
      status: status ?? this.status,
      datasetId: datasetId ?? this.datasetId,
      params: params ?? this.params,
      path: path ?? this.path,
      accuracy: accuracy ?? this.accuracy,
      loss: loss ?? this.loss,
      createdAt: createdAt ?? this.createdAt,
      trainedAt: trainedAt ?? this.trainedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      baseModel: json['base_model'] as String?,
      status: ModelStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ModelStatus.pending,
      ),
      datasetId: json['dataset_id'] as String?,
      params: json['params'] != null
          ? TrainingParams.fromJson(json['params'] as Map<String, dynamic>)
          : null,
      path: json['path'] as String?,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      loss: (json['loss'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      trainedAt: json['trained_at'] != null
          ? DateTime.parse(json['trained_at'] as String)
          : null,
      errorMessage: json['error_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'base_model': baseModel,
      'status': status.name,
      'dataset_id': datasetId,
      'params': params?.toJson(),
      'path': path,
      'accuracy': accuracy,
      'loss': loss,
      'created_at': createdAt.toIso8601String(),
      'trained_at': trainedAt?.toIso8601String(),
      'error_message': errorMessage,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    baseModel,
    status,
    datasetId,
    params,
    path,
    accuracy,
    loss,
    createdAt,
    trainedAt,
    errorMessage,
  ];
}
