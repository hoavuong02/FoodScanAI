import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mexa_ads/banner_ad_manager.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:mexa_ads/utils.dart';
import 'package:mexa_ads/widget/container_shimmer.dart';
import 'package:mexa_ads/widget/primary_shimmer.dart';

class BannerAnchorAdWidget extends StatefulWidget {
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdFailedToLoad;
  final VoidCallback? onAdClicked;
  final VoidCallback? onAdClosed;
  final String placement;
  final bool isBottom;

  const BannerAnchorAdWidget({
    super.key,
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdClicked,
    this.onAdClosed,
    required this.placement,
    this.isBottom = true,
  });

  @override
  State<BannerAnchorAdWidget> createState() => _BannerAnchorAdWidgetState();
}

class _BannerAnchorAdWidgetState extends State<BannerAnchorAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  void _initBannerAd() async {
    if (MexaAds.instance.isAdDisable) return;

    BannerAdManager manager = MexaAds.instance.bannerAdManager;

    if (manager.loadingBannerCompleters[widget.placement] != null) {
      Completer<void>? completer =
          manager.loadingBannerCompleters[widget.placement];

      if (completer?.isCompleted == false) {
        logger("Banner: Waiting for preload to complete");
        completer?.future.then((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _bannerAd = manager.bannerAds[widget.placement];
            });
          }
          manager.bannerAds.remove(widget.placement);
          manager.loadingBannerCompleters.remove(widget.placement);
        }).catchError((error) async {
          await Future.delayed(const Duration(milliseconds: 100));
          logger("Banner: Error handling preloaded ad");
          if (mounted) {
            _loadAd();
          }
        });
      } else {
        logger("Banner: Preload completed, updating state");
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          setState(() {
            _isLoaded = true;
            _bannerAd = manager.bannerAds[widget.placement];
          });
        }
        manager.bannerAds.remove(widget.placement);
        manager.loadingBannerCompleters.remove(widget.placement);
      }
    } else {
      _loadAd();
    }
  }

  void _loadAd() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      logger('Unable to get banner ad size');
      return;
    }

    BannerAd(
      adUnitId:
          MexaAds.instance.adConstant.bannerAnchorId[widget.placement] ?? '',
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
          widget.onAdLoaded?.call();
        },
        onAdFailedToLoad: (ad, err) {
          logger('Banner ad failed to load: $err');
          ad.dispose();
          widget.onAdFailedToLoad?.call();
        },
        onAdClicked: (ad) {
          widget.onAdClicked?.call();
        },
        onAdClosed: (ad) {
          widget.onAdClosed?.call();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MexaAds.instance.isAdDisable) {
      return const SizedBox();
    }

    if (_bannerAd != null && _isLoaded) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    return const BannerAdShimmer();
  }
}

class BannerAdShimmer extends StatelessWidget {
  const BannerAdShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey[50],
      padding: const EdgeInsets.all(8),
      child: const PrimaryShimmer(
        child: Row(
          children: [
            Text(
              'Ad',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
            SizedBox(width: 8),
            ContainerShimmer(
              height: 34,
              width: 34,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContainerShimmer(
                    width: 200,
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
