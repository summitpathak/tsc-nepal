import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton({super.key});

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 22,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: baseColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Title line 1 skeleton
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Title line 2 skeleton
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Divider
                Container(
                  height: 1,
                  color: baseColor.withOpacity(0.3),
                ),
                const SizedBox(height: 12),
                
                // Bottom row skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 14,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
