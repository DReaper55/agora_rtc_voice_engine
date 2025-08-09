package com.danieluwadi.agora_rtc_voice_engine

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.agora.rtc2.*

class AgoraRtcVoiceEnginePlugin: FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private var rtcEngine: RtcEngine? = null
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    methodChannel = MethodChannel(binding.binaryMessenger, "com.danieluwadi.agora_rtc_voice_engine/methods")
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(binding.binaryMessenger, "com.danieluwadi.agora_rtc_voice_engine/events")
    eventChannel.setStreamHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "initialize" -> {
        val appId = call.argument<String>("appId")!!
        rtcEngine = RtcEngine.create(context, appId, object : IRtcEngineEventHandler() {
          override fun onUserJoined(uid: Int, elapsed: Int) {
            eventSink?.success(mapOf("event" to "onUserJoined", "uid" to uid))
          }

          override fun onUserOffline(uid: Int, reason: Int) {
            eventSink?.success(mapOf("event" to "onUserOffline", "uid" to uid))
          }

          override fun onAudioVolumeIndication(speakers: Array<out AudioVolumeInfo>?, totalVolume: Int) {
            val list = speakers?.map { mapOf("uid" to it.uid, "volume" to it.volume) } ?: emptyList()
            eventSink?.success(mapOf("event" to "onAudioVolumeIndication", "speakers" to list))
          }
        })
        rtcEngine?.setChannelProfile(Constants.CHANNEL_PROFILE_COMMUNICATION)
        result.success(null)
      }
      "joinChannel" -> {
        val token = call.argument<String>("token")!!
        val channelName = call.argument<String>("channelName")!!
        val uid = call.argument<Int>("uid") ?: 0
        rtcEngine?.joinChannel(token, channelName, null, uid)
        result.success(null)
      }
      "leaveChannel" -> {
        rtcEngine?.leaveChannel()
        result.success(null)
      }
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      else -> result.notImplemented()
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }
}