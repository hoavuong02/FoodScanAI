package com.mexa.mexa_ads

import android.content.Context
import android.content.res.Resources
import android.view.LayoutInflater
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

/** MexaAdsPlugin */
class MexaAdsPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    companion object {
        lateinit var resources: Resources
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mexa_ads")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
        resources = flutterPluginBinding.applicationContext.resources

        flutterPluginBinding.flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeLayout1Factory",
            NativeLayout1Factory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeLayout2Factory",
            NativeLayout2Factory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeLayout3Factory",
            NativeLayout3Factory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeLayout4Factory",
            NativeLayout4Factory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeAdFullScreenFactory",
            NativeAdFullScreenFactory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeAdNoMediaFactory",
            NativeAdNoMediaFactory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeAdNoMedia2Factory",
            NativeAdNoMedia2Factory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeLayout1CTATopFactory",
            NativeLayout1CTATopFactory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterPluginBinding.flutterEngine,
            "nativeAdNoMediaCTATopFactory",
            NativeAdNoMediaCTATopFactory(LayoutInflater.from(flutterPluginBinding.applicationContext))
        )
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
