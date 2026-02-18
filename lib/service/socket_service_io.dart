import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'socket_service_interface.dart';

class SocketServiceImpl implements SocketService {
  WebSocket? _socket;
  Function(Map<String, dynamic>)? _onMessage;

  @override
  Future<void> connect(String userId) async {
    try {
      final url = _getServerUrl();
      debugPrint('🔌 Connecting to $url...');
      _socket = await WebSocket.connect(url);
      debugPrint('✅ Connected to WebSocket (Mobile/Desktop)');

      _socket!.add(jsonEncode({'type': 'init', 'userId': userId}));

      _socket!.listen(
            (data) {
          try {
            final decoded = jsonDecode(data);
            _onMessage?.call(decoded);
          } catch (e) {
            debugPrint('⚠️ Decode error: $e');
          }
        },
        onError: (err) => debugPrint('❌ WebSocket error: $err'),
        onDone: () => debugPrint('⚠️ Disconnected'),
      );
    } catch (e) {
      debugPrint('🚫 Failed to connect: $e');
    }
  }

  String _getServerUrl() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // ✅ REAL ANDROID PHONE
      return 'ws://143.110.183.169:9001';
    }
    return 'ws://143.110.183.169:9001';
  }


  @override
  void sendMessage(Map<String, dynamic> data) {
    if (_socket?.readyState == WebSocket.open) {
      _socket!.add(jsonEncode({'type': 'message', ...data}));
      debugPrint('📤 Sent: $data');
    } else {
      debugPrint('⚠️ Socket not connected');
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
    debugPrint('🔌 Disconnected from WebSocket');
  }
}
