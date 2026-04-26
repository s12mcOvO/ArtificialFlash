import 'package:equatable/equatable.dart';

enum TrainingStatus { idle, preparing, training, paused, completed, error }

enum TrainingMode { local, remote }

class TrainingLog extends Equatable {
  final int epoch;
  final int step;
  final double loss;
  final double? accuracy;
  final double? valLoss;
  final double? valAccuracy;
  final String message;
  final DateTime timestamp;

  const TrainingLog({
    required this.epoch,
    required this.step,
    required this.loss,
    this.accuracy,
    this.valLoss,
    this.valAccuracy,
    required this.message,
    required this.timestamp,
  });

  factory TrainingLog.fromJson(Map<String, dynamic> json) {
    return TrainingLog(
      epoch: json['epoch'] as int? ?? 0,
      step: json['step'] as int? ?? 0,
      loss: (json['loss'] as num?)?.toDouble() ?? 0.0,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      valLoss: (json['val_loss'] as num?)?.toDouble(),
      valAccuracy: (json['val_accuracy'] as num?)?.toDouble(),
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'epoch': epoch,
      'step': step,
      'loss': loss,
      'accuracy': accuracy,
      'val_loss': valLoss,
      'val_accuracy': valAccuracy,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    epoch,
    step,
    loss,
    accuracy,
    valLoss,
    valAccuracy,
    message,
    timestamp,
  ];
}

class TrainingSession extends Equatable {
  final String id;
  final String modelId;
  final TrainingStatus status;
  final TrainingMode mode;
  final int currentEpoch;
  final int totalEpochs;
  final double progress;
  final double currentLoss;
  final double? currentAccuracy;
  final List<TrainingLog> logs;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? errorMessage;

  const TrainingSession({
    required this.id,
    required this.modelId,
    required this.status,
    required this.mode,
    this.currentEpoch = 0,
    required this.totalEpochs,
    this.progress = 0.0,
    this.currentLoss = 0.0,
    this.currentAccuracy,
    this.logs = const [],
    required this.startedAt,
    this.completedAt,
    this.errorMessage,
  });

  TrainingSession copyWith({
    String? id,
    String? modelId,
    TrainingStatus? status,
    TrainingMode? mode,
    int? currentEpoch,
    int? totalEpochs,
    double? progress,
    double? currentLoss,
    double? currentAccuracy,
    List<TrainingLog>? logs,
    DateTime? startedAt,
    DateTime? completedAt,
    String? errorMessage,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      modelId: modelId ?? this.modelId,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      currentEpoch: currentEpoch ?? this.currentEpoch,
      totalEpochs: totalEpochs ?? this.totalEpochs,
      progress: progress ?? this.progress,
      currentLoss: currentLoss ?? this.currentLoss,
      currentAccuracy: currentAccuracy ?? this.currentAccuracy,
      logs: logs ?? this.logs,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      id: json['id'] as String,
      modelId: json['model_id'] as String,
      status: TrainingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TrainingStatus.idle,
      ),
      mode: TrainingMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => TrainingMode.local,
      ),
      currentEpoch: json['current_epoch'] as int? ?? 0,
      totalEpochs: json['total_epochs'] as int? ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      currentLoss: (json['current_loss'] as num?)?.toDouble() ?? 0.0,
      currentAccuracy: (json['current_accuracy'] as num?)?.toDouble(),
      logs:
          (json['logs'] as List<dynamic>?)
              ?.map((e) => TrainingLog.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      errorMessage: json['error_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model_id': modelId,
      'status': status.name,
      'mode': mode.name,
      'current_epoch': currentEpoch,
      'total_epochs': totalEpochs,
      'progress': progress,
      'current_loss': currentLoss,
      'current_accuracy': currentAccuracy,
      'logs': logs.map((e) => e.toJson()).toList(),
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'error_message': errorMessage,
    };
  }

  @override
  List<Object?> get props => [
    id,
    modelId,
    status,
    mode,
    currentEpoch,
    totalEpochs,
    progress,
    currentLoss,
    currentAccuracy,
    logs,
    startedAt,
    completedAt,
    errorMessage,
  ];
}
