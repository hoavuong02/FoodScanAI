class RemoteConfigVariables {
  static String geminiKey = "gemini_key";
  static String adConfig = "ad_config";
  static String appReviewVersion = "app_review_version";
  static String interOffsetTime = "inter_offset_time";
  static String aoaOffsetTime = "aoa_offset_time";
  static String loadAdTimeout = "load_ad_time_out";
}

class Env {
  static String defaultGeminiKey = "AIzaSyCIYGWp4GBsMbQITobNTBX3IZ5fm8T3PcE";
}

class AdPlacement {
  // Interstitial Ads
  static const String interSplash = "inter_splash"; // Ads màn splash
  static const String interScanDone =
      "inter_scan_done"; // Ads show khi scan xong -> hiện inter -> màn result
  static const String interBack =
      "inter_back"; // Ads hiện khi user back từ màn result về màn home

  // Banner Ads
  static const String bannerSplash =
      "banner_splash"; // Đặt dưới cùng màn splash
  static const String bannerHome = "banner_home"; // Ads đặt chân màn home

  // Native Ads
  static const String nativeLanguage1_1 =
      "native_language_1_1"; // Đặt ở language trước khi user click chọn
  static const String nativeLanguage1_2 =
      "native_language_1_2"; // Đặt ở language sau khi user click chọn
  static const String nativeOnboardingFullscreen1_1 =
      "native_onboarding_fullscreen_1_1"; // Đặt ở giữa onb 1 và 2
  static const String nativeOnboardingFullscreen1_2 =
      "native_onboarding_fullscreen_1_2"; // Đặt ở giữa onb 2 và 3
  static const String nativeUserInfo =
      "native_user_info"; // Ads đặt chân màn nhập user info lúc lần đầu mở app
  static const String nativeHomeDaily =
      "native_home_daily"; // Ads đặt dưới phần lịch của tab daily intake màn home
  static const String nativeResult =
      "native_result"; // Ads ở màn result, đặt ở dưới section đầu tiên

  // App Open Ads
  static const String openResume = "open_resume"; // Hiện khi mở app từ nền
}
