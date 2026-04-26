import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/domain/entities/training.dart';
import 'package:artificial_flash/domain/entities/model.dart';
import 'package:artificial_flash/core/network/api_service.dart';
import 'package:artificial_flash/core/network/websocket_service.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/presentation/providers/model_provider.dart';
import 'package:uuid/uuid.dart';

final trainingSessionProvider =
    StateNotifierProvider<
      TrainingSessionNotifier,
      AsyncValue<TrainingSession?>
    >((ref) {
      return TrainingSessionNotifier(ref);
    });

class TrainingSessionNotifier
    extends StateNotifier<AsyncValue<TrainingSession?>> {
  final Ref _ref;
  final _uuid = const Uuid();
  StreamSubscription? _wsSubscription;

  TrainingSessionNotifier(this._ref) : super(const AsyncValue.data(null)) {
    _initWebSocketListener();
  }

  ApiService get _api => _ref.read(apiServiceProvider);
  WebSocketService get _ws => _ref.read(webSocketServiceProvider);

  void _initWebSocketListener() {
    _wsSubscription = _ws.messageStream.listen((message) {
      _handleWebSocketMessage(message);
    });
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final type = message['type'] as String?;

    if (type == 'training_update') {
      final data = message['data'] as Map<String, dynamic>?;
      if (data != null) {
        final log = TrainingLog.fromJson(data);
        state.whenData((session) {
          if (session != null) {
            final newLogs = [...session.logs, log];
            if (newLogs.length > 1000) {
              newLogs.removeAt(0);
            }

            final progress = session.totalEpochs > 0
                ? session.currentEpoch / session.totalEpochs
                : 0.0;

            state = AsyncValue.data(
              session.copyWith(
                currentEpoch: log.epoch,
                currentLoss: log.loss,
                currentAccuracy: log.accuracy,
                progress: progress,
                logs: newLogs,
              ),
            );
          }
        });
      }
    } else if (type == 'training_complete') {
      final data = message['data'] as Map<String, dynamic>?;
      if (data != null) {
        state.whenData((session) {
          if (session != null) {
            state = AsyncValue.data(
              session.copyWith(
                status: TrainingStatus.completed,
                completedAt: DateTime.now(),
                progress: 1.0,
              ),
            );

            if (data['model'] != null) {
              final trainedModel = Model.fromJson(
                data['model'] as Map<String, dynamic>,
              );
              _ref.read(modelsProvider.notifier).updateModel(trainedModel);
            }
          }
        });
      }
    } else if (type == 'training_error') {
      state.whenData((session) {
        if (session != null) {
          state = AsyncValue.data(
            session.copyWith(
              status: TrainingStatus.error,
              errorMessage: message['error'] as String? ?? 'Unknown error',
            ),
          );
        }
      });
    }
  }

  Future<void> startTraining({
    required Model model,
    required TrainingMode mode,
  }) async {
    final session = TrainingSession(
      id: _uuid.v4(),
      modelId: model.id,
      status: TrainingStatus.preparing,
      mode: mode,
      totalEpochs: model.params?.epochs ?? 10,
      startedAt: DateTime.now(),
    );

    state = AsyncValue.data(session);

    try {
      if (mode == TrainingMode.remote) {
        await _api.post(
          '/training/start',
          data: {'model_id': model.id, 'session_id': session.id},
        );
      }

      state.whenData((s) {
        if (s != null) {
          state = AsyncValue.data(s.copyWith(status: TrainingStatus.training));
        }
      });
    } catch (e) {
      state.whenData((s) {
        if (s != null) {
          state = AsyncValue.data(
            s.copyWith(
              status: TrainingStatus.error,
              errorMessage: e.toString(),
            ),
          );
        }
      });
    }
  }

  Future<void> pauseTraining() async {
    try {
      await _api.post('/training/pause');
      state.whenData((session) {
        if (session != null) {
          state = AsyncValue.data(
            session.copyWith(status: TrainingStatus.paused),
          );
        }
      });
    } catch (e) {
      state.whenData((session) {
        if (session != null) {
          state = AsyncValue.data(
            session.copyWith(status: TrainingStatus.paused),
          );
        }
      });
    }
  }

  Future<void> resumeTraining() async {
    try {
      await _api.post('/training/resume');
      state.whenData((session) {
        if (session != null) {
          state = AsyncValue.data(
            session.copyWith(status: TrainingStatus.training),
          );
        }
      });
    } catch (e) {
      state.whenData((session) {
        if (session != null) {
          state = AsyncValue.data(
            session.copyWith(status: TrainingStatus.training),
          );
        }
      });
    }
  }

  Future<void> stopTraining() async {
    try {
      await _api.post('/training/stop');
    } catch (e) {
      // Ignore errors
    }

    state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    super.dispose();
  }
}

final trainingLogsProvider = Provider<List<TrainingLog>>((ref) {
  final session = ref.watch(trainingSessionProvider);
  return session.whenData((s) => s?.logs ?? []).value ?? [];
});

final isTrainingProvider = Provider<bool>((ref) {
  final session = ref.watch(trainingSessionProvider);
  return session
          .whenData(
            (s) =>
                s?.status == TrainingStatus.training ||
                s?.status == TrainingStatus.preparing ||
                s?.status == TrainingStatus.paused,
          )
          .value ??
      false;
});
