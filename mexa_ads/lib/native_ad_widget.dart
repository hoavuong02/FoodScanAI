import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:mexa_ads/utils.dart';
import 'package:mexa_ads/widget/native_layout_shimmer.dart';

/// This example demonstrates inline ads in a list view, where the ad objects
/// live for the lifetime of this widget.
class NativeAdWidget extends StatefulWidget {
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdFailedToLoad;
  final VoidCallback? onAdClicked;
  final VoidCallback? onAdClosed;
  final NativeAdSize size;
  final String placement;
  final bool showCloseButton;
  final double? adHeight;
  final Color? adBannerColor;
  final Color? adBackgrounColor;
  final List<Color>? adCTABackgroundColor;
  final Color? adCTATextColor;
  final Color? adTitleTextColor;
  final Color? adBodyTextColor;
  final GradientOrientation? gradientOrientation;
  //chỉ nhận các giá trị 12, 16, 20, 24, 248, 30
  final int? borderRadius;

  final Function(
    Ad ad,
    double valueMicros,
    PrecisionType precision,
    String currencyCode,
    AdType adType,
  )? onRevenuePaid;

  const NativeAdWidget({
    super.key,
    required this.placement,
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.size = NativeAdSize.layout1,
    this.onAdClicked,
    this.onAdClosed,
    this.onRevenuePaid,
    this.adBannerColor,
    this.showCloseButton = true,
    this.adHeight,
    this.adBackgrounColor,
    this.adCTABackgroundColor,
    this.adCTATextColor,
    this.adTitleTextColor,
    this.adBodyTextColor,
    this.gradientOrientation,
    this.borderRadius,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  LoadAdError? error;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.size == NativeAdSize.fullScreen ? false : true,
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    if (error != null || MexaAds.instance.isAdDisable) {
      return _buildErrorWidget();
    }

    if (_nativeAdIsLoaded && _nativeAd != null) {
      return SizedBox(
        height: _calculateAdHeight(),
        child: _buildAdWidget(context),
      );
    }

    return _buildShimmerWidget();
  }

  Widget _buildErrorWidget() {
    return kDebugMode
        ? Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            color: Colors.white,
            child: Text("Debug mode:\nNative Ad error: ${error?.message}"),
          )
        : const SizedBox();
  }

  Widget _buildAdWidget(BuildContext context) {
    if (widget.size == NativeAdSize.fullScreen) {
      return Scaffold(
        body: Stack(
          children: [
            AdWidget(ad: _nativeAd!),
            if (widget.showCloseButton) _buildCloseButton(context),
          ],
        ),
      );
    }
    return AdWidget(ad: _nativeAd!);
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: MediaQuery.of(context).padding.top + 16,
      ),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 75, 75, 75),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerWidget() {
    switch (widget.size) {
      case NativeAdSize.fullScreen:
        return const FullScreenNativeAdShimmer();
      case NativeAdSize.layout1:
      case NativeAdSize.layout1CTATop:
        return const NativeLayout1Shimmer();
      case NativeAdSize.layout2:
        return const NativeLayout2Shimmer();
      case NativeAdSize.layout3:
        return const NativeLayout3Shimmer();
      case NativeAdSize.layout4:
        return const NativeLayout4Shimmer();
      case NativeAdSize.noMedia:
        return const NoMediaNativeAdShimmer();
      case NativeAdSize.noMedia2:
      case NativeAdSize.noMediaCTATop:
        return const NoMedia2NativeAdShimmer();
    }
  }

  double _calculateAdHeight() {
    if (widget.adHeight != null) return widget.adHeight!;

    final adConstant = MexaAds.instance.adConstant;
    switch (widget.size) {
      case NativeAdSize.layout1:
      case NativeAdSize.layout1CTATop:
        return adConstant.nativeAdHeightLayout1;
      case NativeAdSize.layout2:
        return adConstant.nativeAdHeightLayout2;
      case NativeAdSize.layout3:
        return adConstant.nativeAdHeightLayout3;
      case NativeAdSize.layout4:
        return adConstant.nativeAdHeightLayout4;
      case NativeAdSize.noMedia:
        return adConstant.nativeAdHeightLayoutNoMedia;
      case NativeAdSize.noMedia2:
      case NativeAdSize.noMediaCTATop:
        return adConstant.nativeAdHeightLayoutNoMedia2;
      default:
        return 80;
    }
  }

  void _loadAd() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _nativeAd = NativeAd(
      adUnitId: MexaAds.instance.adConstant.nativeId[widget.placement] ?? '',
      request: const AdRequest(),
      nativeAdOptions: _getNativeAdOptions(),
      customOptions: _buildCustomOptions(),
      factoryId: _getFactoryId(),
      listener: _createAdListener(),
    )..load();
  }

  NativeAdOptions? _getNativeAdOptions() {
    return widget.size == NativeAdSize.fullScreen
        ? NativeAdOptions(adChoicesPlacement: AdChoicesPlacement.topRightCorner)
        : null;
  }

  String _getFactoryId() {
    switch (widget.size) {
      case NativeAdSize.layout1:
        return 'nativeLayout1Factory';
      case NativeAdSize.layout2:
        return 'nativeLayout2Factory';
      case NativeAdSize.layout3:
        return 'nativeLayout3Factory';
      case NativeAdSize.layout4:
        return 'nativeLayout4Factory';
      case NativeAdSize.noMedia:
        return 'nativeAdNoMediaFactory';
      case NativeAdSize.noMedia2:
        return 'nativeAdNoMedia2Factory';
      case NativeAdSize.layout1CTATop:
        return 'nativeLayout1TopCTAFactory';
      case NativeAdSize.fullScreen:
        return 'nativeAdFullScreenFactory';
      case NativeAdSize.noMediaCTATop:
        return 'nativeAdNoMediaCTATopFactory';
    }
  }

  Map<String, Object> _buildCustomOptions() {
    final options = {
      'bg_color': colorToHexString(
          widget.adBackgrounColor ?? MexaAds.instance.nativeBackgroundColor),
      'cta_bg_color': convertColorsToHex(widget.adCTABackgroundColor ??
          MexaAds.instance.nativeCTABackgroundColor),
      'cta_text_color': colorToHexString(
          widget.adCTATextColor ?? MexaAds.instance.nativeCTATitleStyle?.color),
      'title_text_color': colorToHexString(
          widget.adTitleTextColor ?? MexaAds.instance.nativeTitleStyle?.color),
      'body_text_color': colorToHexString(
          widget.adBodyTextColor ?? MexaAds.instance.nativeBodyStyle?.color),
      'ad_height': widget.adHeight?.toInt() ?? _calculateAdHeight().toInt(),
      'ad_banner_color': colorToHexString(
          widget.adBannerColor ?? MexaAds.instance.primaryColor),
      'gradient_orientation': gradientOrientationToString(
          widget.gradientOrientation ?? GradientOrientation.leftToRight),
      'cta_border_radius': widget.borderRadius ?? 12,
    };

    return options
      ..removeWhere((key, value) => value is String && value.isEmpty);
  }

  NativeAdListener _createAdListener() {
    return NativeAdListener(
      onAdLoaded: (Ad ad) {
        setState(() {
          _nativeAdIsLoaded = true;
          error = null;
        });
        widget.onAdLoaded?.call();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        setState(() {
          _nativeAdIsLoaded = false;
          this.error = error;
        });
        widget.onAdFailedToLoad?.call();
      },
      onAdClicked: (ad) {
        widget.onAdClicked?.call();
      },
      onAdClosed: (ad) {
        widget.onAdClosed?.call();
      },
      onPaidEvent: (ad, valueMicros, precision, currencyCode) {
        logger(
            '.............. NativeAd onPaidEvent ${'$valueMicros $precision'}');
        widget.onRevenuePaid
            ?.call(ad, valueMicros, precision, currencyCode, AdType.native);

        final params = AdRevenuePaidParams(
          networkName:
              ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName ?? '',
          revenue: valueMicros / 1000000.0,
          adUnitId: ad.adUnitId,
          adType: AdType.native.value,
          placement: widget.placement,
          country: currencyCode,
        );

        MexaAds.instance.logAdjustRevenueEvent(params);
        MexaAds.instance.adRevenuePaidListener?.call(params);
      },
    );
  }

  @override
  void initState() {
    initNativeAd();
    super.initState();
  }

  void initNativeAd() async {
    if (MexaAds.instance.isAdDisable) return;
    NativeAdManager manager = MexaAds.instance.nativeAdManager;

    // Kiểm tra nếu completer tồn tại và chưa hoàn thành
    if (manager.loadingNativeCompleters[widget.placement] != null) {
      Completer<void>? completer =
          manager.loadingNativeCompleters[widget.placement];

      if (completer?.isCompleted == false) {
        logger("Native: Chờ cho việc tải hoàn thành");
        // Chờ cho việc tải hoàn thành
        completer?.future.then((_) async {
          await Future.delayed(const Duration(milliseconds: 100));

          if (mounted) {
            setState(() {
              // Quảng cáo đã tải xong, cập nhật trạng thái hiển thị
              _nativeAdIsLoaded = true;
              _nativeAd = manager.nativeAds[widget.placement];
            });
          }
          manager.nativeAds.remove(widget.placement);
          manager.loadingNativeCompleters.remove(widget.placement);
          await Future.delayed(const Duration(milliseconds: 700));
          if (mounted) {
            setState(() {});
          }
        }).catchError((error) async {
          await Future.delayed(const Duration(milliseconds: 100));
          logger("Native: Xử lý lỗi khi tải quảng cáo");

          // Xử lý lỗi khi tải quảng cáo
          if (mounted) {
            setState(() {
              this.error = LoadAdError(
                  1,
                  "",
                  "",
                  const ResponseInfo(
                    responseExtras: {},
                  ));
            });
          }
          print("Error while loading ad: $error");
        });
      } else {
        logger("Native: Nếu đã hoàn thành, cập nhật trạng thái hiển thị ngay");

        await Future.delayed(const Duration(milliseconds: 100));
        // Nếu đã hoàn thành, cập nhật trạng thái hiển thị ngay
        if (mounted) {
          setState(() {
            _nativeAdIsLoaded = true;
            _nativeAd = manager.nativeAds[widget.placement];
          });
        }
        manager.nativeAds.remove(widget.placement);
        manager.loadingNativeCompleters.remove(widget.placement);
        await Future.delayed(const Duration(milliseconds: 700));
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      // Nếu không có completer, bắt đầu tải quảng cáo
      _loadAd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }
}
