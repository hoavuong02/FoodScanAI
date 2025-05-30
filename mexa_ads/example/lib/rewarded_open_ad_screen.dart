import 'dart:developer';

import 'package:mexa_ads/mexa_ads.dart';
import 'button.dart';
import 'package:flutter/material.dart';

class RewardedAdScreen extends StatelessWidget {
  const RewardedAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryButton(
        onPressed: () {
          MexaAds.instance.loadAndShowRewardAd(
            context: context,
            placement: "rewarded_1",
            onAdLoaded: () {
              log("Reward: onAdLoaded");
            },
            onAdFailToLoad: () {
              log("Reward: onAdFailToLoad");
            },
            onAdClicked: () {
              log("Reward: onAdClicked");
            },
            onAdDisplay: () {
              log("Reward: onAdDisplay");
            },
            onAdDismissedFullScreenContent: () {
              log("Reward: onAdDismissedFullScreenContent");
            },
            onAdFailedToShow: () {
              log("Reward: onAdFailedToShow");
            },
            showLoading: true,
            reloadAfterShow: true,
          );
        },
        label: 'Show Rewarded Ad',
      ),
    );
  }
}
