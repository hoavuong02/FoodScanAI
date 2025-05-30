import 'package:read_the_label/core/constants/enum.dart';
import 'package:read_the_label/gen/assets.gen.dart';

class LanguageItemModel {
  String icon;
  String index;
  AppLocale appLocale;
  LanguageItemModel({
    required this.icon,
    required this.index,
    required this.appLocale,
  });
}

List<LanguageItemModel> configLanguage = [
  LanguageItemModel(
    icon: Assets.icons.icKorea.path,
    index: "ko",
    appLocale: AppLocale.korea,
  ),
  LanguageItemModel(
    icon: Assets.icons.icIndonesian.path,
    index: "id",
    appLocale: AppLocale.id,
  ),
  // LanguageItemModel(
  //   icon: Assets.icons.icFrance.path,
  //   index: "fr",
  //   appLocale: AppLocale.fr,
  // ),
  LanguageItemModel(
    icon: Assets.icons.icEngland.path,
    index: "en",
    appLocale: AppLocale.en,
  ),
  LanguageItemModel(
    icon: Assets.icons.icVietnam.path,
    index: "vi",
    appLocale: AppLocale.vi,
  ),
  // LanguageItemModel(
  //   icon: Assets.icons.icArab.path,
  //   index: "ar",
  //   appLocale: AppLocale.arab,
  // ),
  LanguageItemModel(
    icon: Assets.icons.icIndia.path,
    index: "hi",
    appLocale: AppLocale.hindi,
  ),
  LanguageItemModel(
    icon: Assets.icons.icJapan.path,
    index: "ja",
    appLocale: AppLocale.japan,
  ),
  LanguageItemModel(
    icon: Assets.icons.icSpain.path,
    index: "es",
    appLocale: AppLocale.es,
  ),
  // LanguageItemModel(
  //   icon: Assets.icons.icTaiwan.path,
  //   index: "zh",
  //   appLocale: AppLocale.zh,
  // ),
];
