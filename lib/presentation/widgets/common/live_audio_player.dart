import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class LiveAudioPlayer {
  LiveAudioPlayer() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  final AudioPlayer _player = AudioPlayer();
  final List<int> _pcmBytes = <int>[];

  bool get hasBufferedAudio => _pcmBytes.isNotEmpty;

  void appendBase64Chunk(String base64Chunk) {
    if (base64Chunk.isEmpty) return;
    _pcmBytes.addAll(base64Decode(base64Chunk));
  }

  void clear() {
    _pcmBytes.clear();
  }

  Future<void> playBufferedAudio() async {
    if (_pcmBytes.isEmpty) return;
    final bytes = Uint8List.fromList(_pcmBytes);
    _pcmBytes.clear();
    try {
      final wavBytes = _addWavHeader(bytes, sampleRate: 24000);
      await _player.play(BytesSource(wavBytes, mimeType: 'audio/wav'));
    } catch (error) {
      debugPrint('Audio playback failed: $error');
    }
  }

  Future<void> stop() async {
    clear();
    await _player.stop();
  }

  Future<void> dispose() async {
    clear();
    await _player.dispose();
  }

  static Uint8List _addWavHeader(Uint8List pcmBytes, {int sampleRate = 24000}) {
    final channels = 1;
    final bitsPerSample = 16;
    final byteRate = sampleRate * channels * bitsPerSample ~/ 8;
    final blockAlign = channels * bitsPerSample ~/ 8;
    final dataSize = pcmBytes.length;
    final fileSize = 36 + dataSize;

    final header = ByteData(44);
    header.setUint8(0, 0x52);
    header.setUint8(1, 0x49);
    header.setUint8(2, 0x46);
    header.setUint8(3, 0x46);
    header.setUint32(4, fileSize, Endian.little);
    header.setUint8(8, 0x57);
    header.setUint8(9, 0x41);
    header.setUint8(10, 0x56);
    header.setUint8(11, 0x45);
    header.setUint8(12, 0x66);
    header.setUint8(13, 0x6D);
    header.setUint8(14, 0x74);
    header.setUint8(15, 0x20);
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little);
    header.setUint16(22, channels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, bitsPerSample, Endian.little);
    header.setUint8(36, 0x64);
    header.setUint8(37, 0x61);
    header.setUint8(38, 0x74);
    header.setUint8(39, 0x61);
    header.setUint32(40, dataSize, Endian.little);

    final result = Uint8List(44 + dataSize);
    result.setRange(0, 44, header.buffer.asUint8List());
    result.setRange(44, 44 + dataSize, pcmBytes);
    return result;
  }
}
