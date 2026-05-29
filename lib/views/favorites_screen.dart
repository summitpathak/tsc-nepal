import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/notice_provider.dart';
import 'widgets/notice_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoticeProvider>(context);
    final isDark = provider.isDarkTheme;
    final favorites = provider.getFavorites();

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
          onPressed: () {
            // Reset query on exit
            provider.updateSearchQuery('');
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'सुरक्षित फाइलहरू (Bookmarks)',
          style: GoogleFonts.mukta(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Offline Search Bar
          if (favorites.isNotEmpty || _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withOpacity(0.1) : Colors.grey.withOpacity(0.04),
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
                    hintText: 'सुरक्षित सूचनाहरूमा खोज्नुहोस्...',
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

          // Saved list or empty state
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: isDark 
                                  ? const Color(0xFF1E293B) 
                                  : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bookmark_border_rounded,
                              size: 50,
                              color: isDark ? Colors.white30 : Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'कुनै पनि फाइल सुरक्षित गरिएको छैन',
                            style: GoogleFonts.mukta(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text(
                              'तपाईंले पछि फेरि पढ्न सुरक्षित गर्नुभएका सूचना, नतिजा वा विज्ञापनहरू यहाँ रहनेछन्। यो सेवा अफलाइन हुँदा पनि उपलब्ध हुन्छ।',
                              style: GoogleFonts.mukta(
                                fontSize: 14,
                                color: isDark ? Colors.white38 : Colors.black45,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: favorites.length,
                      padding: const EdgeInsets.only(bottom: 24, top: 4),
                      itemBuilder: (context, index) {
                        final item = favorites[index];
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
        ],
      ),
    );
  }
}
