import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/notice_item.dart';

class NoticeCard extends StatelessWidget {
  final NoticeItem item;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const NoticeCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Custom configuration based on category
    Color badgeColor;
    IconData categoryIcon;

    switch (item.category) {
      case NoticeCategory.notice:
        badgeColor = const Color(0xFF0A387E); // Deep Blue
        categoryIcon = Icons.info_outline_rounded;
        break;
      case NoticeCategory.vacancy:
        badgeColor = const Color(0xFF10B981); // Emerald Green
        categoryIcon = Icons.campaign_rounded;
        break;
      case NoticeCategory.result:
        badgeColor = const Color(0xFFF59E0B); // Amber Gold
        categoryIcon = Icons.emoji_events_outlined;
        break;
      case NoticeCategory.examCenter:
        badgeColor = const Color(0xFFEF4444); // Crimson Red
        categoryIcon = Icons.place_outlined;
        break;
      case NoticeCategory.syllabus:
        badgeColor = const Color(0xFF0EA5E9); // Cyan Blue
        categoryIcon = Icons.menu_book_rounded;
        break;
      case NoticeCategory.modelQuestion:
        badgeColor = const Color(0xFF6366F1); // Indigo
        categoryIcon = Icons.quiz_outlined;
        break;
      case NoticeCategory.laws:
        badgeColor = const Color(0xFF64748B); // Slate Grey
        categoryIcon = Icons.gavel_rounded;
        break;
      case NoticeCategory.modelForm:
        badgeColor = const Color(0xFF8B5CF6); // Violet
        categoryIcon = Icons.description_outlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.2) 
                : Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: badgeColor.withOpacity(0.05),
          highlightColor: badgeColor.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Category Badge & Action row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(isDark ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: badgeColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            categoryIcon,
                            size: 14,
                            color: isDark ? Colors.white : badgeColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            item.category.nepaliName,
                            style: GoogleFonts.mukta(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white.withOpacity(0.9) : badgeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Bookmark action
                    IconButton(
                      icon: Icon(
                        item.isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: item.isFavorite ? const Color(0xFFCC1424) : Colors.grey,
                        size: 22,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: onFavoriteToggle,
                      tooltip: item.isFavorite ? 'बुकमार्क हटाउनुहोस्' : 'बुकमार्क गर्नुहोस्',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Title Text
                Text(
                  item.title,
                  style: GoogleFonts.mukta(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 14),
                
                // Divider line
                Container(
                  height: 1,
                  color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                ),
                
                const SizedBox(height: 12),
                
                // Bottom Date & Actions Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Published Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.date,
                          style: GoogleFonts.mukta(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    
                    // "View Detail" arrow link
                    Row(
                      children: [
                        Text(
                          'पुरा हेर्नुहोस्',
                          style: GoogleFonts.mukta(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.blue[300] : const Color(0xFF0A387E),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 16,
                          color: isDark ? Colors.blue[300] : const Color(0xFF0A387E),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
