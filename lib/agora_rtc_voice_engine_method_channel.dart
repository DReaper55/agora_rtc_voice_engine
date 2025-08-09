import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'agora_rtc_voice_engine_platform_interface.dart';

/// An implementation of [AgoraRtcVoiceEnginePlatform] that uses method channels.
class MethodChannelAgoraRtcVoiceEngine extends AgoraRtcVoiceEnginePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('agora_rtc_voice_engine');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
