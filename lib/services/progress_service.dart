import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'gemini_service.dart';

class QuizResult {
  final String fileName;
  final DateTime date;
  final int correctCount;
  final int totalCount;
  final List<QuizQuestion> questions;
  final Map<int, String> selectedAnswers;

  QuizResult({
    required this.fileName,
    required this.date,
    required this.correctCount,
    required this.totalCount,
    this.questions = const [],
    this.selectedAnswers = const {},
  });

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'date': date.toIso8601String(),
        'correctCount': correctCount,
        'totalCount': totalCount,
        'questions': questions.map((q) => q.toJson()).toList(),
        'selectedAnswers':
            selectedAnswers.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      fileName: json['fileName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      correctCount: json['correctCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
      selectedAnswers: (json['selectedAnswers'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(int.parse(k), v as String)),
    );
  }
}

class ProgressService {
  static const _key = 'quiz_results';

  static Future<List<QuizResult>> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list
        .map((e) => QuizResult.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList(); // الأحدث أولاً
  }

  static Future<void> addResult(QuizResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(jsonEncode(result.toJson()));
    await prefs.setStringList(_key, list);
  }
}
