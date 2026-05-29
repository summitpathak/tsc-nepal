import 'package:flutter_test/flutter_test.dart';
import 'package:tsc_notices/models/notice_item.dart';

void main() {
  group('NoticeItem Model Tests', () {
    test('NoticeItem should instantiate correctly', () {
      final notice = NoticeItem(
        id: '4189',
        title: 'लिखित परीक्षाका कार्यक्रम स्थगनसम्बन्धी सूचना ।',
        detailUrl: '/content/4189/notification-regarding-the-postponement-of-the-program/',
        date: '४ जेठ, २०८३',
        imageUrl: 'https://giwmscdnone.gov.np/static/assets/image/newlogo.png',
        category: NoticeCategory.notice,
      );

      expect(notice.id, '4189');
      expect(notice.title, 'लिखित परीक्षाका कार्यक्रम स्थगनसम्बन्धी सूचना ।');
      expect(notice.category, NoticeCategory.notice);
      expect(notice.isFavorite, false);
      expect(notice.pdfUrl, null);
      expect(notice.detailContent, null);
    });

    test('NoticeItem should copyWith new fields', () {
      final notice = NoticeItem(
        id: '4189',
        title: 'Old Title',
        detailUrl: '/old-url',
        date: '४ जेठ, २०८३',
        imageUrl: 'https://giwmscdnone.gov.np/static/assets/image/newlogo.png',
        category: NoticeCategory.notice,
      );

      final updated = notice.copyWith(
        title: 'New Title',
        isFavorite: true,
        pdfUrl: 'https://giwmscdnone.gov.np/media/exam.pdf',
      );

      expect(updated.id, '4189');
      expect(updated.title, 'New Title');
      expect(updated.isFavorite, true);
      expect(updated.pdfUrl, 'https://giwmscdnone.gov.np/media/exam.pdf');
    });

    test('NoticeItem should serialize to and deserialize from JSON correctly', () {
      final notice = NoticeItem(
        id: '4189',
        title: 'लिखित परीक्षाका कार्यक्रम',
        detailUrl: '/content/4189/',
        date: '४ जेठ',
        imageUrl: 'logo.png',
        category: NoticeCategory.notice,
        isFavorite: true,
        pdfUrl: 'http://exam.pdf',
        detailContent: 'Exam is postponed.',
      );

      final jsonMap = notice.toJson();
      
      expect(jsonMap['id'], '4189');
      expect(jsonMap['isFavorite'], true);
      expect(jsonMap['category'], NoticeCategory.notice.index);

      final deserialized = NoticeItem.fromJson(jsonMap);

      expect(deserialized.id, '4189');
      expect(deserialized.title, 'लिखित परीक्षाका कार्यक्रम');
      expect(deserialized.isFavorite, true);
      expect(deserialized.pdfUrl, 'http://exam.pdf');
      expect(deserialized.detailContent, 'Exam is postponed.');
    });

    test('NoticeItem list serialization and deserialization should work', () {
      final notices = [
        NoticeItem(
          id: '1',
          title: 'Title 1',
          detailUrl: '/url1',
          date: 'Date 1',
          imageUrl: 'img1',
          category: NoticeCategory.notice,
        ),
        NoticeItem(
          id: '2',
          title: 'Title 2',
          detailUrl: '/url2',
          date: 'Date 2',
          imageUrl: 'img2',
          category: NoticeCategory.vacancy,
        ),
      ];

      final serialized = NoticeItem.serializeList(notices);
      final deserialized = NoticeItem.deserializeList(serialized);

      expect(deserialized.length, 2);
      expect(deserialized[0].id, '1');
      expect(deserialized[0].category, NoticeCategory.notice);
      expect(deserialized[1].id, '2');
      expect(deserialized[1].category, NoticeCategory.vacancy);
    });
  });
}
