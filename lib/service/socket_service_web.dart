import 'dart:convert';
import 'dart:html';
import 'socket_service_interface.dart';

class SocketServiceImpl implements SocketService {
  WebSocket? _socket;
  Function(Map<String, dynamic>)? _onMessage;

  @override
  Future<void> connect(String userId) async {
    const url = 'wss://phplaravel-1517766-5835172.cloudwaysapps.com:9001';
    print('🌐 Connecting to $url...');
    _socket = WebSocket(url);

    _socket!.onOpen.listen((_) {
      print('✅ Connected to WebSocket (Web)');
      _socket!.send(jsonEncode({'type': 'init', 'userId': userId}));
    });

    _socket!.onMessage.listen((event) {
      try {
        final decoded = jsonDecode(event.data);
        _onMessage?.call(decoded);
      } catch (e) {
        print('⚠️ Decode error: $e');
      }
    });

    _socket!.onError.listen((_) => print('❌ WebSocket error'));
    _socket!.onClose.listen((_) => print('⚠️ Disconnected (Web)'));
  }

  @override
  void sendMessage(Map<String, dynamic> data) {
    if (_socket != null && _socket!.readyState == WebSocket.OPEN) {
      _socket!.send(jsonEncode({'type': 'message', ...data}));
      print('📤 Sent: $data');
    } else {
      print('⚠️ Socket not connected');
    }
  }

  @override
  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    _onMessage = callback;
  }

  @override
  void disconnect() {
    _socket?.close();
    _socket = null;
    print('🔌 Disconnected from WebSocket');
  }
}
