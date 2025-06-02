import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:read_the_label/core/constants/constans.dart';
import 'package:read_the_label/models/id_ads_model.dart';
import 'package:read_the_label/repositories/ai_repository.dart';
import 'package:read_the_label/repositories/storage_repository.dart';
import 'package:read_the_label/theme/app_theme.dart';
import 'package:read_the_label/utils/ad_service_helper.dart';
import 'package:read_the_label/utils/analystic_helper.dart';
import 'package:read_the_label/viewmodels/daily_intake_view_model.dart';
import 'package:read_the_label/viewmodels/meal_analysis_view_model.dart';
import 'package:read_the_label/viewmodels/product_analysis_view_model.dart';
import 'package:read_the_label/viewmodels/ui_view_model.dart';
import 'package:read_the_label/views/screens/splash/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import 'utils/utils.dart';

const supportedLocales = [
  Locale('en', 'US'),
  Locale('hi'),
  Locale('es'),
  Locale('vi'),
  Locale('ja'),
  Locale('ko'),
  Locale('id'),
];
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
bool isAppInReview = false;
bool disableAOA = false;
bool isInOnboard = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AnalysticHelper.instance.initialize();
  AdsConfig.initAdsModels();
  isAppInReview = await Utils.isAppInReview();

  runApp(
    EasyLocalization(
        supportedLocales: supportedLocales,
        path: 'assets/translations',
        child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  bool isAppHiden = false;
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        log('AppLifecycleState: resumed');

        final callAoaResume = AdsConfig.getStatusAds(AdPlacement.openResume);
        if (isAppHiden &&
            callAoaResume &&
            !disableAOA &&
            navKey.currentContext != null &&
            !isInOnboard) {
          MexaAds.instance.loadAndShowAppOpenAd(
            placement: AdPlacement.openResume,
            context: navKey.currentContext!,
            forceShow: false,
            customLoadingOverlay: AdsLoadingOverlay(),
            onAdDisplay: () {
              disableAOA = true;
            },
          );
        }
        isAppHiden = false;
        disableAOA = false;
        break;
      case AppLifecycleState.hidden:
        log('AppLifecycleState: hidden');
        isAppHiden = true;
        break;
      case AppLifecycleState.inactive:
        log('AppLifecycleState: inactive');
        break;
      case AppLifecycleState.paused:
        log('AppLifecycleState: paused');
        break;
      case AppLifecycleState.detached:
        log('AppLifecycleState: detached');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _registerProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.lightTheme(),
        home: const SplashScreen(),
        builder: (context, child) {
          return Directionality(
              textDirection: ui.TextDirection.ltr, child: child!);
        },
      ),
    );
  }

  List<SingleChildWidget> _registerProviders() {
    return [
      // Register repositories first
      Provider<AiRepository>(
        create: (_) => AiRepository(),
      ),
      Provider<StorageRepository>(
        create: (_) => StorageRepository(),
      ),

      // Register ViewModels
      ChangeNotifierProvider<UiViewModel>(
        create: (_) => UiViewModel(),
      ),
      // Keep these changes:
      ChangeNotifierProxyProvider<UiViewModel, ProductAnalysisViewModel>(
        create: (context) => ProductAnalysisViewModel(
          aiRepository: context.read<AiRepository>(),
          uiProvider: context.read<UiViewModel>(),
        ),
        update: (context, uiViewModel, previous) =>
            previous!..uiProvider = uiViewModel,
      ),
      ChangeNotifierProxyProvider<UiViewModel, MealAnalysisViewModel>(
        create: (context) => MealAnalysisViewModel(
          aiRepository: context.read<AiRepository>(),
          uiProvider: context.read<UiViewModel>(),
        ),
        update: (context, uiViewModel, previous) =>
            previous!..uiProvider = uiViewModel,
      ),
      ChangeNotifierProxyProvider2<UiViewModel, StorageRepository,
          DailyIntakeViewModel>(
        create: (context) => DailyIntakeViewModel(
          storageRepository: context.read<StorageRepository>(),
          uiProvider: context.read<UiViewModel>(),
        ),
        update: (context, uiViewModel, storageRepository, previous) => previous!
          ..uiProvider = uiViewModel
          ..storageRepository = storageRepository,
      ),
    ];
  }
}
