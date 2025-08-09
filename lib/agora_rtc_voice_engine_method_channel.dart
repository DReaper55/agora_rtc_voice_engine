import 'package:flutter/services.dart';

import 'agora_rtc_voice_engine_platform_interface.dart';

/// An implementation of [AgoraRtcVoiceEnginePlatform] that uses method channels.
class MethodChannelAgoraRtcVoiceEngine extends AgoraRtcVoiceEnginePlatform {
  static const MethodChannel _methodChannel =
  MethodChannel('com.danieluwadi.agora_rtc_voice_engine/methods');

  static const EventChannel _eventChannel =
  EventChannel('com.danieluwadi.agora_rtc_voice_engine/events');

  Stream<Map<dynamic, dynamic>>? _eventStream;

  @override
  Future<String?> getPlatformVersion() async {
    final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initialize({
    required String appId,
    String? areaCode,
  }) {
    return _methodChannel.invokeMethod('initialize', {
      'appId': appId,
      'areaCode': areaCode,
    });
  }

  @override
  Future<void> release() {
    return _methodChannel.invokeMethod('release');
  }

  @override
  Future<void> joinChannel(String token, String channelName, int uid) {
    return _methodChannel.invokeMethod('joinChannel', {
      'token': token,
      'channelName': channelName,
      'uid': uid,
    });
  }

  @override
  Future<void> leaveChannel() {
    return _methodChannel.invokeMethod('leaveChannel');
  }

  // ===== Event Streams =====
  @override
  Stream<Map<dynamic, dynamic>> get events {
    _eventStream ??= _eventChannel
        .receiveBroadcastStream()
        .map((event) => Map<dynamic, dynamic>.from(event));
    return _eventStream!;
  }

  @override
  Stream<Map<dynamic, dynamic>> get onUserJoined =>
      events.where((e) => e['event'] == 'onUserJoined');

  @override
  Stream<Map<dynamic, dynamic>> get onUserOffline =>
      events.where((e) => e['event'] == 'onUserOffline');

  @override
  Stream<Map<dynamic, dynamic>> get onAudioVolumeIndication =>
      events.where((e) => e['event'] == 'onAudioVolumeIndication');
}
