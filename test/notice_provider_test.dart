import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsc_notices/models/notice_item.dart';
import 'package:tsc_notices/services/notice_provider.dart';

void main() {
  group('NoticeProvider State Manager Tests', () {
    setUp(() {
      // Set initial values for mock SharedPreferences
      SharedPreferences.setMockInitialValues({
        'is_dark_theme': true,
        'favorite_notices': '[]',
      });
    });

    test('NoticeProvider should initialize with cached preferences', () async {
      final provider = NoticeProvider();
      
      // Let initialization complete (provider calls async init in constructor)
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.isDarkTheme, true);
      expect(provider.getFavorites().isEmpty, true);
    });

    test('NoticeProvider should toggle theme mode and persist it', () async {
      final provider = NoticeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.isDarkTheme, true);

      await provider.toggleTheme();
      expect(provider.isDarkTheme, false);

      await provider.toggleTheme();
      expect(provider.isDarkTheme, true);
    });

    test('NoticeProvider should update search query and filter lists', () async {
      final provider = NoticeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      provider.updateSearchQuery('परीक्षा');
      expect(provider.searchQuery, 'परीक्षा');
    });

    test('NoticeProvider should manage favorites (add/remove/toggle)', () async {
      final provider = NoticeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      final notice = NoticeItem(
        id: '101',
        title: 'अध्यापन अनुमति पत्र विज्ञापन',
        detailUrl: '/content/101/',
        date: '१० जेठ, २०८३',
        imageUrl: 'logo.png',
        category: NoticeCategory.notice,
      );

      // Verify not favorited
      expect(provider.getFavorites().any((e) => e.id == '101'), false);

      // Toggle to add
      await provider.toggleFavorite(notice);
      expect(provider.getFavorites().length, 1);
      expect(provider.getFavorites()[0].id, '101');
      expect(provider.getFavorites()[0].isFavorite, true);

      // Toggle to remove
      await provider.toggleFavorite(provider.getFavorites()[0]);
      expect(provider.getFavorites().isEmpty, true);
    });
  });
}
