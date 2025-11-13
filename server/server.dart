
import 'dart:io';
import 'dart:convert';


final Map<String, WebSocket> clients = {};

void main() async {
  final server = await HttpServer.bind('0.0.0.0', 8080);
  print('✅ WebSocket Server running on ws://localhost:8080');

  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      final socket = await WebSocketTransformer.upgrade(request);
      print('👤 Client connected');

      socket.listen((data) {
        try {
          final msg = jsonDecode(data);
          print('📩 Received: $msg');

          if (msg['type'] == 'init') {
            // Register userId
            clients[msg['userId']] = socket;
            print('🔗 Registered ${msg['userId']}');
          } else if (msg['type'] == 'message') {
            // Send to the specific receiver
            final receiverId = msg['receiverId'];
            if (clients.containsKey(receiverId)) {
              clients[receiverId]!.add(jsonEncode(msg));
              print('📤 Sent to $receiverId');
            } else {
              print('⚠️ Receiver not connected');
            }
          }
        } catch (e) {
          print('⚠️ Error: $e');
        }
      }, onDone: () {
        print('❌ A client disconnected');
        clients.removeWhere((_, ws) => ws == socket);
      });
    } else {
      request.response
        ..statusCode = HttpStatus.forbidden
        ..write('WebSocket connections only!')
        ..close();
    }
  }
}
