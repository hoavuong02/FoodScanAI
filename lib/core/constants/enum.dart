import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

enum AppLocale {
  en,
  hindi,
  es,
  pt,
  vi,
  id,
  ru,
  japan,
  korea,
}

extension AppLocaleExt on AppLocale {
  Locale get value {
    switch (this) {
      case AppLocale.vi:
        return const Locale('vi');
      case AppLocale.id:
        return const Locale('id');
      case AppLocale.en:
        return const Locale('en', 'us');
      case AppLocale.hindi:
        return const Locale('hi');
      case AppLocale.es:
        return const Locale('es');
      case AppLocale.pt:
        return const Locale('pt');
      case AppLocale.ru:
        return const Locale('ru');
      case AppLocale.japan:
        return const Locale('ja');
      case AppLocale.korea:
        return const Locale('ko');
    }
  }

  Locale fromLocaleString(String str) {
    switch (str) {
      case 'vi':
        return const Locale('vi');
      case 'id':
        return const Locale('id');
      case 'en_us':
        return const Locale('en', 'us');
      case 'hi':
        return const Locale('hi');
      case 'pt':
        return const Locale('pt');
      case 'ru':
        return const Locale('ru');
      case 'ja':
        return const Locale('ja');
      case 'fr':
        return const Locale('fr');
      case 'ko':
        return const Locale('ko');
      default:
        return const Locale('en', 'us');
    }
  }

  String toSavedLocalString() {
    switch (this) {
      case AppLocale.vi:
        return 'vi';
      case AppLocale.id:
        return 'id';
      case AppLocale.en:
        return 'en_us';
      case AppLocale.hindi:
        return 'hi';
      case AppLocale.pt:
        return 'pt';
      case AppLocale.ru:
        return 'ru';
      case AppLocale.japan:
        return 'ja';
      case AppLocale.korea:
        return 'ko';
      default:
        return 'en_us';
    }
  }

  String toLocaleString() {
    switch (this) {
      case AppLocale.vi:
        return 'vietnamese'.tr();
      case AppLocale.id:
        return 'Indonesian';
      case AppLocale.en:
        return 'english'.tr();
      case AppLocale.hindi:
        return 'hindi'.tr();
      case AppLocale.es:
        return 'spanish'.tr();
      case AppLocale.pt:
        return 'Portuguese';
      case AppLocale.ru:
        return 'Russian';
      case AppLocale.japan:
        return 'japanese'.tr();
      case AppLocale.korea:
        return 'korean'.tr();
    }
  }
}
