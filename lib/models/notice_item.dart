import 'dart:convert';

enum NoticeCategory {
  notice,         // Category 72 (सूचना)
  vacancy,        // Category 74 (विज्ञापन)
  result,         // Category 73 (नतिजा/सिफारिस)
  examCenter,     // Category examination-center (परीक्षा केन्द्र)
  syllabus,       // Category 79 (पाठ्यक्रम)
  modelQuestion,  // Category 80 (नमूना प्रश्नपत्र)
  laws,           // Category 78 (ऐन/कानून)
  modelForm,      // Category 81 (नमूना फारम)
}

extension NoticeCategoryExtension on NoticeCategory {
  String get name {
    switch (this) {
      case NoticeCategory.notice:
        return 'Notices';
      case NoticeCategory.vacancy:
        return 'Vacancies';
      case NoticeCategory.result:
        return 'Results';
      case NoticeCategory.examCenter:
        return 'Exam Centers';
      case NoticeCategory.syllabus:
        return 'Syllabus';
      case NoticeCategory.modelQuestion:
        return 'Model Questions';
      case NoticeCategory.laws:
        return 'Laws & Acts';
      case NoticeCategory.modelForm:
        return 'Model Forms';
    }
  }

  String get nepaliName {
    switch (this) {
      case NoticeCategory.notice:
        return 'सूचना';
      case NoticeCategory.vacancy:
        return 'विज्ञापन';
      case NoticeCategory.result:
        return 'नतिजा';
      case NoticeCategory.examCenter:
        return 'परीक्षा केन्द्र';
      case NoticeCategory.syllabus:
        return 'पाठ्यक्रम';
      case NoticeCategory.modelQuestion:
        return 'नमूना प्रश्नपत्र';
      case NoticeCategory.laws:
        return 'ऐन/कानून';
      case NoticeCategory.modelForm:
        return 'नमूना फारम';
    }
  }

  String get categoryId {
    switch (this) {
      case NoticeCategory.notice:
        return '72';
      case NoticeCategory.vacancy:
        return '74';
      case NoticeCategory.result:
        return '73';
      case NoticeCategory.examCenter:
        return 'examination-center';
      case NoticeCategory.syllabus:
        return '79';
      case NoticeCategory.modelQuestion:
        return '80';
      case NoticeCategory.laws:
        return '78';
      case NoticeCategory.modelForm:
        return '81';
    }
  }

  static NoticeCategory fromId(String id) {
    if (id == '72') return NoticeCategory.notice;
    if (id == '74') return NoticeCategory.vacancy;
    if (id == '73') return NoticeCategory.result;
    if (id == 'examination-center') return NoticeCategory.examCenter;
    if (id == '79') return NoticeCategory.syllabus;
    if (id == '80') return NoticeCategory.modelQuestion;
    if (id == '78') return NoticeCategory.laws;
    if (id == '81') return NoticeCategory.modelForm;
    return NoticeCategory.notice; // Fallback
  }
}

class NoticeItem {
  final String id;
  final String title;
  final String detailUrl;
  final String date;
  final String imageUrl;
  final NoticeCategory category;
  bool isFavorite;
  String? pdfUrl;
  String? detailContent;
  final DateTime scrapedAt;

  NoticeItem({
    required this.id,
    required this.title,
    required this.detailUrl,
    required this.date,
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
    this.pdfUrl,
    this.detailContent,
    DateTime? scrapedAt,
  }) : this.scrapedAt = scrapedAt ?? DateTime.now();

  NoticeItem copyWith({
    String? id,
    String? title,
    String? detailUrl,
    String? date,
    String? imageUrl,
    NoticeCategory? category,
    bool? isFavorite,
    String? pdfUrl,
    String? detailContent,
  }) {
    return NoticeItem(
      id: id ?? this.id,
      title: title ?? this.title,
      detailUrl: detailUrl ?? this.detailUrl,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      detailContent: detailContent ?? this.detailContent,
      scrapedAt: this.scrapedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'detailUrl': detailUrl,
      'date': date,
      'imageUrl': imageUrl,
      'category': category.index,
      'isFavorite': isFavorite,
      'pdfUrl': pdfUrl,
      'detailContent': detailContent,
      'scrapedAt': scrapedAt.toIso8601String(),
    };
  }

  factory NoticeItem.fromJson(Map<String, dynamic> json) {
    return NoticeItem(
      id: json['id'] as String,
      title: json['title'] as String,
      detailUrl: json['detailUrl'] as String,
      date: json['date'] as String,
      imageUrl: json['imageUrl'] as String,
      category: NoticeCategory.values[json['category'] as int],
      isFavorite: json['isFavorite'] as bool? ?? false,
      pdfUrl: json['pdfUrl'] as String?,
      detailContent: json['detailContent'] as String?,
      scrapedAt: DateTime.tryParse(json['scrapedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static String serializeList(List<NoticeItem> list) {
    return json.encode(list.map((e) => e.toJson()).toList());
  }

  static List<NoticeItem> deserializeList(String jsonString) {
    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.map((e) => NoticeItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
