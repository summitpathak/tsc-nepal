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

  // Banner Ad Unit ID (uses test ads in debug mode, production ads in release mode)
  static String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (kDebugMode) {
      // Official Google AdMob Test Banner IDs
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    } else {
      // Production Banner Ad Unit IDs
      if (Platform.isAndroid) {
        return 'ca-app-pub-6359384135172214/5464359484';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-6359384135172214/5464359484';
      }
    }
    return '';
  }

  // Interstitial Ad Unit ID (uses test ads in debug mode, production ads in release mode)
  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial ID
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910'; // Test Interstitial ID
      }
    } else {
      // Production Interstitial Ad Unit IDs
      if (Platform.isAndroid) {
        return 'ca-app-pub-6359384135172214/5464359484'; // Fallback to same/other production if needed
      } else if (Platform.isIOS) {
        return 'ca-app-pub-6359384135172214/5464359484';
      }
    }
    return '';
  }
}
