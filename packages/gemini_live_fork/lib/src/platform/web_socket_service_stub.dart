import 'package:web_socket_channel/web_socket_channel.dart';

/// Stub for platforms without dart:io or dart:html.
Future<WebSocketChannel> connect(Uri uri, Map<String, dynamic> headers) {
  throw UnsupportedError(
    'Cannot create a web socket channel without dart:html or dart:io.',
  );
}
