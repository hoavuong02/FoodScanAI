import 'package:flutter/material.dart';
import 'package:read_the_label/gen/assets.gen.dart';
import 'package:read_the_label/theme/app_colors.dart';
import 'package:read_the_label/viewmodels/base_view_model.dart';
import 'dart:math' as math;

class UiViewModel extends BaseViewModel {
  // UI state
  double _servingSize = 0.0;
  double _sliderValue = 0.0;
  int _currentIndex = 0;
  bool _isLoading = false;

  int get currentIndex => _currentIndex;
  double get servingSize => _servingSize;
  double get sliderValue => _sliderValue;
  bool get loading => _isLoading;

  void setLoading(bool loading) {
    print("UiProvider: Setting loading to $loading");
    _isLoading = loading;
    notifyListeners();
  }

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void updateServingSize(double size) {
    _servingSize = size;
    print(_servingSize);
    notifyListeners();
  }

  void updateSliderValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }

  Color getColorForPercent(double percent) {
    if (percent > 1.0) return Colors.red; // Exceeded daily value
    if (percent > 0.8) return Colors.green; // High but not exceeded
    if (percent > 0.6) return Colors.yellow; // Moderate
    if (percent > 0.4) return Colors.yellow; // Low to moderate
    return Colors.green; // Low
  }

  String getNutrientIcon(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'energy':
        return Assets.icons.icCalories.path;
      case 'protein':
        return Assets.icons.icProtein.path;
      case 'carbohydrate':
        return Assets.icons.icCarbonHydrates.path;
      case 'fat':
        return Assets.icons.icFat.path;
      case 'fiber':
        return Assets.icons.icFiber.path;
      case 'sodium':
        return Assets.icons.icSodium.path;
      case 'calcium':
        return Assets.icons.icCalcium.path;
      case 'iron':
        return Assets.icons.icIron.path;
      case 'vitamin':
        return Assets.icons.icVitamin.path;
      default:
        return Assets.icons.icScience.path;
    }
  }

  Color getNutrientColor(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'energy':
        return const Color(0xff6BDE36);
      case 'protein':
        return const Color(0xffFFAF40);
      case 'carbohydrate':
        return const Color(0xff6B25F6);
      case 'fat':
        return const Color(0xffFF3F42);
      case 'fiber':
        return AppColors.green;
      default:
        final random = math.Random();
        return Color.fromRGBO(
          random.nextInt(200) + 55, // Red (55-255)
          random.nextInt(200) + 55, // Green (55-255)
          random.nextInt(200) + 55, // Blue (55-255)
          1, // Alpha
        );
    }
  }

  String getUnit(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'energy':
        return ' kcal';
      case 'protein':
      case 'carbohydrate':
      case 'fat':
      case 'fiber':
      case 'sugar':
        return 'g';
      case 'sodium':
      case 'potassium':
      case 'calcium':
      case 'iron':
        return 'mg';
      default:
        return '';
    }
  }
}
