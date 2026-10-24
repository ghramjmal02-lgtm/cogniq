import 'quiz_review_screen.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../services/progress_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<QuizResult> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final results = await ProgressService.getResults();
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalQuizzes = _results.length;
    final totalCorrect =
        _results.fold<int>(0, (sum, r) => sum + r.correctCount);
    final totalQuestions =
        _results.fold<int>(0, (sum, r) => sum + r.totalCount);
    final avgPercent = totalQuestions == 0
        ? 0
        : ((totalCorrect / totalQuestions) * 100).round();

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.progress ?? 'Progress')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.7),
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                          '$totalQuizzes', l10n?.quizzesLabel ?? 'اختبارات'),
                      _buildStat('$totalCorrect/$totalQuestions',
                          l10n?.correctAnswersLabel ?? 'الإجابات الصحيحة'),
                      _buildStat(
                          '$avgPercent%', l10n?.averageLabel ?? 'متوسط '),
                    ],
                  ),
                ),
                Expanded(
                  child: _results.isEmpty
                      ? Center(
                          child: Text(
                              l10n?.noQuizzesYet ?? 'No quizzes taken yet.'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final r = _results[index];
                            final percent =
                                ((r.correctCount / r.totalCount) * 100).round();
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QuizReviewScreen(result: r),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: percent >= 50
                                        ? Colors.green.withValues(alpha: 0.2)
                                        : Colors.red.withValues(alpha: 0.2),
                                    child: Text('$percent%'),
                                  ),
                                  title: Text(r.fileName),
                                  subtitle: Text(
                                    '${r.date.day}/${r.date.month}/${r.date.year}',
                                  ),
                                  trailing: Text(
                                    '${r.correctCount}/${r.totalCount}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
