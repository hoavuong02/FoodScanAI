import 'package:mexa_ads/mexa_ads.dart';
import 'package:mexa_ads/utils.dart';
import 'app_open_ad_screen.dart';
import 'banner_anchor_ad_screen.dart';
import 'collapsible_ad_screen.dart';
import 'inline_ad_screen.dart';
import 'inters_ad_screen.dart';
import 'native_ad_screen.dart';
import 'rewarded_open_ad_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MexaAds.instance.initialize(
    adjustkey: "l7niimcenmyo",
    value: AdConstant(
        interstitialId: {
          'inter_1': ['ca-app-pub-3940256099942544/1033173712'],
          'inter_2': ['ca-app-pub-3940256099942544/1033173712'],
        },
        nativeId: {
          'native_1': '/6499/example/native',
          'native_2': '/6499/example/native',
        },
        appOpenId: {
          'app_open_1': 'ca-app-pub-3940256099942544/9257395921',
          'app_open_2': 'ca-app-pub-3940256099942544/9257395921',
        },
        bannerAnchorId: {
          'banner_1': 'ca-app-pub-3940256099942544/6300978111',
          'banner_2': 'ca-app-pub-3940256099942544/6300978111',
        },
        rewardedAdId: {
          'rewarded_1': 'ca-app-pub-3940256099942544/5224354917',
          'rewarded_2': 'ca-app-pub-3940256099942544/5224354917',
        },
        bannerCollapsibleId: {
          "collap_1": "ca-app-pub-3940256099942544/2014213617",
          "collap_2": "ca-app-pub-3940256099942544/2014213617",
        },
        interstitialOffsetTime: const Duration(seconds: 30),
        appOpenOffsetTime: const Duration(seconds: 30),
        timeoutLoadAd: const Duration(seconds: 30)),
  );
  MexaAds.instance
    ..primaryColor = const Color.fromARGB(255, 229, 14, 164)
    ..nativeTitleStyle = const TextStyle(color: Colors.black)
    ..nativeBodyStyle = const TextStyle(color: Colors.black);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    MexaAds.instance.requestConsent(
      () {
        MexaAds.instance.preloadNative(
          placement: "native_1",
          size: NativeAdSize.layout1,
          adCTABackgroundColor: [Color(0xffFFA17A), Color(0xffB50AC1)],
          gradientOrientation: GradientOrientation.leftToRight,
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        logger("AppLifecycleState.resumed");
        if (isAppHidden) {
          MexaAds.instance.loadAndShowAppOpenAd(
              context: navKey.currentContext ?? context,
              placement: 'app_open_1');
          isAppHidden = false;
        }
        break;
      case AppLifecycleState.paused:
        logger("AppLifecycleState.paused");
        break;
      case AppLifecycleState.hidden:
        logger("AppLifecycleState.hidden");
        isAppHidden = true;
        break;
      case AppLifecycleState.inactive:
        logger("AppLifecycleState.inactive");
        break;
      default:
    }
  }

  bool isAppHidden = false;
  final adsType = const [
    'Native',
    'AOA',
    'Interstitial',
    'Banner Anchor',
    'Inline',
    'Collapsible',
    'Rewarded',
    'Open Ad Inspector'
  ];
  String selectedAd = 'AOA';

  late GlobalKey<NavigatorState> navKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    MexaAds.instance.adConstant.nativeAdHeightLayout1 =
        MediaQuery.of(context).size.height * 3 / 10;
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const Text(
            'Admob Admob Plugin example',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
          actions: [
            DropdownButton<String>(
              icon: const Icon(
                Icons.change_circle_sharp,
                size: 24,
              ),
              isDense: true,
              value: selectedAd,
              items: adsType
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedAd = value.toString();
                });
                if (value.toString() == "Open Ad Inspector") {
                  MexaAds.instance.openAdInspector();
                }
              },
            ),
          ],
        ),
        body: selectedAd == adsType[0]
            ? const NativeAdScreen()
            : selectedAd == adsType[1]
                ? const AppOpenAdScreen()
                : selectedAd == adsType[2]
                    ? const IntersAdScreen()
                    : selectedAd == adsType[3]
                        ? const BannerAnchorAdScreen()
                        : selectedAd == adsType[4]
                            ? const InlineAdScreen()
                            : selectedAd == adsType[5]
                                ? const CollapsibleAdScreen()
                                : const RewardedAdScreen(),
      ),
    );
  }
}
