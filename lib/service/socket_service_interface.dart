import 'dart:convert';

abstract class SocketService {
  Future<void> connect(String userId);
  void sendMessage(Map<String, dynamic> data);
  void onMessageReceived(Function(Map<String, dynamic>) cb);
  void disconnect();
}
