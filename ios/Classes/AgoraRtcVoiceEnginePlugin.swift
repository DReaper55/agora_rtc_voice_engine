import Flutter
import UIKit
import AgoraRtcKit

public class AgoraRtcVoiceEnginePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  var eventSink: FlutterEventSink?
      var agoraEngine: AgoraRtcEngineKit?

      public static func register(with registrar: FlutterPluginRegistrar) {
          let methodChannel = FlutterMethodChannel(name: "com.danieluwadi.agora_rtc_voice_engine/methods", binaryMessenger: registrar.messenger())
          let eventChannel = FlutterEventChannel(name: "com.danieluwadi.agora_rtc_voice_engine/events", binaryMessenger: registrar.messenger())

          let instance = AgoraRtcVoiceEnginePlugin()
          registrar.addMethodCallDelegate(instance, channel: methodChannel)
          eventChannel.setStreamHandler(instance)
      }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "initialize":
      guard let args = call.arguments as? [String: Any],
            let appId = args["appId"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "App ID is required", details: nil))
          return
      }
      let areaCode = args["areaCode"] as? String
      initializeAgora(appId: appId, areaCode: areaCode)
      result(nil)

    case "release":
        agoraEngine?.leaveChannel(nil)
        agoraEngine = nil
        result(nil)

    case "joinChannel":
        let args = call.arguments as! [String: Any]
        let token = args["token"] as? String
        let channelName = args["channelName"] as! String
        let uid = args["uid"] as? UInt ?? 0
        agoraEngine?.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid, joinSuccess: nil)
        result(nil)

    case "leaveChannel":
        agoraEngine?.leaveChannel(nil)
        result(nil)

    case "enableAudioVolumeIndication":
        let args = call.arguments as! [String: Any]
        let interval = args["interval"] as? Int ?? 200
        let smooth = args["smooth"] as? Int ?? 3
        let reportVad = args["reportVad"] as? Bool ?? false
        agoraEngine?.enableAudioVolumeIndication(interval, smooth: smooth, report_vad: reportVad)
        result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func initializeAgora(appId: String, areaCode: String?) {
          agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
          // areaCode isn't directly applied in iOS SDK init, handled via channel profile/config if needed
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
          self.eventSink = events
          return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
      self.eventSink = nil
      return nil
  }
}

extension AgoraRtcVoiceEnginePlugin: AgoraRtcEngineDelegate {
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        eventSink?(["event": "onUserJoined", "uid": uid])
    }

    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        eventSink?(["event": "onUserOffline", "uid": uid])
    }

    public func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        let list = speakers.map { ["uid": $0.uid, "volume": $0.volume] }
        eventSink?(["event": "onAudioVolumeIndication", "speakers": list])
    }
}
