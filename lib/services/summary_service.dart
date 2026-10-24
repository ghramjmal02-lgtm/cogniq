import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryResult {
  final String fileName;
  final DateTime date;
  final String summary;

  SummaryResult({
    required this.fileName,
    required this.date,
    required this.summary,
  });

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'date': date.toIso8601String(),
        'summary': summary,
      };

  factory SummaryResult.fromJson(Map<String, dynamic> json) {
    return SummaryResult(
      fileName: json['fileName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      summary: json['summary'] ?? '',
    );
  }
}

class SummaryService {
  static const _key = 'saved_summaries';

  static Future<List<SummaryResult>> getSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list
        .map((e) => SummaryResult.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList(); // الأحدث أولاً
  }

  static Future<void> addSummary(SummaryResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(jsonEncode(result.toJson()));
    await prefs.setStringList(_key, list);
  }

  static Future<void> deleteSummary(int reversedIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    // نفس منطق الترتيب العكسي المستخدم في getSummaries
    final actualIndex = list.length - 1 - reversedIndex;
    if (actualIndex >= 0 && actualIndex < list.length) {
      list.removeAt(actualIndex);
      await prefs.setStringList(_key, list);
    }
  }
}
