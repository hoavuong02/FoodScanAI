// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/core/constants/constans.dart';
import 'package:read_the_label/models/id_ads_model.dart';
import 'package:read_the_label/utils/ad_service_helper.dart';
import 'package:read_the_label/views/screens/ai_chat/ask_AI_page.dart';
import 'package:read_the_label/views/widgets/title_section_widget.dart';
import 'package:rive/rive.dart' as rive;

import 'package:read_the_label/core/constants/nutrient_insights.dart';
import 'package:read_the_label/gen/assets.gen.dart';
import 'package:read_the_label/views/common/corner_painter.dart';
import 'package:read_the_label/views/common/primary_appbar.dart';
import 'package:read_the_label/views/common/primary_svg_picture.dart';
import 'package:read_the_label/views/widgets/ask_ai_widget.dart';
import 'package:read_the_label/views/widgets/nutrient_balance_card.dart';
import 'package:read_the_label/views/widgets/nutrient_info_shimmer.dart';
import 'package:read_the_label/views/widgets/nutrient_tile.dart';
import 'package:read_the_label/views/widgets/portion_buttons.dart';

import '../../../theme/app_colors.dart';
import '../../../viewmodels/daily_intake_view_model.dart';
import '../../../viewmodels/product_analysis_view_model.dart';
import '../../../viewmodels/ui_view_model.dart';

class ScanLableResultPage extends StatefulWidget {
  const ScanLableResultPage({super.key});

  @override
  State<ScanLableResultPage> createState() => _ScanLableResultPageState();
}

class _ScanLableResultPageState extends State<ScanLableResultPage> {
  @override
  void initState() {
    super.initState();
    final productAnalysisProvider =
        Provider.of<ProductAnalysisViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        productAnalysisProvider.analyzeImages();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          showInterAds(
            placement: AdPlacement.interBack,
            function: () {
              Navigator.pop(context);
            },
          );
        }
      },
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: "result".tr(),
          showInterBack: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Consumer3<UiViewModel, ProductAnalysisViewModel,
                  DailyIntakeViewModel>(
              builder: (context, uiProvider, productAnalysisProvider,
                  dailyIntakeProvider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 1 / 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image:
                                FileImage(productAnalysisProvider.frontImage!)),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: CornerPainter(
                            radius: 20,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                      if (uiProvider.loading)
                        const Positioned.fill(
                          left: 5,
                          right: 5,
                          top: 5,
                          bottom: 5,
                          child: rive.RiveAnimation.asset(
                            'assets/riveAssets/qr_code_scanner.riv',
                            fit: BoxFit.fill,
                            artboard: 'scan_board',
                            animations: ['anim1'],
                            stateMachines: ['State Machine 1'],
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                buildFoodInfomation(
                    uiProvider, productAnalysisProvider, dailyIntakeProvider)
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget buildFoodInfomation(
      UiViewModel uiProvider,
      ProductAnalysisViewModel productAnalysisProvider,
      DailyIntakeViewModel dailyIntakeProvider) {
    if (uiProvider.loading) {
      return const NutrientInfoShimmer();
    } else {
      return Column(
        children: [
          //Good/Moderate nutrients
          if (productAnalysisProvider.getGoodNutrients().isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    productAnalysisProvider.productName,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 8),
                TitleSectionWidget(
                  title: "optimal_nutrients".tr(),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: productAnalysisProvider
                        .getGoodNutrients()
                        .map((nutrient) => NutrientTile(
                              nutrient: nutrient['name'],
                              healthSign: nutrient['health_impact'],
                              quantity: nutrient['quantity'],
                              insight: nutrientInsights[nutrient['name']],
                              dailyValue: nutrient['daily_value'],
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          if (AdsConfig.getStatusAds(AdPlacement.nativeResult))
            const MexaNativeAd(placement: AdPlacement.nativeResult),
          const SizedBox(height: 8),
          //Bad nutrients
          if (productAnalysisProvider.getBadNutrients().isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleSectionWidget(
                  title: "watch_out".tr(),
                  color: const Color(0xFFFF5252),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: productAnalysisProvider
                        .getBadNutrients()
                        .map((nutrient) => NutrientTile(
                              nutrient: nutrient['name'],
                              healthSign: nutrient['health_impact'],
                              quantity: nutrient['quantity'],
                              insight: nutrientInsights[nutrient['name']],
                              dailyValue: nutrient['daily_value'],
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          if (productAnalysisProvider.nutritionAnalysis['primary_concerns'] !=
              null)
            TitleSectionWidget(
              title: "recommendations".tr(),
            ),

          if (productAnalysisProvider.nutritionAnalysis['primary_concerns'] !=
              null)
            ...productAnalysisProvider.nutritionAnalysis['primary_concerns']
                .map(
              (concern) => NutrientBalanceCard(
                issue: concern['issue'] ?? '',
                explanation: concern['explanation'] ?? '',
                recommendations: (concern['recommendations'] as List?)
                        ?.map((rec) => {
                              'food': rec['food'] ?? '',
                              'quantity': rec['quantity'] ?? '',
                              'reasoning': rec['reasoning'] ?? '',
                            })
                        .toList() ??
                    [],
              ),
            ),

          if (uiProvider.servingSize > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "${"serving_size".tr()}: ${uiProvider.servingSize.round()} g",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: 14,
                            fontFamily: 'Poppins'),
                      ),
                      IconButton(
                        icon: PrimarySvgPicture(Assets.icons.icEdit.path,
                            width: 24),
                        onPressed: () => _showEditServingSizeDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "how_much_did_you_consume".tr(),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: 14,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PortionButton(
                        portion: 0.25,
                        label: "1/4",
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      PortionButton(
                        portion: 0.5,
                        label: "1/2",
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      PortionButton(
                        portion: 0.75,
                        label: "3/4",
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      PortionButton(
                        portion: 1.0,
                        label: "1",
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(child: CustomPortionButton()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ScanLableAddToTodayIntakeButton(
                    uiProvider: uiProvider,
                    dailyIntakeProvider: dailyIntakeProvider,
                    productName: productAnalysisProvider.productName,
                    nutrients: productAnalysisProvider.parsedNutrients,
                    calories: productAnalysisProvider.getCalories(),
                    imageFile: productAnalysisProvider.frontImage,
                  )
                ],
              ),
            ),
          const SizedBox(height: 8),
          if (uiProvider.servingSize > 0)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AskAiPage(
                      mealName: productAnalysisProvider.productName,
                      foodImage: productAnalysisProvider.frontImage!,
                    ),
                  ),
                );
              },
              child: const AskAiWidget(),
            ),
        ],
      );
    }
  }

  void _showEditServingSizeDialog(BuildContext context) {
    final controller = TextEditingController(
        text: context.read<UiViewModel>().servingSize.toInt().toString());

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'edit_serving_size'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'enter_serving_size_in_grams'.tr(),
                  hintStyle: const TextStyle(
                    color: Color(0xff6B6B6B),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xff6b6b6b)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.green),
                  ),
                  filled: true,
                  fillColor: const Color(0xfff4f4f4),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      'cancel'.tr(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      double? newSize = double.tryParse(controller.text);
                      if (newSize != null && newSize <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'serving_size_must_be_greater_than_0'.tr(),
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),
                        );
                        context.read<UiViewModel>().updateServingSize(100);
                      } else if (newSize != null) {
                        context.read<UiViewModel>().updateServingSize(newSize);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScanLableAddToTodayIntakeButton extends StatelessWidget {
  const ScanLableAddToTodayIntakeButton({
    super.key,
    required this.uiProvider,
    required this.dailyIntakeProvider,
    required this.productName,
    required this.nutrients,
    required this.calories,
    required this.imageFile,
  });

  final UiViewModel uiProvider;
  final DailyIntakeViewModel dailyIntakeProvider;
  final String productName;
  final List<Map<String, dynamic>> nutrients;

  final double calories;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: uiProvider.sliderValue == 0
            ? Colors.grey
            : Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 2,
        minimumSize: const Size(200, 50),
      ),
      onPressed: () {
        if (uiProvider.sliderValue == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('please_select_your_consumption'.tr()),
            ),
          );
        } else {
          dailyIntakeProvider.addToDailyIntake(
            source: 'label',
            productName: productName,
            nutrients: nutrients,
            servingSize: uiProvider.servingSize,
            consumedAmount: uiProvider.sliderValue,
            imageFile: imageFile,
          );

          uiProvider.updateCurrentIndex(2);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("added_to_today_intake".tr()),
              action: SnackBarAction(
                label: 'VIEW',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimarySvgPicture(
            Assets.icons.icAdd.path,
            width: 20,
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                "added_to_today_intake".tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                "${uiProvider.sliderValue.toStringAsFixed(0)} grams, ${(calories * (uiProvider.sliderValue / uiProvider.servingSize)).toStringAsFixed(0)} calories",
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
