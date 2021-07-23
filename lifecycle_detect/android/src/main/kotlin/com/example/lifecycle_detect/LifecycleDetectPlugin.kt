package com.example.lifecycle_detect

import android.app.Activity
import android.app.Application
import android.os.Bundle
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** LifecycleDetectPlugin */
class LifecycleDetectPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "lifecycle_detect")
    channel.setMethodCallHandler(this)
    val applicationContext = flutterPluginBinding.applicationContext as Application
    applicationContext.registerActivityLifecycleCallbacks(object : Application.ActivityLifecycleCallbacks {
      override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {

      }

      override fun onActivityStarted(activity: Activity) {
      }

      override fun onActivityResumed(activity: Activity) {
        channel.invokeMethod("onActivityResumed", mapOf("activityName" to activity.javaClass.simpleName))
      }

      override fun onActivityPaused(activity: Activity) {
        channel.invokeMethod("onActivityPaused", mapOf("activityName" to activity.javaClass.simpleName))
      }

      override fun onActivityStopped(activity: Activity) {
      }

      override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
      }

      override fun onActivityDestroyed(activity: Activity) {
      }
    })
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
