import 'dart:async';
import 'package:flutter/services.dart';

class AgoraRtcVoiceEngineEventChannel {
  static const EventChannel _eventChannel =
  EventChannel('com.danieluwadi.agora_rtc_voice_engine/events');

  static Stream<Map<dynamic, dynamic>>? _stream;

  /// Returns a broadcast stream of Agora events
  static Stream<Map<dynamic, dynamic>> get events {
    _stream ??= _eventChannel
        .receiveBroadcastStream()
        .map((event) => Map<dynamic, dynamic>.from(event));
    return _stream!;
  }

  /// Convenience listener for `onUserJoined`
  static Stream<Map<dynamic, dynamic>> get onUserJoined =>
      events.where((e) => e['event'] == 'onUserJoined');

  /// Convenience listener for `onUserOffline`
  static Stream<Map<dynamic, dynamic>> get onUserOffline =>
      events.where((e) => e['event'] == 'onUserOffline');

  /// Convenience listener for `onAudioVolumeIndication`
  static Stream<Map<dynamic, dynamic>> get onAudioVolumeIndication =>
      events.where((e) => e['event'] == 'onAudioVolumeIndication');
}
