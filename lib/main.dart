import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:read_the_label/repositories/ai_repository.dart';
import 'package:read_the_label/repositories/storage_repository.dart';
import 'package:read_the_label/theme/app_theme.dart';
import 'package:read_the_label/utils/analystic_helper.dart';
import 'package:read_the_label/viewmodels/daily_intake_view_model.dart';
import 'package:read_the_label/viewmodels/meal_analysis_view_model.dart';
import 'package:read_the_label/viewmodels/product_analysis_view_model.dart';
import 'package:read_the_label/viewmodels/ui_view_model.dart';
import 'package:read_the_label/views/screens/splash/splash_screen.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AnalysticHelper.instance.initialize();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _registerProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navKey,
        theme: AppTheme.lightTheme(),
        home: const SplashScreen(),
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
