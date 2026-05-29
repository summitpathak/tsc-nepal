import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // Navigate to MainScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A387E), // Deep Government Blue
              Color(0xFF1E3A8A), // Sapphire Blue
              Color(0xFF0F172A), // Dark slate
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emblem/Logo Container
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: const Color(0xFFCC1424).withOpacity(0.2), // Crimson glow
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Icon(
                            Icons.account_balance_rounded,
                            size: 75,
                            color: const Color(0xFFCC1424), // Crimson Red representing Nepal
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      // Nepali Branding
                      Text(
                        'शिक्षक सेवा आयोग',
                        style: GoogleFonts.mukta(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      // English Subtitle
                      Text(
                        'Teacher Service Commission',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      // Custom premium loading line
                      SizedBox(
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            color: const Color(0xFFCC1424),
                            backgroundColor: Colors.white.withOpacity(0.15),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'दरखास्त, परीक्षा र नतिजा सम्बन्धी आधिकारिक पोर्टल',
                        style: GoogleFonts.mukta(
                          fontSize: 13,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
