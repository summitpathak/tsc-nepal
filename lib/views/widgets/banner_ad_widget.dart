import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../services/ad_helper.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadMobileBannerAd();
  }

  void _loadMobileBannerAd() {
    // Skip AdMob initialization on Web target to prevent runtime exceptions
    if (kIsWeb) return;

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('AdMob Banner Ad failed to load: $err');
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Web Simulation Target
    if (kIsWeb) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B0000), Color(0xFFCC1424)], // Deep crimson premium gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFFD700), // Gold border
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Simulated ad click action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'शिक्षक सेवा आयोग विशेष परीक्षा पुस्तक अनलाइन खरिद पोर्टलमा जाँदै...',
                    style: GoogleFonts.mukta(),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  // Book icon / Gold badge
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF8B0000),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Text description
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TSC परीक्षा विशेष तयारी पुस्तक २०८३',
                          style: GoogleFonts.mukta(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'नयाँ पाठ्यक्रममा आधारित प्रश्नोत्तर र नमूना सेटहरू सहित!',
                          style: GoogleFonts.mukta(
                            color: Colors.white70,
                            fontSize: 10,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // "BUY NOW" Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'खरिद गर्नुहोस्',
                      style: GoogleFonts.mukta(
                        color: const Color(0xFF8B0000),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 2. Mobile Live Platform Target
    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // Return empty widget while ad is loading on mobile
    return const SizedBox.shrink();
  }
}
