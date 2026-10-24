import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/progress_service.dart';

class QuizReviewScreen extends StatelessWidget {
  final QuizResult result;

  const QuizReviewScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(result.fileName)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: result.questions.length,
        itemBuilder: (context, index) {
          final q = result.questions[index];
          final options = q.type == 'true_false' ? ['صح', 'خطأ'] : q.options;
          final selected = result.selectedAnswers[index];

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
                    final isSelected = selected == opt;
                    final isCorrect = opt == q.correctAnswer;

                    Color? tileColor;
                    if (isCorrect) {
                      tileColor = Colors.green.withValues(alpha: 0.3);
                    } else if (isSelected && !isCorrect) {
                      tileColor = Colors.red.withValues(alpha: 0.3);
                    }

                    return ListTile(
                      title: Text(opt),
                      tileColor: tileColor,
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_outline)
                          : null,
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
