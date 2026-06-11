import 'package:web_socket_channel/html.dart' as ws;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Web platform WebSocket connector.
/// Headers are not supported in browser WebSocket — auth must be in URL.
Future<WebSocketChannel> connect(Uri uri, Map<String, dynamic> headers) async {
  return ws.HtmlWebSocketChannel.connect(uri);
}
