import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/db_helper.dart';
import '../../models/exam.dart';
import '../../l10n/app_localizations.dart';

class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  List<Exam> _exams = [];

  final List<Color> _colors = [
    const Color(0xFF3B82F6),
    const Color(0xFFEF4444),
    const Color(0xFF10B981),
    const Color(0xFF8B5CF6),
    const Color(0xFFF59E0B),
    const Color(0xFFEC4899),
  ];

  int _selectedColor = 0xFF3B82F6;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    final data = await DBHelper.instance.getExams();
    setState(() {
      _exams = data.map((e) => Exam.fromMap(e)).toList();
    });
  }

  int _daysLeft(String date) {
    final examDate = DateTime.parse(date);
    final now = DateTime.now();
    return examDate.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  Future<void> _addExam() async {
    final l10n = AppLocalizations.of(context)!;
    final subjectController = TextEditingController();
    DateTime? selectedDate;
    int pickedColor = _colors[0].value;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            l10n.newExam,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: l10n.subjectName,
                    prefixIcon: const Icon(Icons.book_rounded,
                        color: AppTheme.primaryLight),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setStateDialog(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            color: AppTheme.primaryLight),
                        const SizedBox(width: 12),
                        Text(
                          selectedDate == null
                              ? l10n.chooseDate
                              : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.chooseColor,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _colors.map((color) {
                    final isSelected = pickedColor == color.value;
                    return GestureDetector(
                      onTap: () =>
                          setStateDialog(() => pickedColor = color.value),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  Text(l10n.cancel, style: const TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
              onPressed: () async {
                if (subjectController.text.isEmpty || selectedDate == null) {
                  return;
                }
                final exam = Exam(
                  subject: subjectController.text.trim(),
                  date:
                      '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                  color: pickedColor,
                );
                await DBHelper.instance.insertExam(exam.toMap());
                if (context.mounted) Navigator.pop(context);
                await _loadExams();
              },
              child:
                  Text(l10n.save, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteExam(int id) async {
    await DBHelper.instance.deleteExam(id);
    await _loadExams();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final txtColor = scheme.onSurface;
    final bgCard = scheme.surface;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.examScheduleTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExam,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: _exams.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 64, color: scheme.onSecondary),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noExamsYet,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSecondary, fontSize: 16),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _exams.length,
                itemBuilder: (context, i) {
                  final exam = _exams[i];
                  final color = Color(exam.color);
                  final days = _daysLeft(exam.date);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.book_rounded, color: color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exam.subject,
                                style: TextStyle(
                                  color: txtColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                exam.date,
                                style: TextStyle(
                                  color: scheme.onSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: days <= 3
                                    ? Colors.red.withValues(alpha: 0.15)
                                    : days <= 7
                                        ? Colors.orange.withValues(alpha: 0.15)
                                        : color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                days < 0
                                    ? l10n.examEnded
                                    : days == 0
                                        ? l10n.examToday
                                        : l10n.daysLeft(days),
                                style: TextStyle(
                                  color: days <= 3
                                      ? Colors.red
                                      : days <= 7
                                          ? Colors.orange
                                          : color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteExam(exam.id!),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
