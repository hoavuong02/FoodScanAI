import 'package:flutter/material.dart';

abstract class AdController {
  Future<bool> loadAd({
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
  });

  Future<void> showAd(
      {BuildContext? context,
      VoidCallback? onAdDismissedFullScreenContent,
      VoidCallback? onAdClicked,
      VoidCallback? onAdDisplay,
      VoidCallback? onAdFailedToShow,
      bool reloadAfterShow = true,
      bool recordLastTimeShowAd});

  void dispose();
}
