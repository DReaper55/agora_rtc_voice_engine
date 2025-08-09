// import 'package:flutter_test/flutter_test.dart';
// import 'package:agora_rtc_voice_engine/agora_rtc_voice_engine.dart';
// import 'package:agora_rtc_voice_engine/agora_rtc_voice_engine_platform_interface.dart';
// import 'package:agora_rtc_voice_engine/agora_rtc_voice_engine_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockAgoraRtcVoiceEnginePlatform
//     with MockPlatformInterfaceMixin
//     implements AgoraRtcVoiceEnginePlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final AgoraRtcVoiceEnginePlatform initialPlatform = AgoraRtcVoiceEnginePlatform.instance;
//
//   test('$MethodChannelAgoraRtcVoiceEngine is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelAgoraRtcVoiceEngine>());
//   });
//
//   test('getPlatformVersion', () async {
//     AgoraRtcVoiceEngine agoraRtcVoiceEnginePlugin = AgoraRtcVoiceEngine();
//     MockAgoraRtcVoiceEnginePlatform fakePlatform = MockAgoraRtcVoiceEnginePlatform();
//     AgoraRtcVoiceEnginePlatform.instance = fakePlatform;
//
//     expect(await agoraRtcVoiceEnginePlugin.getPlatformVersion(), '42');
//   });
// }
