import 'dart:developer';

import 'package:mexa_ads/mexa_ads.dart';
import 'button.dart';
import 'package:flutter/material.dart';

class AppOpenAdScreen extends StatelessWidget {
  const AppOpenAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryButton(
        onPressed: () async {
          MexaAds.instance.loadAndShowAppOpenAd(
              context: context,
              placement: "app_open_1",
              onAdLoaded: () {
                log("App Open: onAdLoaded");
              },
              onAdFailToLoad: () {
                log("App Open: onAdFailToLoad");
              },
              onAdClicked: () {
                log("App Open: onAdClicked");
              },
              onAdDisplay: () {
                log("App Open: onAdDisplay");
              },
              onAdDismissedFullScreenContent: () {
                log("App Open: onAdDismissedFullScreenContent");
              },
              onAdFailedToShow: () {
                log("App Open: onAdFailedToShow");
              },
              showLoading: true,
              reloadAfterShow: true,
              forceShow: false,
              customLoadingOverlay: CustomLoadingOverlay());
        },
        label: 'Show App Open Ad',
      ),
    );
  }
}

class CustomLoadingOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.7);

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
          child:
              MexaAds.instance.loadingAdWidget ?? _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Loading Ad...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
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
