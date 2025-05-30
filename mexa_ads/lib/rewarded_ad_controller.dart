import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mexa_ads/ad_controller.dart';
import 'package:mexa_ads/mexa_ads.dart';

class RewardedAdController implements AdController {
  final _request = const AdRequest();
  RewardedAd? _rewardedAd;
  Completer<void>? _loadingCompleter;
  int _numLoadAttempts = 0;
  static const int maxLoadAttempts = 3;

  late String _adId;
  void setAdId(String id) {
    _adId = id;
  }

  late String _adPlacement;
  void setAdPlacement(String placement) {
    _adPlacement = placement;
  }

  @override
  Future<bool> loadAd(
      {VoidCallback? onAdLoaded, VoidCallback? onAdFailedToLoad}) async {
    // Nếu đang load, đợi quá trình load hoàn tất
    if (_loadingCompleter != null && _loadingCompleter?.isCompleted == false) {
      log("Đang load quảng cáo, chờ hoàn tất");
      try {
        await _loadingCompleter?.future;
        return true; // Load thành công
      } catch (e) {
        onAdFailedToLoad?.call(); // Gọi callback khi thất bại
        return false; // Load thất bại
      }
    }

    // Nếu đã có quảng cáo sẵn sàng, không cần load lại
    if (_rewardedAd != null) {
      log("Quảng cáo đã sẵn sàng, không cần load lại");
      return true;
    }

    // Khởi tạo quá trình load quảng cáo
    _loadingCompleter = Completer<void>();
    _numLoadAttempts = 0;
    Timer timeoutTimer = Timer(MexaAds.instance.adConstant.timeoutLoadAd, () {
      if (_loadingCompleter?.isCompleted == false) {
        _loadingCompleter?.completeError("Ad load timeout");
        _loadingCompleter = null;
        _rewardedAd = null;
        onAdFailedToLoad?.call();
      }
    });
    log("Không có Completer bắt đầu load");
    // Bắt đầu load quảng cáo
    _loadAdReward(
      onAdLoaded: () {
        _loadingCompleter?.complete();
        _loadingCompleter = null;
        timeoutTimer.cancel();
        onAdLoaded?.call();
      },
      onAdFailedToLoad: () {
        _loadingCompleter?.completeError("Ad load failed");
        _loadingCompleter = null;
        timeoutTimer.cancel();
        onAdFailedToLoad?.call();
      },
    );
    // Chờ quá trình load hoàn tất
    try {
      await _loadingCompleter?.future;
      return true; // Load thành công
    } catch (e) {
      onAdFailedToLoad?.call(); // Gọi callback khi thất bại
      return false; // Load thất bại
    } finally {
      timeoutTimer.cancel();
    }
  }

  void _loadAdReward(
      {VoidCallback? onAdLoaded, VoidCallback? onAdFailedToLoad}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    RewardedAd.load(
      adUnitId: _adId,
      request: _request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _numLoadAttempts = 0;
          _rewardedAd?.setImmersiveMode(true);
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _numLoadAttempts++;
          _rewardedAd = null;

          if (_numLoadAttempts < maxLoadAttempts) {
            _loadAdReward(
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad); // Thử lại
          } else {
            onAdFailedToLoad?.call();
          }
        },
      ),
    );
  }

  @override
  Future<void> showAd({
    BuildContext? context,
    VoidCallback? onAdDismissedFullScreenContent,
    VoidCallback? onAdClicked,
    VoidCallback? onAdDisplay,
    VoidCallback? onAdFailedToShow,
    bool reloadAfterShow = true,
    bool recordLastTimeShowAd = true,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Nếu quảng cáo chưa được load, return luôn
    if (_rewardedAd == null) {
      onAdFailedToShow?.call();
      return;
    }

    // Hiển thị quảng cáo
    _rewardedAd?.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
      final AdRevenuePaidParams adRevenuePaidParams = AdRevenuePaidParams(
        networkName:
            ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName ?? '',
        revenue: valueMicros / 1000000.0,
        adUnitId: ad.adUnitId,
        adType: AdType.interstitial.value,
        placement: _adPlacement,
        country: currencyCode,
      );
      MexaAds.instance.logAdjustRevenueEvent(adRevenuePaidParams);
      MexaAds.instance.adRevenuePaidListener?.call(adRevenuePaidParams);
    };
    _rewardedAd?.fullScreenContentCallback =
        FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (ad) {
        onAdDismissedFullScreenContent?.call();
        ad.dispose();
        _rewardedAd = null; // Reset sau khi hiển thị
        if (reloadAfterShow) {
          loadAd();
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        onAdFailedToShow?.call();
        ad.dispose();
        _rewardedAd = null;
      },
      onAdClicked: (ad) {
        onAdClicked?.call();
        MexaAds.instance.adClickedListener?.call(AdClickedParams(
          networkName:
              ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName ?? '',
          adUnitId: _adId,
          adType: AdType.interstitial.value,
          placement: _adPlacement,
        ));
      },
      onAdImpression: (ad) {
        onAdDisplay?.call();
      },
    );

    _rewardedAd?.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {},
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
