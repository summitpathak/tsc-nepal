import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/notice_item.dart';
import '../services/notice_provider.dart';
import 'widgets/banner_ad_widget.dart';

class DetailScreen extends StatefulWidget {
  final NoticeItem item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoadingDetails = true;
  NoticeItem? _detailedItem;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final provider = Provider.of<NoticeProvider>(context, listen: false);
      final result = await provider.getDetails(widget.item);
      if (mounted) {
        setState(() {
          _detailedItem = result;
          _isLoadingDetails = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'विवरण प्राप्त गर्न सकिएन। कृपया पुनः प्रयास गर्नुहोस्।';
          _isLoadingDetails = false;
        });
      }
    }
  }

  Future<void> _openPdf(String pdfUrl) async {
    final uri = Uri.parse(pdfUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $pdfUrl';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'फाइल खोल्न सकिएन। लिङ्क: $pdfUrl',
              style: GoogleFonts.mukta(),
            ),
            backgroundColor: const Color(0xFFCC1424),
          ),
        );
      }
    }
  }

  void _shareNotice(NoticeItem item) {
    final shareText = '${item.title}\n\n'
        'मिति: ${item.date}\n'
        'थप विवरण: https://tsc.gov.np${item.detailUrl}\n\n'
        '${item.pdfUrl != null ? "संलग्न PDF फाइल: ${item.pdfUrl}\n\n" : ""}'
        'शिक्षक सेवा आयोग सूचना एपबाट साझा गरिएको।';
    Share.share(shareText);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'विवरण क्लिपबोर्डमा कपी गरियो।',
          style: GoogleFonts.mukta(),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoticeProvider>(context);
    final isDark = provider.isDarkTheme;
    
    // Get the current version of the item from provider (keeps isFavorite in sync)
    final currentItem = _detailedItem ?? widget.item;
    final isFav = provider.getFavorites().any((e) => e.id == currentItem.id);

    // Dynamic Category Config
    Color themeColor;
    switch (currentItem.category) {
      case NoticeCategory.notice:
        themeColor = const Color(0xFF0A387E);
        break;
      case NoticeCategory.vacancy:
        themeColor = const Color(0xFF10B981);
        break;
      case NoticeCategory.result:
        themeColor = const Color(0xFFF59E0B);
        break;
      case NoticeCategory.examCenter:
        themeColor = const Color(0xFFEF4444);
        break;
      case NoticeCategory.syllabus:
        themeColor = const Color(0xFF0EA5E9);
        break;
      case NoticeCategory.modelQuestion:
        themeColor = const Color(0xFF6366F1);
        break;
      case NoticeCategory.laws:
        themeColor = const Color(0xFF64748B);
        break;
      case NoticeCategory.modelForm:
        themeColor = const Color(0xFF8B5CF6);
        break;
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Bookmark Button
          IconButton(
            icon: Icon(
              isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isFav ? const Color(0xFFCC1424) : (isDark ? Colors.white70 : Colors.black87),
              size: 26,
            ),
            onPressed: () {
              provider.toggleFavorite(currentItem);
            },
            tooltip: isFav ? 'बुकमार्क हटाउनुहोस्' : 'बुकमार्क गर्नुहोस्',
          ),
          
          // Share Button
          IconButton(
            icon: Icon(
              Icons.share_rounded,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            onPressed: () => _shareNotice(currentItem),
            tooltip: 'साझा गर्नुहोस्',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // 1. Category Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: themeColor.withOpacity(0.3)),
                ),
                child: Text(
                  currentItem.category.nepaliName,
                  style: GoogleFonts.mukta(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white.withOpacity(0.9) : themeColor,
                  ),
                ),
              ),
              
              const SizedBox(height: 14),
              
              // 2. Large Title
              Text(
                currentItem.title,
                style: GoogleFonts.mukta(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  height: 1.35,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // 3. Date & Publisher Row
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'प्रकाशन मिति: ${currentItem.date}',
                    style: GoogleFonts.mukta(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 4. Details Section (Shimmer while loading details)
              if (_isLoadingDetails)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'आधिकारिक जानकारी प्राप्त गर्दै...',
                          style: GoogleFonts.mukta(
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: GoogleFonts.mukta(color: Colors.red[800], fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoadingDetails = true;
                            _error = null;
                          });
                          _loadDetails();
                        },
                        child: Text('पुनः प्रयास गर्नुहोस्', style: GoogleFonts.mukta()),
                      ),
                    ],
                  ),
                )
              else ...[
                // Description Text Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(0.15) : Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'सूचना विवरण (Description)',
                            style: GoogleFonts.mukta(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          // Copy Button
                          IconButton(
                            icon: Icon(
                              Icons.copy_rounded,
                              size: 18,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () => _copyToClipboard(currentItem.detailContent ?? ''),
                            tooltip: 'कपी गर्नुहोस्',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentItem.detailContent ?? 'यो सूचनाको विस्तृत विवरण प्राप्त गर्न तलको PDF फाइल डाउनलोड गर्नुहोस्।',
                        style: GoogleFonts.mukta(
                          fontSize: 16,
                          color: isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF334155),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // PDF Attachment Card
                if (currentItem.pdfUrl != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF1E3A8A).withOpacity(0.3), const Color(0xFF0F172A)]
                            : [const Color(0xFFF1F5F9), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: themeColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withOpacity(isDark ? 0.05 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Color(0xFFCC1424), // PDF Red
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'संलग्न कागजात (PDF File)',
                                    style: GoogleFonts.mukta(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  Text(
                                    'आधिकारिक कागजात हेर्न वा डाउनलोड गर्न मिल्नेछ।',
                                    style: GoogleFonts.mukta(
                                      fontSize: 12,
                                      color: isDark ? Colors.white60 : Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 18),
                        
                        // Action Buttons
                        Row(
                          children: [
                            // "View/Download PDF" Primary Button
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFCC1424), // Crimson Red
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () => _openPdf(currentItem.pdfUrl!),
                                icon: const Icon(Icons.download_rounded, size: 20),
                                label: Text(
                                  'PDF फाइल हेर्नुहोस्',
                                  style: GoogleFonts.mukta(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ] else ...[
                  // Note in case no attachment is parsed
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: themeColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'यस सूचनामा कुनै थप फाइलहरू जोडिएका छैनन्।',
                            style: GoogleFonts.mukta(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
                const BannerAdWidget(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
