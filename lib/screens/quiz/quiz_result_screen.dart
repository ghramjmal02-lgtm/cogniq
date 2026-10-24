import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../services/gemini_service.dart';
import '../../services/progress_service.dart';

class QuizResultScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String fileName;

  const QuizResultScreen({
    super.key,
    required this.questions,
    required this.fileName,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  final Map<int, String> _selectedAnswers = {};
  bool _submitted = false;

  int get _correctCount {
    int count = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (_selectedAnswers[i] == widget.questions[i].correctAnswer) {
        count++;
      }
    }
    return count;
  }

  Future<void> _submitAndSave() async {
    setState(() {
      _submitted = true;
    });

    await ProgressService.addResult(
      QuizResult(
        fileName: widget.fileName,
        date: DateTime.now(),
        correctCount: _correctCount,
        totalCount: widget.questions.length,
        questions: widget.questions,
        selectedAnswers: Map<int, String>.from(_selectedAnswers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n?.quizResultTitle ?? 'Quiz Result')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.questions.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.questions.length) {
            if (_submitted) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      'نتيجتك: $_correctCount من ${widget.questions.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n?.exit ?? 'Exit'),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _submitAndSave,
                child: Text(l10n?.submitQuiz ?? 'Submit Quiz'),
              ),
            );
          }

          final q = widget.questions[index];
          final options = q.type == 'true_false' ? ['صح', 'خطأ'] : q.options;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${q.question}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...options.map((opt) {
                    final isSelected = _selectedAnswers[index] == opt;
                    final isCorrect = opt == q.correctAnswer;

                    Color? tileColor;
                    if (_submitted) {
                      if (isCorrect) {
                        tileColor = Colors.green.withValues(alpha: 0.3);
                      } else if (isSelected && !isCorrect) {
                        tileColor = Colors.red.withValues(alpha: 0.3);
                      }
                    }

                    return RadioListTile<String>(
                      title: Text(opt),
                      value: opt,
                      groupValue: _selectedAnswers[index],
                      tileColor: tileColor,
                      onChanged: _submitted
                          ? null
                          : (value) {
                              setState(() {
                                _selectedAnswers[index] = value!;
                              });
                            },
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
