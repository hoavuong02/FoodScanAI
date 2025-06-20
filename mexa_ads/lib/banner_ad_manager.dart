import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:mexa_ads/utils.dart';

class BannerAdManager {
  Map<String, BannerAd?> bannerAds = <String, BannerAd?>{};
  Map<String, Completer<void>?> loadingBannerCompleters =
      <String, Completer<void>?>{};

  Future<bool> preloadBanner({
    required String placement,
    required BuildContext context,
    String? adUnitId,
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
    VoidCallback? onAdClicked,
    VoidCallback? onAdClosed,
    Function(
      Ad ad,
      double valueMicros,
      PrecisionType precision,
      String currencyCode,
      AdType adType,
    )? onRevenuePaid,
  }) async {
    if (MexaAds.instance.isAdDisable) return false;

    final completer = Completer<bool>();
    loadingBannerCompleters[placement] = completer;
    final AnchoredAdaptiveBannerAdSize? adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());
    try {
      final bannerAd = BannerAd(
        adUnitId: adUnitId ??
            MexaAds.instance.adConstant.bannerAnchorId[placement] ??
            '',
        size: adSize!,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            bannerAds[placement] = ad as BannerAd;
            onAdLoaded?.call();
            completer.complete(true);
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            onAdFailedToLoad?.call();
            completer.complete(true);
            logger('Banner ad failed to load: $error');
          },
          onAdClicked: (ad) {
            onAdClicked?.call();
          },
          onAdClosed: (ad) {
            onAdClosed?.call();
          },
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {
            logger('Banner ad onPaidEvent: $valueMicros $precision');
            onRevenuePaid?.call(
                ad, valueMicros, precision, currencyCode, AdType.banner);

            final params = AdRevenuePaidParams(
              networkName:
                  ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName ??
                      '',
              revenue: valueMicros / 1000000.0,
              adUnitId: ad.adUnitId,
              adType: AdType.banner.value,
              placement: placement,
              country: currencyCode,
            );

            MexaAds.instance.logAdjustRevenueEvent(params);
            MexaAds.instance.adRevenuePaidListener?.call(params);
          },
        ),
      );

      bannerAd.load();
      return await completer.future;
    } catch (e) {
      logger('Error loading banner ad: $e');
      loadingBannerCompleters.remove(placement);
      bannerAds.remove(placement);
      completer.complete(false);
      return false;
    }
  }
}
