# ADMOB ADS

A Google Admob plugin project.

# Installation

#### 1. Plugin installation

Open the `pubspec.yaml` file and add the git dependency to install the plugin:

```yaml
  dependencies:
    
    mexa_ads:
    git:
      url: 
      ref: develop
```
    
**Note**: Current version is in `develop` branch.
    
#### 2. Android Admod config

- Open the `AndroidManifest.xml` file and add the Google Admob Application ID to the `<application>` tag. Notice here, we will create the `@string/admob_id` variable by each app build flavor later: 
```xml
   <application>

        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="@string/admob_id" />

    </application>
```

- Next, Open the `build.gradle (app module)`  file:

    1. Enable `multiDexEnabled` 


        ```gradle
        android {
        defaultConfig {
            ...
            multiDexEnabled true
        }
        ```

  Note: If your `minSdkVersion` is set to 21 or higher, multidex is enabled by default and you don't need the multidex library.

  2. Config `buildTypes` variables for each build type. You must define the  `admob_id` for the Google Admob Application ID used above.
 

        ```gradle
        buildTypes {
            release {
                  signingConfig signingConfigs.release
                  minifyEnabled true
                  resValue("string", "admob_id", "ca-app-pub-xxx")
            }
            debug {
                  resValue("string", "admob_id", "ca-app-pub-xxx")
            }
        }
        
        ```


# Usage/Examples

  ### 1. Initialize 

First, let's initialize the plugin constant before any use of functions. Typically, we should declare at the `main` function.

```dart
  MexaAds.instance.initialize(
    AdConstant(
      interstitialId: 'xxx',
      nativeId: 'xxx',
      inlineId: 'xxx',
      appOpenId: 'xxx',
      bannerAnchorId: 'xxx',
      interstitialOffsetTime: const Duration(seconds: 30),
      appOpenOffsetTime: const Duration(seconds: 30),
    ),
  );
```

+ `interstitialOffsetTime`: the offet time after the last Interstitial Ad was showed, default is 30s
+ `appOpenOffsetTime`: the offet time after the last App Open Ad was showed, default is 30s

### 2. Show Interstitial Ad
  ```dart
    MexaAds.instance.showInterstitialAd();
  ``` 
    
+ `forceShow`: whether the ad will be forced to showed or not. If `true`, it will ignore the offset time.

### 3. Show App Open Ad
  ```dart
    MexaAds.instance.showAppOpenAd();
  ``` 
    
+ `forceShow`: whether the ad will be forced to showed or not. If `true`, it will ignore the offset time.

### 4. Get Ad Widget

| Type | Usage   | Description                |
| :-------- | :------- | :------------------------- |
| `Native Ad` | `NativeAdWidget()` | Show Native Ad Widget |
| `Banner Anchor Ad` | `BannerAnchorAdWidget()` | Show Banner Anchor Ad Widget |
| `Inline Ad` | `InlineAdaptiveAdWidget()` | Show Banner Inline Ad Widget |
| `Collapsible Ad` | `CollapsibleAdWidget()` | Show Collapsible Ad Widget |



