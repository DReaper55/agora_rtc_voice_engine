import 'agora_rtc_voice_engine_platform_interface.dart';

import 'dart:async';
import 'package:flutter/services.dart';

class AgoraRtcVoiceEngine {
  static const MethodChannel _methodChannel =
  MethodChannel('com.danieluwadi.agora_rtc_voice_engine/methods');

  static const EventChannel _eventChannel =
  EventChannel('com.danieluwadi.agora_rtc_voice_engine/events');

  static Stream<dynamic>? _eventStream;

  static Stream<dynamic> get events {
    _eventStream ??= _eventChannel.receiveBroadcastStream();
    return _eventStream!;
  }

  Future<String?> getPlatformVersion() {
    return AgoraRtcVoiceEnginePlatform.instance.getPlatformVersion();
  }

  // --- Initialization ---
  static Future<void> initialize(String appId) async {
    await _methodChannel.invokeMethod('initialize', {'appId': appId});
  }

  static Future<void> release() async {
    await _methodChannel.invokeMethod('release');
  }

  // --- Join / Leave ---
  static Future<void> joinChannel(String? token, String channelName, int uid) async {
    await _methodChannel.invokeMethod('joinChannel', {
      'token': token,
      'channelName': channelName,
      'uid': uid,
    });
  }

  static Future<void> leaveChannel() async {
    await _methodChannel.invokeMethod('leaveChannel');
  }

  // --- Audio controls ---
  static Future<void> muteLocalAudioStream(bool mute) async {
    await _methodChannel.invokeMethod('muteLocalAudioStream', {'mute': mute});
  }

  static Future<void> muteRemoteAudioStream(int uid, bool mute) async {
    await _methodChannel.invokeMethod('muteRemoteAudioStream', {'uid': uid, 'mute': mute});
  }

  static Future<void> muteAllRemoteAudioStreams(bool mute) async {
    await _methodChannel.invokeMethod('muteAllRemoteAudioStreams', {'mute': mute});
  }

  static Future<void> enableLocalAudio(bool enabled) async {
    await _methodChannel.invokeMethod('enableLocalAudio', {'enabled': enabled});
  }

  static Future<void> setVolume(int uid, int volume) async {
    await _methodChannel.invokeMethod('setRemoteUserVolume', {'uid': uid, 'volume': volume});
  }

  // --- Others ---
  static Future<void> enableAudioVolumeIndication(int interval, int smooth) async {
    await _methodChannel.invokeMethod('enableAudioVolumeIndication', {'interval': interval, 'smooth': smooth});
  }

  // Helper to forward arbitrary method names (useful for parity)
  static Future<dynamic> invoke(String method, [Map<String, dynamic>? args]) async {
    return await _methodChannel.invokeMethod(method, args ?? {});
  }
}