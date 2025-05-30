import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsentManager {
  static const String consentStatusKey = "consent_status";

  Future<void> handleConsent(Function()? onConsentResponse) async {
    ConsentDebugSettings debugSettings = ConsentDebugSettings(
        // testIdentifiers: ["1403ba0f-d2cd-409e-b64d-7915c2de4e5c"],
        debugGeography: DebugGeography.debugGeographyOther);

    ConsentRequestParameters params =
        ConsentRequestParameters(consentDebugSettings: debugSettings);
    // Kiểm tra trạng thái consent đã lưu
    bool? savedConsent = await getSavedConsentStatus();

    // Nếu đã có trạng thái consent được lưu -> request ads luôn
    if (savedConsent != null) {
      onConsentResponse?.call();
      return;
    }

    // Nếu chưa có trạng thái -> show consent form
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        // Consent info updated successfully
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await loadAndShowConsentForm(onConsentResponse);
        } else {
          onConsentResponse?.call();
          print(
              "ConsentManager: ConsentInformation.instance.isConsentFormAvailable() = false");
        }
      },
      (FormError error) {
        // Error updating consent info
        onConsentResponse?.call();
        print("ConsentManager: Consent info update error: ${error.message}");
      },
    );
  }

  Future<void> loadAndShowConsentForm(Function()? onConsentResponse) async {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        var status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show(
            (FormError? formError) async {
              bool canRequestAds =
                  await ConsentInformation.instance.canRequestAds();
              await saveConsentStatus(canRequestAds);
              onConsentResponse?.call();
            },
          );
        }
      },
      (formError) {
        onConsentResponse?.call();
        print("ConsentManager: Error - ${formError.message}");
      },
    );
  }

  Future<void> saveConsentStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(consentStatusKey, status);
  }

  Future<bool?> getSavedConsentStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(consentStatusKey);
  }

  Future<void> resetConsent() async {
    // Chỉ dùng cho testing
    ConsentInformation.instance.reset();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(consentStatusKey);
  }
}
