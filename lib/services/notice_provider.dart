import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notice_item.dart';
import 'tsc_scraper_service.dart';

class NoticeProvider with ChangeNotifier {
  final TscScraperService _scraperService = TscScraperService();
  SharedPreferences? _prefs;

  // Active state data
  Map<NoticeCategory, List<NoticeItem>> _noticesByCategory = {};
  List<NoticeItem> _favorites = [];
  bool _isDarkTheme = false;
  String _searchQuery = '';
  
  // Loading, Page & Error states
  Map<NoticeCategory, bool> _isLoading = {};
  Map<NoticeCategory, bool> _isLoadingMore = {};
  Map<NoticeCategory, int> _loadedPages = {};
  Map<NoticeCategory, bool> _hasMoreData = {};
  Map<NoticeCategory, String?> _errors = {};

  NoticeProvider() {
    _init();
  }

  // Initialize and load from cache
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // 1. Load Theme Mode
    _isDarkTheme = _prefs?.getBool('is_dark_theme') ?? false;

    // 2. Load cached notices for each category
    for (var cat in NoticeCategory.values) {
      _isLoading[cat] = false;
      _isLoadingMore[cat] = false;
      _loadedPages[cat] = 1;
      _hasMoreData[cat] = true;
      _errors[cat] = null;
      
      final cachedJson = _prefs?.getString('cached_notices_${cat.index}');
      if (cachedJson != null) {
        _noticesByCategory[cat] = NoticeItem.deserializeList(cachedJson);
      } else {
        _noticesByCategory[cat] = [];
      }
    }

    // 3. Load Bookmarks
    final favJson = _prefs?.getString('favorite_notices');
    if (favJson != null) {
      _favorites = NoticeItem.deserializeList(favJson);
      // Synchronize favorite states in the loaded lists
      _syncFavoriteStates();
    }

    notifyListeners();

    // 4. Trigger background fetch (page 1) for all categories on startup
    for (var cat in NoticeCategory.values) {
      refreshCategory(cat);
    }
  }

  // Getters
  List<NoticeItem> getNotices(NoticeCategory category) {
    final list = _noticesByCategory[category] ?? [];
    if (_searchQuery.isEmpty) return list;
    return list.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.date.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<NoticeItem> getFavorites() {
    if (_searchQuery.isEmpty) return _favorites;
    return _favorites.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.date.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  bool isLoading(NoticeCategory category) => _isLoading[category] ?? false;
  bool isLoadingMore(NoticeCategory category) => _isLoadingMore[category] ?? false;
  bool hasMoreData(NoticeCategory category) => _hasMoreData[category] ?? true;
  int getLoadedPage(NoticeCategory category) => _loadedPages[category] ?? 1;
  String? getError(NoticeCategory category) => _errors[category];
  bool get isDarkTheme => _isDarkTheme;
  String get searchQuery => _searchQuery;

  // Setters / Actions
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Refresh and reload Category to page 1
  Future<void> refreshCategory(NoticeCategory category) async {
    _isLoading[category] = true;
    _errors[category] = null;
    notifyListeners();

    try {
      final fetched = await _scraperService.fetchCategoryNotices(category, page: 1);
      
      // Update local state
      _noticesByCategory[category] = fetched;
      _loadedPages[category] = 1;
      _hasMoreData[category] = fetched.isNotEmpty && fetched.length >= 2;
      
      // Sync favorites
      _syncFavoriteStates();

      // Save page 1 to cache
      final jsonStr = NoticeItem.serializeList(fetched);
      await _prefs?.setString('cached_notices_${category.index}', jsonStr);
    } catch (e) {
      _errors[category] = 'अपडेट गर्न असफल भयो। कृपया इन्टरनेट जडान जाँच गर्नुहोस्।';
    } finally {
      _isLoading[category] = false;
      notifyListeners();
    }
  }

  // Fetch the next paginated page and append to the list
  Future<void> fetchNextPage(NoticeCategory category) async {
    // Prevent simultaneous or redundant loads
    if ((_isLoading[category] ?? false) || 
        (_isLoadingMore[category] ?? false) || 
        !(_hasMoreData[category] ?? true)) {
      return;
    }

    _isLoadingMore[category] = true;
    notifyListeners();

    final nextPage = (_loadedPages[category] ?? 1) + 1;

    try {
      final fetched = await _scraperService.fetchCategoryNotices(category, page: nextPage);

      if (fetched.isEmpty) {
        _hasMoreData[category] = false;
      } else {
        // Append items and increment page number
        final existingList = _noticesByCategory[category] ?? [];
        
        // Prevent duplicates in case page updates overlapped
        for (var item in fetched) {
          if (!existingList.any((e) => e.id == item.id)) {
            existingList.add(item);
          }
        }
        
        _loadedPages[category] = nextPage;
        
        // If fetched list length is short, it usually implies we've reached the end
        if (fetched.length < 2) {
          _hasMoreData[category] = false;
        }

        // Cache the newly accumulated list
        final jsonStr = NoticeItem.serializeList(existingList);
        await _prefs?.setString('cached_notices_${category.index}', jsonStr);
      }
    } catch (e) {
      print('Error fetching page $nextPage for category ${category.name}: $e');
      _hasMoreData[category] = false; // Graceful stop
    } finally {
      _isLoadingMore[category] = false;
      _syncFavoriteStates();
      notifyListeners();
    }
  }

  // Fetch detail page data (description text and PDF link)
  Future<NoticeItem> getDetails(NoticeItem item) async {
    // If we already have the details, we can return it
    if (item.pdfUrl != null && item.detailContent != null) {
      return item;
    }

    final updatedItem = await _scraperService.fetchNoticeDetails(item);
    
    // Update it in lists
    _updateNoticeInAllLists(updatedItem);
    return updatedItem;
  }

  // Toggle favorite / bookmark
  Future<void> toggleFavorite(NoticeItem item) async {
    final index = _favorites.indexWhere((e) => e.id == item.id);
    final updatedItem = item.copyWith(isFavorite: !item.isFavorite);

    if (index >= 0) {
      // Remove from favorites
      _favorites.removeAt(index);
    } else {
      // Add to favorites
      _favorites.add(updatedItem);
    }

    _updateNoticeInAllLists(updatedItem);
    
    // Save to SharedPreferences
    final favJson = NoticeItem.serializeList(_favorites);
    await _prefs?.setString('favorite_notices', favJson);
    
    notifyListeners();
  }

  // Toggle theme mode
  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await _prefs?.setBool('is_dark_theme', _isDarkTheme);
    notifyListeners();
  }

  // Helper: Synchronize the isFavorite state across cached categories
  void _syncFavoriteStates() {
    for (var cat in NoticeCategory.values) {
      final list = _noticesByCategory[cat] ?? [];
      for (var i = 0; i < list.length; i++) {
        final isFav = _favorites.any((fav) => fav.id == list[i].id);
        list[i].isFavorite = isFav;
      }
    }
  }

  // Helper: Update a notice's detail fields in all cached category lists and favorites list
  void _updateNoticeInAllLists(NoticeItem item) {
    // 1. Update in category lists
    for (var cat in NoticeCategory.values) {
      final list = _noticesByCategory[cat] ?? [];
      final idx = list.indexWhere((e) => e.id == item.id);
      if (idx >= 0) {
        list[idx] = item;
        // Save category list update to cache
        final jsonStr = NoticeItem.serializeList(list);
        _prefs?.setString('cached_notices_${cat.index}', jsonStr);
      }
    }

    // 2. Update in favorites list
    final favIdx = _favorites.indexWhere((e) => e.id == item.id);
    if (favIdx >= 0) {
      _favorites[favIdx] = item;
      final jsonStr = NoticeItem.serializeList(_favorites);
      _prefs?.setString('favorite_notices', jsonStr);
    }
  }
}
