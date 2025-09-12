import 'package:rimes_flutter/utils/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(APiConstants.baseURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected: ${socket.id}');
    });

    socket.onDisconnect((_) => print('Disconnected'));

    socket.on('wordcount:result', (data) {
      print('Word count: ${data['count']}');
    });
  }

  void onWordCount(void Function(int count) callback) {
    socket.on('wordcount:result', (data) {
      callback(data['count'] ?? 0);
    });
  }

  void sendText(String text) {
    socket.emit('wordcount:calculate', {'text': text, "count": text.length});
  }
}
