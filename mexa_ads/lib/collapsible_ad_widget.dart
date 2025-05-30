import 'dart:async';

import 'package:mexa_ads/mexa_ads.dart';
import 'package:mexa_ads/utils.dart';
import 'package:mexa_ads/widget/container_shimmer.dart';
import 'package:mexa_ads/widget/primary_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CollapsibleAdWidget extends StatefulWidget {
  final bool isCollapsOnce;
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdImpression;
  final VoidCallback? onAdOpened;
  final VoidCallback? onAdFailedToLoad;
  final VoidCallback? onAdClicked;
  final VoidCallback? onAdClosed;
  //If value is -1: Use google admob console auto reload
  //Else (ad id auto reload must be disable in console): Reload after reloadTimeInSeconds seconds
  final int reloadTimeInSeconds;
  final String placement;
  final bool isBottom;
  final int maxReloadAttempts;
  const CollapsibleAdWidget(
      {super.key,
      this.isCollapsOnce = true,
      this.onAdLoaded,
      this.onAdFailedToLoad,
      this.onAdClicked,
      this.onAdOpened,
      this.onAdClosed,
      this.onAdImpression,
      this.reloadTimeInSeconds = -1,
      required this.placement,
      this.isBottom = true,
      this.maxReloadAttempts = 3});

  @override
  State<CollapsibleAdWidget> createState() => _CollapsibleAdWidgetState();
}

class _CollapsibleAdWidgetState extends State<CollapsibleAdWidget> {
  BannerAd? _bannerAd;
  bool? _isLoaded;
  int bottomAdHeight = 80;
  Timer? _reloadAdTimer;
  bool _isVisible = false;
  AdRequest? _adRequest;
  int _reloadAttempts = 0; // Thêm biến đếm số lần load thất bại

  BannerAdListener? _bannerAdListener;
  @override
  void initState() {
    super.initState();
    Map<String, String>? extras = {
      "collapsible": widget.isBottom ? "bottom" : "top",
    };
    if (widget.isCollapsOnce) {
      extras["collapsible_request_id"] = const Uuid().v4();
    }
    _adRequest = AdRequest(extras: extras);
    _bannerAdListener = BannerAdListener(
      onAdLoaded: (ad) async {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _bannerAd = ad as BannerAd;
          _isLoaded = true;
        });
        widget.onAdLoaded?.call();
      },
      onAdFailedToLoad: (ad, err) {
        _reloadAttempts++; // Tăng biến đếm khi load thất bại
        if (_reloadAttempts <= widget.maxReloadAttempts) {
          logger("Ad load failed. Attempting reload #$_reloadAttempts");
          Future.delayed(Duration(seconds: _reloadAttempts * 2), () {
            _loadAd();
          });
        } else {
          ad.dispose();
          widget.onAdFailedToLoad?.call();
          setState(() {
            _isLoaded = false;
          });
          logger(
              "Ad failed to load after $_reloadAttempts attempts. No more retries.");
        }
      },
      onAdOpened: (Ad ad) {
        widget.onAdOpened?.call();
      },
      onAdClosed: (Ad ad) {
        widget.onAdClosed?.call();
      },
      onAdImpression: (Ad ad) {
        widget.onAdImpression?.call();
        logger("onAdImpression");
      },
      onAdClicked: (ad) {
        widget.onAdClicked?.call();
        MexaAds.instance.adClickedListener?.call(AdClickedParams(
          networkName:
              ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName ?? '',
          adUnitId: ad.adUnitId,
          adType: AdType.bannerCollapsible.value,
          placement: widget.placement,
        ));
      },
      onPaidEvent: (ad, valueMicros, precision, currencyCode) {
        final AdRevenuePaidParams adRevenuePaidParams = AdRevenuePaidParams(
          networkName:
              ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName ?? '',
          revenue: valueMicros / 1000000.0,
          adUnitId: ad.adUnitId,
          adType: AdType.bannerCollapsible.value,
          placement: widget.placement,
          country: currencyCode,
        );
        MexaAds.instance.logAdjustRevenueEvent(adRevenuePaidParams);
        MexaAds.instance.adRevenuePaidListener?.call(adRevenuePaidParams);
      },
    );
  }

  void _startAdReloadTimer() {
    _reloadAdTimer?.cancel(); // Hủy Timer cũ nếu đang chạy
    if (widget.reloadTimeInSeconds == -1) {
      return;
    }
    _reloadAdTimer = Timer.periodic(
      Duration(seconds: widget.reloadTimeInSeconds),
      (timer) {
        if (_isVisible) {
          logger("reload ad collap");
          _loadAd();
        }
      },
    );
  }

  void _stopAdReloadTimer() {
    _bannerAd?.dispose();
    _reloadAdTimer?.cancel(); // Dừng Timer khi không visible
    _reloadAdTimer = null;
    logger("Ad reload timer stopped.");
  }

  @override
  void dispose() {
    // Hủy Timer khi widget bị dispose
    _stopAdReloadTimer();
    _bannerAdListener = null;
    _adRequest = null;
    super.dispose();
  }

  void _loadAd() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      if (MexaAds.instance.isAdDisable || !mounted) {
        return;
      }
      _bannerAd?.dispose();
      // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
      final size =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              MediaQuery.sizeOf(context).width.truncate());

      bottomAdHeight = size?.height ?? 50;

      if (size == null) {
        // Unable to get width of anchored banner.
        return;
      }

      BannerAd(
        adUnitId: kDebugMode
            ? 'ca-app-pub-3940256099942544/2014213617'
            : MexaAds.instance.adConstant
                    .bannerCollapsibleId[widget.placement] ??
                "",
        request: _adRequest ?? const AdRequest(),
        size: size,
        listener: _bannerAdListener ?? const BannerAdListener(),
      ).load();
    } on Exception catch (e) {
      logger(e.toString());
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0.0 && _isVisible) {
      _isVisible = false;
      _stopAdReloadTimer(); // Dừng Timer khi không còn visible
    } else if (info.visibleFraction > 0.0 && !_isVisible) {
      _isVisible = true;
      _loadAd(); // Gọi hàm loadAd khi visible trở lại
      if (_reloadAdTimer == null && widget.reloadTimeInSeconds != 0) {
        _startAdReloadTimer(); // Khởi động lại Timer nếu nó đang dừng
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MexaAds.instance.isAdDisable
        ? const SizedBox()
        : VisibilityDetector(
            key: Key('collapsible-key-${widget.placement}'),
            onVisibilityChanged: _onVisibilityChanged,
            child: (_bannerAd != null && _isLoaded == true)
                ? SizedBox(
                    key: ValueKey(_bannerAd!.hashCode),
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  )
                : _isLoaded == null
                    ? BannerAdShimmer(bottomAdHeight: bottomAdHeight)
                    : const SizedBox(),
          );
  }
}

class BannerAdShimmer extends StatelessWidget {
  const BannerAdShimmer({
    super.key,
    required this.bottomAdHeight,
  });

  final int bottomAdHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bottomAdHeight.toDouble(),
      color: Colors.grey[50],
      padding: const EdgeInsets.all(8),
      child: Scaffold(
        body: PrimaryShimmer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ad',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ),
              const SizedBox(
                width: 8,
              ),
              ContainerShimmer(
                height: bottomAdHeight.toDouble() - 16,
                width: bottomAdHeight.toDouble() - 16,
              ),
              const SizedBox(
                width: 8,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerShimmer(
                      width: 200,
                      height: 20,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ContainerShimmer(
                      width: 240,
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
