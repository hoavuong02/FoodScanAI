import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/core/constants/constans.dart';
import 'package:read_the_label/gen/assets.gen.dart';
import 'package:read_the_label/utils/ad_service_helper.dart';
import 'package:read_the_label/viewmodels/product_analysis_view_model.dart';
import 'package:read_the_label/views/common/primary_button.dart';
import 'package:read_the_label/views/screens/scan_lable/scan_lable_result.dart';

import '../../../main.dart';

class ProductScanPage extends StatefulWidget {
  const ProductScanPage({super.key});

  @override
  State<ProductScanPage> createState() => _ProductScanPageState();
}

class _ProductScanPageState extends State<ProductScanPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 32,
        right: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            Assets.images.imScanLable.path,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 48),
          Text(
            'to_get_started_scan_product'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'scan_now'.tr(),
            onPressed: () => _handleImageCapture(ImageSource.camera),
            iconPath: Assets.icons.icScan.path,
            backgroundColor: Theme.of(context).colorScheme.primary,
            borderRadius: 30,
            margin: const EdgeInsets.symmetric(horizontal: 30),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            width: 240,
            text: 'gallery'.tr(),
            onPressed: () => _handleImageCapture(ImageSource.gallery),
            iconPath: Assets.icons.icGallery.path,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            borderRadius: 30,
            margin: const EdgeInsets.symmetric(horizontal: 30),
          ),
        ],
      ),
    );
  }

  void _handleImageCapture(ImageSource source) async {
    // First, capture front image
    final productAnalysisProvider =
        Provider.of<ProductAnalysisViewModel>(context, listen: false);

    await productAnalysisProvider.captureImage(
      source: source,
      isFrontImage: true,
    );

    if (productAnalysisProvider.frontImage != null) {
      // Show dialog for nutrition label
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) => scanLableDialog(productAnalysisProvider));
      }
    }
  }

  void imageCapture(
      {required ImageSource source,
      required ProductAnalysisViewModel productAnalysisProvider}) async {
    disableAOA = true;
    await productAnalysisProvider.captureImage(
      source: source,
      isFrontImage: false,
    );
    if (productAnalysisProvider.canAnalyze()) {
      showInterAds(
        placement: AdPlacement.interScanDone,
        function: () {
          Navigator.push(
              navKey.currentContext!,
              MaterialPageRoute(
                builder: (context) => const ScanLableResultPage(),
              ));
        },
      );
    }
  }

  Widget scanLableDialog(ProductAnalysisViewModel productAnalysisProvider) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'now_capture_nutrition_label'.tr(),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins'),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'capture_or_select_nutrion_lable'.tr(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'camera'.tr(),
                    textStyle: const TextStyle(fontSize: 12),
                    onPressed: () {
                      Navigator.pop(context);
                      imageCapture(
                          productAnalysisProvider: productAnalysisProvider,
                          source: ImageSource.camera);
                    },
                    // iconPath: Assets.icons.icScan.path,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    borderRadius: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PrimaryButton(
                    text: 'gallery'.tr(),
                    textStyle: const TextStyle(fontSize: 12),
                    onPressed: () {
                      Navigator.pop(context);
                      imageCapture(
                          productAnalysisProvider: productAnalysisProvider,
                          source: ImageSource.gallery);
                    },
                    // iconPath: Assets.icons.icGallery.path,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    borderRadius: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
