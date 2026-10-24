import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuizQuestion {
  final String question;
  final String type; // "mcq" or "true_false"
  final List<String> options; // empty for true_false
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] ?? '',
      type: json['type'] ?? 'mcq',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        'question': question,
        'type': type,
        'options': options,
        'correct_answer': correctAnswer,
      };
}

class GeminiService {
  static GenerativeModel _model() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    return GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: apiKey,
    );
  }

  // توليد أسئلة اختبار من نص
  static Future<List<QuizQuestion>> generateQuiz(String text,
      {int count = 5}) async {
    final model = _model();

    final prompt = '''
أنت مساعد تعليمي. اقرأ النص التالي وولّد $count أسئلة اختبار متنوعة (خليط بين اختيار من متعدد وصح/خطأ) بناءً على محتواه.

أرجع الإجابة بصيغة JSON فقط بدون أي نص إضافي، بالشكل التالي بالضبط:
[
  {
    "question": "نص السؤال",
    "type": "mcq",
    "options": ["اختيار 1", "اختيار 2", "اختيار 3", "اختيار 4"],
    "correct_answer": "الاختيار الصحيح"
  },
  {
    "question": "نص السؤال",
    "type": "true_false",
    "options": [],
    "correct_answer": "صح"
  }
]

النص:
$text
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final raw = response.text ?? '[]';

    // تنظيف الرد من أي ```json``` احتمال يحطها Gemini
    final cleaned = raw.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      final List<dynamic> jsonList = jsonDecode(cleaned);
      return jsonList.map((e) => QuizQuestion.fromJson(e)).toList();
    } catch (e) {
      throw Exception('فشل في تحليل الأسئلة: $e');
    }
  }

  // تلخيص نص PDF لمقال قصير
  static Future<String> summarizeText(String text) async {
    final model = _model();

    final prompt = '''
لخّص النص التالي في مقال قصير ومختصر (فقرة أو فقرتين)، بالعربية، يركز على أهم الأفكار الرئيسية فقط:

$text
''';

    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }
}
