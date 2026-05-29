import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/notice_item.dart';
import '../services/notice_provider.dart';
import 'widgets/notice_card.dart';
import 'widgets/shimmer_loading.dart';
import 'widgets/banner_ad_widget.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NoticeCategory _selectedCategory = NoticeCategory.notice;
  final TextEditingController _searchController = TextEditingController();
  
  // Custom scrolling controller for latest updates ticker
  final ScrollController _tickerScrollController = ScrollController();
  Timer? _tickerTimer;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _startTickerAnimation();
  }

  void _startTickerAnimation() {
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_tickerScrollController.hasClients) {
        final maxScrollExtent = _tickerScrollController.position.maxScrollExtent;
        if (_scrollOffset >= maxScrollExtent) {
          _scrollOffset = 0.0;
          _tickerScrollController.jumpTo(0.0);
        } else {
          _scrollOffset += 1.0;
          _tickerScrollController.animateTo(
            _scrollOffset,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tickerScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Helper: Generates beautiful personalized Nepali greeting based on the current local time hour
  String _getNepaliGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) {
      return 'शुभ बिहानी'; // Good Morning
    } else if (hour >= 12 && hour < 17) {
      return 'शुभ दिन'; // Good Afternoon / Day
    } else if (hour >= 17 && hour < 21) {
      return 'शुभ साँझ'; // Good Evening
    } else {
      return 'शुभ रात्रि'; // Good Night
    }
  }

  String _getNepaliDate() {
    // Current English date formatted nicely
    final format = DateFormat('MMMM d, yyyy');
    return format.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoticeProvider>(context);
    final isDark = provider.isDarkTheme;
    final theme = Theme.of(context);

    // Active Category Notices
    final notices = provider.getNotices(_selectedCategory);
    final isLoading = provider.isLoading(_selectedCategory);
    final error = provider.getError(_selectedCategory);

    // Latest notices for ticker
    final tickerNotices = provider.getNotices(NoticeCategory.notice);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Premium Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.wb_sunny_rounded,
                            size: 18,
                            color: Colors.amber[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getNepaliGreeting(),
                            style: GoogleFonts.mukta(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'शिक्षक सेवा आयोग',
                        style: GoogleFonts.mukta(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0A387E),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  
                  // Top actions
                  Row(
                    children: [
                      // Bookmarks shortcut with notification dot if there are items
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.bookmarks_rounded,
                              color: isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF0A387E),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                              );
                            },
                            tooltip: 'सुरक्षित सूचनाहरू',
                          ),
                          if (provider.getFavorites().isNotEmpty)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFCC1424), // Crimson Red dot
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                        ],
                      ),
                      
                      // Theme toggle button
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          color: isDark ? Colors.amber[400] : const Color(0xFF1E293B),
                        ),
                        onPressed: () {
                          provider.toggleTheme();
                        },
                        tooltip: isDark ? 'उज्यालो मोड' : 'अध्यारो मोड',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Scrolling Update Ticker (Latest Notices Ticker)
            if (tickerNotices.isNotEmpty)
              Container(
                height: 38,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFCC1424).withOpacity(0.08), // Soft crimson background
                  border: Border(
                    top: BorderSide(color: const Color(0xFFCC1424).withOpacity(0.15), width: 1),
                    bottom: BorderSide(color: const Color(0xFFCC1424).withOpacity(0.15), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    // "LATEST" fixed label
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      color: const Color(0xFFCC1424),
                      child: Row(
                        children: [
                          const Icon(Icons.flash_on, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'भर्खरै:',
                            style: GoogleFonts.mukta(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Scrolling Text Area
                    Expanded(
                      child: ListView.builder(
                        controller: _tickerScrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tickerNotices.length + 1, // Repeat first item for seamless loop
                        itemBuilder: (context, index) {
                          final idx = index % tickerNotices.length;
                          final notice = tickerNotices[idx];
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(item: notice),
                                  ),
                                );
                              },
                              child: Text(
                                '${notice.title} (${notice.date})  •  ',
                                style: GoogleFonts.mukta(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // 3. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withOpacity(0.1) : Colors.grey.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    provider.updateSearchQuery(val);
                  },
                  style: GoogleFonts.mukta(
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    hintText: 'सूचना, विज्ञापन वा मिति खोज्नुहोस्...',
                    hintStyle: GoogleFonts.mukta(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              provider.updateSearchQuery('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Horizontal Category Chip List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: NoticeCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  
                  // Matching theme colors
                  Color chipColor;
                  switch (cat) {
                    case NoticeCategory.notice:
                      chipColor = const Color(0xFF0A387E);
                      break;
                    case NoticeCategory.vacancy:
                      chipColor = const Color(0xFF10B981);
                      break;
                    case NoticeCategory.result:
                      chipColor = const Color(0xFFF59E0B);
                      break;
                    case NoticeCategory.examCenter:
                      chipColor = const Color(0xFFEF4444);
                      break;
                    case NoticeCategory.syllabus:
                      chipColor = const Color(0xFF0EA5E9);
                      break;
                    case NoticeCategory.modelQuestion:
                      chipColor = const Color(0xFF6366F1);
                      break;
                    case NoticeCategory.laws:
                      chipColor = const Color(0xFF64748B);
                      break;
                    case NoticeCategory.modelForm:
                      chipColor = const Color(0xFF8B5CF6);
                      break;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? chipColor 
                              : (isDark ? const Color(0xFF1E293B) : Colors.white),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected 
                                ? chipColor 
                                : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04)),
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: chipColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              cat.nepaliName,
                              style: GoogleFonts.mukta(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isSelected 
                                    ? Colors.white 
                                    : (isDark ? Colors.white70 : const Color(0xFF1E293B)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 5. Active Notice List View with Shimmer & Empty states
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RefreshIndicator(
                  color: const Color(0xFF0A387E),
                  onRefresh: () async {
                    await provider.refreshCategory(_selectedCategory);
                  },
                  child: isLoading
                      ? const ShimmerSkeleton()
                      : error != null && notices.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                                const Center(
                                  child: Icon(Icons.signal_wifi_off_rounded, size: 70, color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: Text(
                                    error,
                                    style: GoogleFonts.mukta(fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0A387E),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      provider.refreshCategory(_selectedCategory);
                                    },
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: Text(
                                      'पुनः प्रयास गर्नुहोस्',
                                      style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : notices.isEmpty
                              ? ListView(
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                                    const Center(
                                      child: Icon(Icons.search_off_rounded, size: 70, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: Text(
                                        'खोजिएको वस्तु फेला परेन।',
                                        style: GoogleFonts.mukta(
                                          fontSize: 18, 
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: notices.length + (provider.hasMoreData(_selectedCategory) ? 1 : 0),
                                  padding: const EdgeInsets.only(bottom: 30),
                                  itemBuilder: (context, index) {
                                    if (index == notices.length) {
                                      final isMoreLoading = provider.isLoadingMore(_selectedCategory);
                                      Color activeColor;
                                      switch (_selectedCategory) {
                                        case NoticeCategory.notice:
                                          activeColor = const Color(0xFF0A387E);
                                          break;
                                        case NoticeCategory.vacancy:
                                          activeColor = const Color(0xFF10B981);
                                          break;
                                        case NoticeCategory.result:
                                          activeColor = const Color(0xFFF59E0B);
                                          break;
                                        case NoticeCategory.examCenter:
                                          activeColor = const Color(0xFFEF4444);
                                          break;
                                        case NoticeCategory.syllabus:
                                          activeColor = const Color(0xFF0EA5E9);
                                          break;
                                        case NoticeCategory.modelQuestion:
                                          activeColor = const Color(0xFF6366F1);
                                          break;
                                        case NoticeCategory.laws:
                                          activeColor = const Color(0xFF64748B);
                                          break;
                                        case NoticeCategory.modelForm:
                                          activeColor = const Color(0xFF8B5CF6);
                                          break;
                                      }

                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        alignment: Alignment.center,
                                        child: isMoreLoading
                                            ? SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  color: activeColor,
                                                ),
                                              )
                                            : ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: activeColor.withOpacity(0.1),
                                                  foregroundColor: activeColor,
                                                  elevation: 0,
                                                  side: BorderSide(color: activeColor.withOpacity(0.3), width: 1.5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                ),
                                                onPressed: () {
                                                  provider.fetchNextPage(_selectedCategory);
                                                },
                                                icon: const Icon(Icons.add_rounded, size: 18),
                                                label: Text(
                                                  'थप सामग्री लोड गर्नुहोस् (Load More)',
                                                  style: GoogleFonts.mukta(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                      );
                                    }

                                    final item = notices[index];
                                    return NoticeCard(
                                      item: item,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(item: item),
                                          ),
                                        );
                                      },
                                      onFavoriteToggle: () {
                                        provider.toggleFavorite(item);
                                      },
                                    );
                                  },
                                ),
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
