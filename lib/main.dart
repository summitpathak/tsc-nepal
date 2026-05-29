import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'services/notice_provider.dart';
import 'views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Google Mobile Ads SDK on mobile devices
  if (!kIsWeb) {
    MobileAds.instance.initialize();
  }
  
  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => NoticeProvider(),
      child: const TscNoticesApp(),
    ),
  );
}

class TscNoticesApp extends StatelessWidget {
  const TscNoticesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);

    // Deep Government Theme Palette
    const primaryColor = Color(0xFF0A387E); // Deep Blue
    const crimsonRed = Color(0xFFCC1424);   // Nepal Crimson Red
    const lightBg = Color(0xFFF8FAFC);      // Soft Light Blue-Grey
    const darkBg = Color(0xFF0F172A);       // Premium Slate Navy
    const darkCard = Color(0xFF1E293B);     // Charcoal Blue Card

    return MaterialApp(
      title: 'शिक्षक सेवा आयोग - सूचना',
      debugShowCheckedModeBanner: false,
      themeMode: noticeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      
      // Light Mode Theme System
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          primary: primaryColor,
          secondary: crimsonRed,
          surface: Colors.white,
          background: lightBg,
        ),
        scaffoldBackgroundColor: lightBg,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        useMaterial3: true,
      ),
      
      // Dark Mode Theme System
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1E3A8A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          primary: const Color(0xFF3B82F6),
          secondary: crimsonRed,
          surface: darkCard,
          background: darkBg,
        ),
        scaffoldBackgroundColor: darkBg,
        cardColor: darkCard,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        useMaterial3: true,
      ),
      
      home: const SplashScreen(),
    );
  }
}
