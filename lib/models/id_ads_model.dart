import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mexa_ads/mexa_ads.dart';
import 'package:read_the_label/core/constants/constans.dart';
import 'package:read_the_label/main.dart';

class IdAdsModel {
  final String idName;
  final String idAds;
  final String idAdsDebug;
  final bool status;
  final String placementAds;

  IdAdsModel({
    required this.idName,
    required this.idAds,
    required this.idAdsDebug,
    required this.status,
    required this.placementAds,
  });

  factory IdAdsModel.fromJson(Map<String, dynamic> json) {
    return IdAdsModel(
      idName: json['idName'] as String,
      idAds: json['idAds'] as String,
      idAdsDebug: json['idAdsDebug'] as String,
      status: json['status'] as bool,
      placementAds: json['placement_ads'] as String,
    );
  }
}

class AdsConfig {
  static List<IdAdsModel> _adsModels = [];

  static void initAdsModels() {
    try {
      final String adConfigJson = FirebaseRemoteConfig.instance
          .getString(RemoteConfigVariables.adConfig);
      final List<dynamic> jsonList = json.decode(adConfigJson);
      _adsModels = jsonList.map((json) => IdAdsModel.fromJson(json)).toList();
    } catch (e) {
      print('Error initializing ads models: $e');
      _adsModels = [];
    }
  }

  /// Lấy IdAdsModel dựa trên placement_ads
  static IdAdsModel? getIdAdsModel(String placementAds) {
    try {
      return _adsModels.firstWhere(
        (element) => element.placementAds == placementAds,
      );
    } catch (e) {
      return null;
    }
  }

  /// Lấy trạng thái quảng cáo dựa trên placement_ads
  static bool getStatusAds(String placementAds) {
    if (MexaAds.instance.isAdDisable || isAppInReview) {
      return false;
    }
    try {
      return _adsModels
          .firstWhere(
            (element) => element.placementAds == placementAds,
          )
          .status;
    } catch (e) {
      return false;
    }
  }

  /// Lấy ID quảng cáo dựa trên placement_ads
  static String getIdAd(String placementAds) {
    try {
      return _adsModels
          .firstWhere(
            (element) => element.placementAds == placementAds,
          )
          .idAds;
    } catch (e) {
      return "";
    }
  }
}
