import 'dart:async';

import 'agora_rtc_voice_engine_platform_interface.dart';
import 'agora_rtc_voice_engine_method_channel.dart';

class AgoraRtcVoiceEngine {
  AgoraRtcVoiceEngine._(); // private constructor
  static final AgoraRtcVoiceEngine instance = AgoraRtcVoiceEngine._();

  // Stream controllers for each event type
  final _userJoinedController = StreamController<Map<dynamic, dynamic>>.broadcast();
  final _userOfflineController = StreamController<Map<dynamic, dynamic>>.broadcast();
  final _audioVolumeController = StreamController<Map<dynamic, dynamic>>.broadcast();

  StreamSubscription? _eventSub;

  static void registerWithPlatform() {
    AgoraRtcVoiceEnginePlatform.instance = MethodChannelAgoraRtcVoiceEngine();
  }

  Future<String?> getPlatformVersion() {
    return AgoraRtcVoiceEnginePlatform.instance.getPlatformVersion();
  }

  // ===== Engine lifecycle =====
  Future<void> initialize({
    required String appId,
    String? areaCode,
  }) async {
    // Initialize platform
    await AgoraRtcVoiceEnginePlatform.instance.initialize(
      appId: appId,
      areaCode: areaCode,
    );

    // Listen to native event channel
    _eventSub = AgoraRtcVoiceEnginePlatform.instance.events.listen((event) {
      final eventName = event['event'];
      final data = event['data'];

      switch (eventName) {
        case 'onUserJoined':
          _userJoinedController.add(data);
          break;
        case 'onUserOffline':
          _userOfflineController.add(data);
          break;
        case 'onAudioVolumeIndication':
          _audioVolumeController.add(data);
          break;
      }
    });
  }

  Future<void> release() async {
    await AgoraRtcVoiceEnginePlatform.instance.release();
    await _eventSub?.cancel();
    _eventSub = null;

    _userJoinedController.close();
    _userOfflineController.close();
    _audioVolumeController.close();
  }

  // ===== Method Calls =====
  Future<void> joinChannel(String token, String channelName, int uid) {
    return AgoraRtcVoiceEnginePlatform.instance
        .joinChannel(token, channelName, uid);
  }

  Future<void> leaveChannel() {
    return AgoraRtcVoiceEnginePlatform.instance.leaveChannel();
  }

  // ===== Event Streams =====
  Stream<Map<dynamic, dynamic>> get onUserJoined => _userJoinedController.stream;
  Stream<Map<dynamic, dynamic>> get onUserOffline => _userOfflineController.stream;
  Stream<Map<dynamic, dynamic>> get onAudioVolumeIndication => _audioVolumeController.stream;
}
