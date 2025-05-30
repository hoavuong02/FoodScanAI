package com.mexa.mexa_ads_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // config native collapsible ad view
//        flutterEngine
//            .platformViewsController
//            .registry
//            .registerViewFactory("admob_collapsible_ads",
//                CollapsibleAdsViewFactory()
//            )

//        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
//        GoogleMobileAdsPlugin.registerNativeAdFactory(
//            flutterEngine,
//            "nativeAdFactory",
//            NativeAdFactory(layoutInflater))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
//        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "nativeAdFactory")
    }
}
