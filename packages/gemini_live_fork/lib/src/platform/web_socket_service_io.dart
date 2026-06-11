import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Creates a WebSocket connection with custom HTTP headers.
///
/// This is critical for Vertex AI authentication: the [headers] map
/// carries the Authorization Bearer token and X-Goog-User-Project header.
Future<WebSocketChannel> connect(Uri uri, Map<String, dynamic> headers) async {
  final webSocket = await WebSocket.connect(
    uri.toString(),
    headers: headers,
  );
  return IOWebSocketChannel(webSocket);
}
