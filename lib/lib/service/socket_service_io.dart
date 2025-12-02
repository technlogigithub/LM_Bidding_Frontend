import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  WebSocket? _socket;
  Function(Map<String, dynamic>)? _onMessage;

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
      return 'ws://10.252.34.70:8080'; // Android emulator
    }
    return 'ws://localhost:8080';
  }

  void sendMessage(Map<String, dynamic> messageData) {
    if (_socket?.readyState == WebSocket.open) {
      _socket!.add(jsonEncode({'type': 'message', ...messageData}));
      debugPrint('📤 Sent: $messageData');
    } else {
      debugPrint('⚠️ Socket not connected');
    }
  }

  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    _onMessage = callback;
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
    debugPrint('🔌 Disconnected from WebSocket');
  }
}
