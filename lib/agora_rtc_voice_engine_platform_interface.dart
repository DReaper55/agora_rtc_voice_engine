import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'agora_rtc_voice_engine_method_channel.dart';

abstract class AgoraRtcVoiceEnginePlatform extends PlatformInterface {
  /// Constructs a AgoraRtcVoiceEnginePlatform.
  AgoraRtcVoiceEnginePlatform() : super(token: _token);

  static final Object _token = Object();

  static AgoraRtcVoiceEnginePlatform _instance = MethodChannelAgoraRtcVoiceEngine();

  /// The default instance of [AgoraRtcVoiceEnginePlatform] to use.
  ///
  /// Defaults to [MethodChannelAgoraRtcVoiceEngine].
  static AgoraRtcVoiceEnginePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AgoraRtcVoiceEnginePlatform] when
  /// they register themselves.
  static set instance(AgoraRtcVoiceEnginePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  // ===== Engine lifecycle =====
  Future<void> initialize({
    required String appId,
    String? areaCode,
  });

  Future<void> release();

  // ===== Method Calls =====
  Future<void> joinChannel(String token, String channelName, int uid);
  Future<void> leaveChannel();

  // ===== Event Streams =====
  Stream<Map<dynamic, dynamic>> get events;
  Stream<Map<dynamic, dynamic>> get onUserJoined;
  Stream<Map<dynamic, dynamic>> get onUserOffline;
  Stream<Map<dynamic, dynamic>> get onAudioVolumeIndication;
}
