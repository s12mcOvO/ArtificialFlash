import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:artificial_flash/core/constants/app_constants.dart';

enum ConnectionStatus { disconnected, connecting, connected, error }

class WebSocketService {
  WebSocketChannel? _channel;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _statusController = StreamController<ConnectionStatus>.broadcast();

  String _host = ApiConstants.defaultLocalHost;
  int _port = ApiConstants.defaultPort;
  bool _useTls = false;
  Timer? _reconnectTimer;
  bool _shouldReconnect = true;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<ConnectionStatus> get statusStream => _statusController.stream;
  ConnectionStatus _status = ConnectionStatus.disconnected;
  ConnectionStatus get status => _status;

  void updateConnection(String host, int port, {bool useTls = false}) {
    _host = host;
    _port = port;
    _useTls = useTls;
  }

  Future<void> connect() async {
    if (_status == ConnectionStatus.connecting ||
        _status == ConnectionStatus.connected) {
      return;
    }

    _status = ConnectionStatus.connecting;
    _statusController.add(_status);

    try {
      final wsProtocol = _useTls ? 'wss' : ApiConstants.wsProtocol;
      final uri = Uri.parse(
        '$wsProtocol://$_host:$_port${ApiConstants.wsEndpoint}',
      );
      _channel = WebSocketChannel.connect(uri);

      await _channel!.ready;
      _status = ConnectionStatus.connected;
      _statusController.add(_status);

      _channel!.stream.listen(
        (data) {
          try {
            final decoded = json.decode(data as String) as Map<String, dynamic>;
            _messageController.add(decoded);
          } catch (e) {
            _messageController.add({
              'error': 'Failed to parse message',
              'raw': data,
            });
          }
        },
        onError: (error) {
          _status = ConnectionStatus.error;
          _statusController.add(_status);
          _attemptReconnect();
        },
        onDone: () {
          _status = ConnectionStatus.disconnected;
          _statusController.add(_status);
          if (_shouldReconnect) {
            _attemptReconnect();
          }
        },
      );
    } catch (e) {
      _status = ConnectionStatus.error;
      _statusController.add(_status);
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    if (!_shouldReconnect) return;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      const Duration(milliseconds: AppConstants.wsReconnectDelay),
      () => connect(),
    );
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_status != ConnectionStatus.connected || _channel == null) {
      return;
    }

    _channel!.sink.add(json.encode(message));
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _status = ConnectionStatus.disconnected;
    _statusController.add(_status);
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _statusController.close();
  }
}
