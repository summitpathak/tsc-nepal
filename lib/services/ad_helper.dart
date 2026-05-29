import 'package:flutter/foundation.dart';
import 'dart:io';

class AdHelper {
  // Production AdMob App ID
  static String get appId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return 'ca-app-pub-6359384135172214~4717723791'; // Production App ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6359384135172214~4717723791'; // Production App ID
    }
    return '';
  }

  // Production Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return 'ca-app-pub-6359384135172214/5464359484'; // Production Banner Ad Unit ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6359384135172214/5464359484'; // Production Banner Ad Unit ID
    }
    return '';
  }

  // Interstitial Ad Unit ID (Test ID used as fallback)
  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test Interstitial ID
    }
    return '';
  }
}
