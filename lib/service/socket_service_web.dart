import 'dart:convert';
import 'dart:html';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  WebSocket? _socket;
  Function(Map<String, dynamic>)? _onMessage;

  Future<void> connect(String userId) async {
    const url = 'ws://192.168.1.5:8080'; // 👈 Replace with your PC’s LAN IP
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

  void sendMessage(Map<String, dynamic> messageData) {
    if (_socket != null && _socket!.readyState == WebSocket.OPEN) {
      _socket!.send(jsonEncode({'type': 'message', ...messageData}));
      print('📤 Sent: $messageData');
    } else {
      print('⚠️ Socket not connected');
    }
  }

  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    _onMessage = callback;
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
    print('🔌 Disconnected from WebSocket');
  }
}
