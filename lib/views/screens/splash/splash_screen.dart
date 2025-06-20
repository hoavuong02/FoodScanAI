import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mexa_ads/banner_anchor_ad_widget.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/core/constants/constans.dart';
import 'package:read_the_label/gen/assets.gen.dart';
import 'package:read_the_label/models/id_ads_model.dart';
import 'package:read_the_label/repositories/storage_repository.dart';
import 'package:read_the_label/theme/app_colors.dart';
import 'package:read_the_label/utils/ad_service_helper.dart';
import 'package:read_the_label/views/common/primary_svg_picture.dart';
import 'package:read_the_label/views/screens/home/home_page.dart';
import 'package:read_the_label/views/screens/language/language_screen.dart';
import 'package:read_the_label/views/screens/onboarding/on_boarding_screen.dart';
import 'package:read_the_label/views/screens/user_info/user_info_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final bool showLanguage;
  late final bool showOnboarding;
  bool isInitedAdService = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await context.read<StorageRepository>().initStorageRepository();
    if (mounted) {
      showLanguage = context.read<StorageRepository>().isShowLanguage();
      showOnboarding = context.read<StorageRepository>().isShowOnboarding();
    }
    await AdServiceHelper.instance.initializeAdService(
        onAdInitialized: (success) {
      setState(() {
        isInitedAdService = true;
      });
      _handleAds();
    });
    AssetLottie(Assets.animations.animScan.path).load();
  }

  Future<void> _checkUserAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      final userInfo = context.read<StorageRepository>().getUserInfo();

      if (!showLanguage) {
        return const LanguageScreen();
      } else if (!showOnboarding) {
        return const OnBoardingScreen();
      } else if (userInfo == null) {
        return const UserInfoPage();
      } else {
        return const HomePage();
      }
    }));
  }

  Future<void> _handleAds() async {
    final bool showInterSplash =
        AdsConfig.getStatusAds(AdPlacement.interSplash);
    // Khởi chạy các hàm song song

    final preloadNativeLanguage1 = MexaAds.instance.preloadNative(
      placement: AdsConfig.getIdAd(AdPlacement.nativeLanguage1_1),
      size: NativeAdSize.layout1,
    );

    final preloadNativeLanguage2 = MexaAds.instance.preloadNative(
      placement: AdsConfig.getIdAd(AdPlacement.nativeLanguage1_2),
      size: NativeAdSize.layout1,
    );

    final preloadNativeOnboarding1 = MexaAds.instance.preloadNative(
      placement: AdsConfig.getIdAd(AdPlacement.nativeOnboardingFullscreen1_1),
      size: NativeAdSize.fullScreen,
    );
    final preloadNativeOnboarding2 = MexaAds.instance.preloadNative(
      placement: AdsConfig.getIdAd(AdPlacement.nativeOnboardingFullscreen1_2),
      size: NativeAdSize.fullScreen,
    );
    final loadInterAd =
        MexaAds.instance.loadInterAd(placement: AdPlacement.interSplash);

    List<Future<bool>> listPreload = [];

    if (showInterSplash) {
      listPreload.add(loadInterAd);
    }
    if (!showLanguage) {
      if (AdsConfig.getStatusAds(AdPlacement.nativeLanguage1_1)) {
        listPreload.add(preloadNativeLanguage1);
      }
      if (AdsConfig.getStatusAds(AdPlacement.nativeLanguage1_2)) {
        listPreload.add(preloadNativeLanguage2);
      }
    } else if (!showOnboarding) {
      if (AdsConfig.getStatusAds(AdPlacement.nativeOnboardingFullscreen1_1)) {
        listPreload.add(preloadNativeOnboarding1);
      }
      if (AdsConfig.getStatusAds(AdPlacement.nativeOnboardingFullscreen1_1)) {
        listPreload.add(preloadNativeOnboarding2);
      }
    }

    // Đợi cả ba Future hoàn thành
    final results = await Future.wait(listPreload);

    try {
      // Kiểm tra kết quả của loadInterAd
      bool isInterAdLoaded = results[0];

      if (isInterAdLoaded && showInterSplash) {
        MexaAds.instance.showInterAd(
          placement: AdPlacement.interSplash,
          forceShow: true,
          recordLastTimeShowAd: false,
          reloadAfterShow: false,
          onAdDisplay: () async {
            await Future.delayed(const Duration(milliseconds: 100));
            _checkUserAndNavigate();
          },
          onAdFailedToShow: () async {
            await Future.delayed(const Duration(milliseconds: 100));
            _checkUserAndNavigate();
          },
          onShowInOffsetTime: () async {
            await Future.delayed(const Duration(milliseconds: 100));
            _checkUserAndNavigate();
          },
        );
      } else {
        print("InterAd Controller splash: " "Load fail");
        // Nếu loadInterAd thất bại
        await Future.delayed(const Duration(milliseconds: 100));
        _checkUserAndNavigate();
      }
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 100));
      _checkUserAndNavigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            Assets.images.imBgSplash.path,
            fit: BoxFit.cover,
          ),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo and Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimarySvgPicture(
                    Assets.icons.icLeaf.path,
                    color: AppColors.green,
                    width: 32,
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'FOOD',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: ' SCAN AI',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Progress Bar
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor: Color(0xffD9D9D9),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.green),
                    ),
                  )),
              const SizedBox(height: 80),
              if (AdsConfig.getStatusAds(AdPlacement.bannerSplash) &&
                  isInitedAdService)
                const SizedBox(
                    height: 100,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BannerAnchorAdWidget(
                              placement: AdPlacement.bannerSplash)
                        ])),
            ],
          ),
        ],
      ),
    );
  }
}
