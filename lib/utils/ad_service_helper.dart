import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:mexa_ads/native_ad_widget.dart';
import 'package:mexa_ads/utils.dart';
import 'package:read_the_label/gen/assets.gen.dart';
import 'package:read_the_label/main.dart';
import 'package:read_the_label/models/id_ads_model.dart';
import 'package:read_the_label/theme/app_colors.dart';

import '../core/constants/constans.dart';

class AdServiceHelper {
  AdServiceHelper._();

  static AdServiceHelper? _instance;

  static AdServiceHelper get instance => _instance ??= AdServiceHelper._();

  final String debugInterId = "ca-app-pub-3940256099942544/1033173712";
  final String debugNativeId = "/6499/example/native";
  final String debugAOAId = "ca-app-pub-3940256099942544/9257395921";
  final String debugBannerId = "ca-app-pub-3940256099942544/6300978111";
  final String debugRewardId = "ca-app-pub-3940256099942544/5224354917";
  bool rewardLoadingToIAPScreen = false;
  Future<void> initializeAdService(
      {required Function(bool success) onAdInitialized}) async {
    try {
      MexaAds.instance.initialize(
          adjustkey: "8y9bqzsymebk",
          value: AdConstant(
            adjustRevenueEventKey: "",
            interstitialId: {
              AdPlacement.interSplash: kDebugMode
                  ? [debugInterId]
                  : [AdsConfig.getIdAd(AdPlacement.interSplash)],
              AdPlacement.interScanDone: kDebugMode
                  ? [debugInterId]
                  : [AdsConfig.getIdAd(AdPlacement.interScanDone)],
              AdPlacement.interBack: kDebugMode
                  ? [debugInterId]
                  : [AdsConfig.getIdAd(AdPlacement.interBack)],
            },
            nativeId: {
              AdPlacement.nativeLanguage1_1: kDebugMode
                  ? debugNativeId
                  : AdsConfig.getIdAd(AdPlacement.nativeLanguage1_1),
              AdPlacement.nativeLanguage1_2: kDebugMode
                  ? debugNativeId
                  : AdsConfig.getIdAd(AdPlacement.nativeLanguage1_2),
              AdPlacement.nativeOnboardingFullscreen1_1: kDebugMode
                  ? debugNativeId
                  : AdsConfig.getIdAd(
                      AdPlacement.nativeOnboardingFullscreen1_1),
              AdPlacement.nativeOnboardingFullscreen1_2: kDebugMode
                  ? debugNativeId
                  : AdsConfig.getIdAd(
                      AdPlacement.nativeOnboardingFullscreen1_2),
              AdPlacement.nativeUserInfo: kDebugMode
                  ? debugNativeId
                  : AdsConfig.getIdAd(AdPlacement.nativeUserInfo),
              AdPlacement.nativeHomeDaily: kDebugMode
                  ? debugNativeId
                  : AdsConfig.getIdAd(AdPlacement.nativeHomeDaily),
              AdPlacement.nativeResult: kDebugMode
                  ? debugNativeId
                  : AdsConfig.getIdAd(AdPlacement.nativeResult),
            },
            appOpenId: {
              AdPlacement.openResume: kDebugMode
                  ? debugAOAId
                  : AdsConfig.getIdAd(AdPlacement.openResume),
            },
            bannerAnchorId: {
              AdPlacement.bannerSplash: kDebugMode
                  ? debugBannerId
                  : AdsConfig.getIdAd(AdPlacement.bannerSplash),
              AdPlacement.bannerHome: kDebugMode
                  ? debugBannerId
                  : AdsConfig.getIdAd(AdPlacement.bannerHome),
            },
            rewardedAdId: {},
          ));

      onAdInitialized.call(true);
      MexaAds.instance
        ..primaryColor = AppColors.primary
        ..nativeBackgroundColor = Colors.white
        ..nativeTitleStyle = const TextStyle(fontSize: 14, color: Colors.black)
        ..nativeBodyStyle = const TextStyle(fontSize: 12, color: Colors.grey)
        ..nativeCTABackgroundColor = [AppColors.primary]
        ..nativeCTATitleStyle = const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);

      // MexaAds.instance.setAdRevenuePaidedListener((AdRevenuePaidParams params) {
      //   AnalysticHelper.instance.logAdmobAdImpressionEvent(params);

      //   MexaAds.instance.setAdClickedListener(
      //     (AdClickedParams params) {
      //       AnalysticHelper.instance.logAdmobAdClickedEvent(params);
      //     },
      //   );
      // });
    } catch (e) {
      onAdInitialized.call(false);
      log('error at Admob initialization: $e');
    }
  }
}

class MexaNativeAd extends StatefulWidget {
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdFailedToLoad;
  final VoidCallback? onAdClicked;
  final VoidCallback? onAdClosed;
  final VoidCallback? onAdRev;
  final NativeAdSize layout;
  final String placement;
  final double? adHeight;
  final EdgeInsets? margin;
  final ButtonStyle? buttonStyle;
  final bool? isReloadAutomaticallyWhenVisibilityChanged;
  final Color? adBackgrounColor;
  final Color? adBannerColor;
  final Color? adBodyTextColor;
  final List<Color>? adCTABackgroundColor;
  final Color? adCTATextColor;
  final Color? adTitleTextColor;
  final GradientOrientation? gradientOrientation;
  final int borderRadius;

  const MexaNativeAd(
      {super.key,
      this.onAdLoaded,
      this.onAdFailedToLoad,
      this.onAdClicked,
      this.onAdClosed,
      required this.placement,
      this.adHeight,
      this.margin,
      this.layout = NativeAdSize.layout1,
      this.buttonStyle,
      this.onAdRev,
      this.isReloadAutomaticallyWhenVisibilityChanged,
      this.adBackgrounColor,
      this.adBannerColor,
      this.adBodyTextColor,
      this.adCTABackgroundColor,
      this.adCTATextColor,
      this.adTitleTextColor,
      this.gradientOrientation,
      this.borderRadius = 30});

  @override
  State<MexaNativeAd> createState() => _MexaNativeAdState();
}

class _MexaNativeAdState extends State<MexaNativeAd> {
  bool isLoadAds = true;
  @override
  Widget build(BuildContext context) {
    if (MexaAds.instance.isAdDisable) {
      return const SizedBox();
    }
    return isLoadAds
        ? Container(
            height: widget.adHeight,
            margin: widget.margin,
            child: NativeAdWidget(
              size: widget.layout,
              adHeight: widget.adHeight,
              adBackgrounColor: widget.adBackgrounColor,
              adBannerColor: widget.adBannerColor,
              adBodyTextColor: widget.adBodyTextColor,
              adCTABackgroundColor: widget.adCTABackgroundColor,
              adCTATextColor: widget.adCTATextColor,
              adTitleTextColor: widget.adTitleTextColor,
              gradientOrientation: widget.gradientOrientation,
              placement: widget.placement,
              borderRadius: widget.borderRadius,
              onAdClicked: () => widget.onAdClicked?.call(),
              onAdLoaded: () => widget.onAdLoaded?.call(),
              onAdFailedToLoad: () {
                widget.onAdFailedToLoad?.call();
                setState(() {
                  isLoadAds = false;
                });
              },
            ),
          )
        : const SizedBox();
  }
}

Future<void> showInterAds(
    {required String placement,
    required Function() function,
    bool showLoading = true,
    bool forceShow = false,
    bool callFunctionWhenDismiss = false,
    bool autoReloadAfterShow = true,
    Function()? onAdDismiss}) async {
  BuildContext? context = navKey.currentContext;
  if (context == null || !context.mounted) {
    function();
    return;
  }
  if (AdsConfig.getStatusAds(placement)) {
    try {
      MexaAds.instance.loadAndShowInterAd(
        context: navKey.currentContext!,
        placement: placement,
        reloadAfterShow: autoReloadAfterShow,
        showLoading: showLoading,
        customLoadingOverlay: AdsLoadingOverlay(),
        forceShow: forceShow,
        onAdLoaded: () => log("loaded ads inter"),
        onAdDisplay: () async {
          // getIt.get<CommonCubit>().disableAOA = true;
          if (!callFunctionWhenDismiss) {
            await Future.delayed(const Duration(milliseconds: 300));
            function();
          }
        },
        onAdDismissedFullScreenContent: () async {
          onAdDismiss?.call();
          if (callFunctionWhenDismiss) {
            await Future.delayed(const Duration(milliseconds: 100));
            function();
          }
        },
        onAdFailedToShow: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          function();
        },
        onShowInOffsetTime: () async {
          await Future.delayed(const Duration(milliseconds: 100));
          function();
        },
      );
      // if (!forceShow &&
      //         MexaAds.instance.lastestTimeShowInterstitialAd
      //                 .add(MexaAds.instance.adConstant.interstitialOffsetTime)
      //                 .compareTo(DateTime.now()) >
      //             0 ||
      //     MexaAds.instance.isAdDisable) {
      //   function();
      //   return;
      // }
      // if (showLoading && context.mounted) {
      //   Navigator.of(context).push(AdsLoadingOverlay());
      // }
      // await MexaAds.instance.loadInterAd(
      //   placement: placement,
      //   onAdLoaded: () {},
      //   onAdFailToLoad: () {},
      // );
      // if (showLoading && context.mounted) {
      //   await Future.delayed(const Duration(seconds: 2));
      //   if (!context.mounted) return;
      //   if (Navigator.canPop(context)) {
      //     Navigator.of(context).pop();
      //   }
      // }
      // if (!context.mounted) return;
      // MexaAds.instance.showInterAd(
      //   placement: placement,
      //   onAdClicked: () {},
      //   onAdDisplay: () async {
      //     getIt.get<CommonCubit>().disableAOA = true;
      //   },
      //   onAdDismissedFullScreenContent: () async {
      //     if (callFunctionWhenDismiss) {
      //       await Future.delayed(const Duration(milliseconds: 100));
      //       function();
      //     }
      //   },
      //   onAdFailedToShow: () async {},
      //   reloadAfterShow: true,
      //   forceShow: forceShow,
      //   onShowInOffsetTime: () async {},
      // );
      // if (!callFunctionWhenDismiss) {
      //   await Future.delayed(const Duration(milliseconds: 1000));
      //   function();
      // }
    } catch (e) {
      log(e.toString());
    }
  } else {
    function();
  }
}

void showRewardAds({
  required String placement,
  required Function() function,
}) async {
  if (navKey.currentContext == null || !navKey.currentContext!.mounted) {
    function();
    return;
  }
  if (AdsConfig.getStatusAds(placement) && !MexaAds.instance.isAdDisable) {
    try {
      Navigator.push(navKey.currentContext!, AdsLoadingOverlay());
      await MexaAds.instance.loadRewardAd(
        placement: placement,
        onAdFailToLoad: () {
          MexaAds.instance.loadRewardAd(placement: placement);
        },
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(navKey.currentContext!);
      MexaAds.instance.showRewardAd(
        placement: placement,
        reloadAfterShow: true,
        onAdDisplay: () {
          // getIt.get<CommonCubit>().disableAOA = true;
        },
        onAdDismissedFullScreenContent: () async {
          await Future.delayed(const Duration(milliseconds: 200));
          function();
          MexaAds.instance.loadRewardAd(placement: placement);
        },
        onAdFailedToShow: () async {
          await Future.delayed(const Duration(milliseconds: 200));
          function();
        },
      );
    } catch (e) {
      log(e.toString());
    }
  } else {
    function();
  }
}

class AdsLoadingOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {},
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 160,
                height: 160,
                child: Lottie.asset(Assets.animations.animLoading.path)),
            const Text("Ad Loading ...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
