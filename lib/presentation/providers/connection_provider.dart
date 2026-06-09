import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/core/network/api_service.dart';
import 'package:artificial_flash/core/network/websocket_service.dart';
import 'package:artificial_flash/core/constants/app_constants.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectionConfigProvider =
    StateNotifierProvider<ConnectionConfigNotifier, ConnectionConfig>((ref) {
      return ConnectionConfigNotifier();
    });

class ConnectionConfig {
  final String host;
  final int port;
  final bool isRemote;
  final bool isConnected;
  final bool useTls;

  const ConnectionConfig({
    this.host = ApiConstants.defaultLocalHost,
    this.port = ApiConstants.defaultPort,
    this.isRemote = false,
    this.isConnected = false,
    this.useTls = false,
  });

  ConnectionConfig copyWith({
    String? host,
    int? port,
    bool? isRemote,
    bool? isConnected,
    bool? useTls,
  }) {
    return ConnectionConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      isRemote: isRemote ?? this.isRemote,
      isConnected: isConnected ?? this.isConnected,
      useTls: useTls ?? this.useTls,
    );
  }
}

class ConnectionConfigNotifier extends StateNotifier<ConnectionConfig> {
  ConnectionConfigNotifier() : super(const ConnectionConfig());

  void updateHost(String host) {
    state = state.copyWith(host: host);
  }

  void updatePort(int port) {
    if (port >= 1 && port <= 65535) {
      state = state.copyWith(port: port);
    }
  }

  void setRemote(bool isRemote) {
    state = state.copyWith(isRemote: isRemote, useTls: isRemote);
  }

  void setConnected(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }
}

final currentIndexProvider = StateProvider<int>((ref) => 0);
