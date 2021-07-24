package com.x3800.flutter.plugin_001

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** Plugin001Plugin */
class Plugin001Plugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  // channel 을 flutter 와 연결한다.
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugin_001")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      // 원래는 call.method 에서 getPlatformVersion이 오면 result로 systemVersion을 넘겨줘야하는데
      // 생성되는 예제에서는 handle 메소드가 불리면 바로 넘겨주고 있다.
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "getBmclabVersion") {
      // BMCLAB 상태 확인
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "getStatus") {
      // 상태 확인
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  // channel 을 flutter 와 해제한다.
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
