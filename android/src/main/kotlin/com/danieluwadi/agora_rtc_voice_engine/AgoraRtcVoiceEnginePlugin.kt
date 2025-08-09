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
        val appId = call.argument<String>("appId") ?: ""
        val areaCode = call.argument<String>("areaCode") ?: ""
        initializeAgora(appId, areaCode)
        result.success(null)
      }
      "release" -> {
        rtcEngine?.leaveChannel()
        RtcEngine.destroy()
        rtcEngine = null
        result.success(null)
      }
      "joinChannel" -> {
        val token = call.argument<String>("token")!!
        val channelName = call.argument<String>("channelName")!!
        val uid = call.argument<Int>("uid") ?: 0
        rtcEngine?.joinChannel(token, channelName, "", uid)
        result.success(null)
      }
      "leaveChannel" -> {
        rtcEngine?.leaveChannel()
        result.success(null)
      }
      "enableAudioVolumeIndication" -> {
        val interval = call.argument<Int>("interval") ?: 200
        val smooth = call.argument<Int>("smooth") ?: 3
        val reportVAD = call.argument<Boolean>("reportVad") ?: false
        rtcEngine?.enableAudioVolumeIndication(interval, smooth, reportVAD)
        result.success(null)
      }
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      else -> result.notImplemented()
    }
  }

  private fun initializeAgora(appId: String, areaCode: String) {
    val config = RtcEngineConfig()
    config.mContext = context
    config.mAppId = appId
    config.mEventHandler = object : IRtcEngineEventHandler() {
      override fun onUserJoined(uid: Int, elapsed: Int) {
        eventSink?.success(mapOf("event" to "onUserJoined", "uid" to uid))
      }

      override fun onUserOffline(uid: Int, reason: Int) {
        eventSink?.success(mapOf("event" to "onUserOffline", "uid" to uid))
      }

      override fun onAudioVolumeIndication(speakers: Array<out AudioVolumeInfo>?, totalVolume: Int) {
        val speakerList = speakers?.map {
          mapOf("uid" to it.uid, "volume" to it.volume)
        }
        eventSink?.success(mapOf(
          "event" to "onAudioVolumeIndication",
          "speakers" to speakerList,
          "totalVolume" to totalVolume
        ))
      }
    }
    config.mAreaCode = if (areaCode.isNotEmpty()) areaCode.toInt() else RtcEngineConfig.AREA_CODE_GLOB
    rtcEngine = RtcEngine.create(config)
  }

  // EventChannel handlers
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }
}