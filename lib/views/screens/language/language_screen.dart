import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/core/constants/constans.dart';
import 'package:read_the_label/core/extensions/view_ext.dart';
import 'package:read_the_label/gen/assets.gen.dart';
import 'package:read_the_label/main.dart';
import 'package:read_the_label/repositories/storage_repository.dart';
import 'package:read_the_label/theme/app_colors.dart';
import 'package:read_the_label/utils/ad_service_helper.dart';
import 'package:read_the_label/views/common/primary_appbar.dart';
import 'package:read_the_label/views/common/primary_svg_picture.dart';
import 'package:read_the_label/views/screens/onboarding/on_boarding_screen.dart';

import '../../../models/id_ads_model.dart';

import 'language_item_model.dart';
import 'widgets/language_item.dart';

class LanguageScreen extends StatefulWidget {
  final String? type;
  final String? initLanguage;
  const LanguageScreen({
    super.key,
    this.type,
    this.initLanguage,
  });

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String groupIndex = '';
  bool isSelectedLanguage = false;

  List<LanguageItemModel> languageList = configLanguage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      moveMatchingItemToFirst();
      if (AdsConfig.getStatusAds(AdPlacement.nativeOnboardingFullscreen1_1)) {
        MexaAds.instance.preloadNative(
          placement: AdPlacement.nativeOnboardingFullscreen1_1,
          size: NativeAdSize.fullScreen,
        );
      }
      if (AdsConfig.getStatusAds(AdPlacement.nativeOnboardingFullscreen1_2)) {
        MexaAds.instance.preloadNative(
          placement: AdPlacement.nativeOnboardingFullscreen1_2,
          size: NativeAdSize.fullScreen,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupIndex = widget.initLanguage ?? '';
  }

  void moveMatchingItemToFirst() {
    languageList = configLanguage;
    final currentLocale = context.locale.languageCode;
    LanguageItemModel? matchingItem;

    languageList.removeWhere((item) {
      if (item.index == currentLocale) {
        matchingItem = item;
        return true;
      }
      return false;
    });

    if (matchingItem != null) {
      languageList.add(matchingItem!);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.transparent,
        title: 'language'.tr(),
        actions: [
          if (groupIndex != "")
            IconButton(
                onPressed: () async {
                  if (widget.type == "back") {
                    Navigator.pop(context);
                  } else {
                    if (groupIndex == "") {
                      context.showSnackbar(
                        Text(
                          'select_language_before_start'.tr(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                      );
                      return;
                    }
                    try {
                      await context.setLocale(supportedLocales
                          .where(
                              (element) => element.languageCode == groupIndex)
                          .first);
                    } catch (e) {
                      log(e.toString());
                    }
                    if (!context.mounted) return;
                    context.read<StorageRepository>().setShowLanguage();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnBoardingScreen(),
                        ));
                  }
                },
                icon: PrimarySvgPicture(
                  Assets.icons.icCheck.path,
                  color: AppColors.primary,
                ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languageList.length,
                  itemBuilder: (context, index) {
                    final item = languageList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LanguageItem(
                        icon: item.icon,
                        appLocale: item.appLocale,
                        onTap: (value) {
                          setState(() {
                            groupIndex = value;
                          });
                          if (!isSelectedLanguage) {
                            isSelectedLanguage = true;
                          }
                        },
                        index: item.index,
                        groupIndex: groupIndex,
                      ),
                    );
                  },
                )),
          ),
          _buildAd()
        ],
      ),
    );
  }

  Widget _buildAd() {
    return Stack(
      children: [
        AdsConfig.getStatusAds(AdPlacement.nativeLanguage1_2)
            ? const MexaNativeAd(
                placement: AdPlacement.nativeLanguage1_2,
                layout: NativeAdSize.layout1,
              )
            : const SizedBox(),
        Visibility(
            visible: isSelectedLanguage,
            child: AdsConfig.getStatusAds(AdPlacement.nativeLanguage1_1)
                ? const MexaNativeAd(
                    placement: AdPlacement.nativeLanguage1_1,
                    layout: NativeAdSize.layout1,
                  )
                : const SizedBox()),
      ],
    );
  }
}
