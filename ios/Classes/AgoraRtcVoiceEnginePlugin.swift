import Flutter
import UIKit
import AgoraRtcKit

public class AgoraRtcVoiceEnginePlugin: NSObject, FlutterPlugin {
  var engine: AgoraRtcEngineKit?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "agora_rtc_voice_engine", binaryMessenger: registrar.messenger())
    let instance = AgoraRtcVoiceEnginePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "initialize":
          guard let args = call.arguments as? [String:Any], let appId = args["appId"] as? String else { result(FlutterError(code: "NO_APPID", message: "appId missing", details: nil)); return }
          if engine == nil {
            engine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
            engine?.setChannelProfile(.communication)
            engine?.disableVideo()
          }
          result(nil)

    case "release":
      if let _ = engine {
        AgoraRtcEngineKit.destroy()
        engine = nil
      }
      result(nil)

    case "joinChannel":
      guard let args = call.arguments as? [String:Any], let channelName = args["channelName"] as? String, let uid = args["uid"] as? UInt else { result(FlutterError(code: "MISSING_ARGS", message: "channelName/uid missing", details: nil)); return }
      let token = (call.arguments as? [String:Any])?["token"] as? String
      engine?.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid, joinSuccess: nil)
      result(nil)

    case "leaveChannel":
      engine?.leaveChannel(nil)
      result(nil)

    case "muteLocalAudioStream":
      if let args = call.arguments as? [String:Any], let mute = args["mute"] as? Bool {
        engine?.muteLocalAudioStream(mute)
      }
      result(nil)

    case "muteRemoteAudioStream":
      if let args = call.arguments as? [String:Any], let uid = args["uid"] as? UInt, let mute = args["mute"] as? Bool {
        engine?.muteRemoteAudioStream(uid, mute: mute)
      }
      result(nil)

    case "muteAllRemoteAudioStreams":
      if let args = call.arguments as? [String:Any], let mute = args["mute"] as? Bool {
        engine?.muteAllRemoteAudioStreams(mute)
      }
      result(nil)

    case "enableLocalAudio":
      if let args = call.arguments as? [String:Any], let enabled = args["enabled"] as? Bool {
        engine?.enableLocalAudio(enabled)
      }
      result(nil)

    case "setRemoteUserVolume":
      if let args = call.arguments as? [String:Any], let uid = args["uid"] as? UInt, let volume = args["volume"] as? Int {
        engine?.adjustUserPlay

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
