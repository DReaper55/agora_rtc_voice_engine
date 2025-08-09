package com.danieluwadi.agora_rtc_voice_engine

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.agora.rtc2.{RtcEngine, IRtcEngineEventHandler}

class AgoraRtcVoiceEnginePlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private var rtcEngine: RtcEngine? = null
  private var applicationContext: Context? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "agora_rtc_voice_engine")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "initialize" -> {
        val appId = call.argument<String>("appId") ?: run { result.error("NO_APPID", "appId missing", null); return }
        if (rtcEngine == null) {
          rtcEngine = RtcEngine.create(applicationContext, appId, object : IRtcEngineEventHandler() {})
          // audio-only configuration
          rtcEngine?.setChannelProfile(io.agora.rtc2.Constants.CHANNEL_PROFILE_COMMUNICATION)
          rtcEngine?.disableVideo()
        }
        result.success(null)
      }
      "release" -> {
        rtcEngine?.let { RtcEngine.destroy() ; rtcEngine = null }
        result.success(null)
      }
      "joinChannel" -> {
        val token = call.argument<String>("token")
        val channelName = call.argument<String>("channelName")!!
        val uid = call.argument<Int>("uid") ?: 0
        rtcEngine?.joinChannel(token, channelName, "", uid)
        result.success(null)
      }
      "leaveChannel" -> {
        rtcEngine?.leaveChannel()
        result.success(null)
      }
      "muteLocalAudioStream" -> {
        val mute = call.argument<Boolean>("mute") ?: false
        rtcEngine?.muteLocalAudioStream(mute)
        result.success(null)
      }
      "muteRemoteAudioStream" -> {
        val uid = call.argument<Int>("uid") ?: 0
        val mute = call.argument<Boolean>("mute") ?: false
        rtcEngine?.muteRemoteAudioStream(uid, mute)
        result.success(null)
      }
      "muteAllRemoteAudioStreams" -> {
        val mute = call.argument<Boolean>("mute") ?: false
        rtcEngine?.muteAllRemoteAudioStreams(mute)
        result.success(null)
      }
      "enableLocalAudio" -> {
        val enabled = call.argument<Boolean>("enabled") ?: true
        rtcEngine?.enableLocalAudio(enabled)
        result.success(null)
      }
      "setRemoteUserVolume" -> {
        val uid = call.argument<Int>("uid") ?: 0
        val volume = call.argument<Int>("volume") ?: 100
        rtcEngine?.adjustUserPlaybackSignalVolume(uid, volume)
        result.success(null)
      }
      "enableAudioVolumeIndication" -> {
        val interval = call.argument<Int>("interval") ?: 200
        val smooth = call.argument<Int>("smooth") ?: 3
        rtcEngine?.enableAudioVolumeIndication(interval, smooth, true)
        result.success(null)
      }
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    rtcEngine?.let { RtcEngine.destroy(); rtcEngine = null }
  }
}