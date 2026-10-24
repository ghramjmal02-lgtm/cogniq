import '../../l10n/app_localizations.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/pdf_service.dart';
import '../../services/gemini_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // نخزن محتوى الملف (bytes) واسمه بدل File، عشان يشتغل ع الويب
  Uint8List? _pdfBytes;
  String? _fileName;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // مهم جداً للويب
    );

    if (result == null) return;

    final picked = result.files.single;
    final bytes = picked.bytes;

    if (bytes == null) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.noReadableText;
      });
      return;
    }

    setState(() {
      _pdfBytes = bytes;
      _fileName = picked.name;
      _errorMessage = null;
    });
  }

  Future<void> _generateQuiz() async {
    if (_pdfBytes == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final text = await PdfService.extractText(_pdfBytes!);

      if (text.trim().isEmpty) {
        throw Exception(AppLocalizations.of(context)!.noReadableText);
      }

      final questions = await GeminiService.generateQuiz(text, count: 5);

      if (!mounted) return;

      final fileName = _fileName ?? 'file.pdf';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            questions: questions,
            fileName: fileName,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            AppLocalizations.of(context)!.errorOccurred(e.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n?.quizScreenTitle ?? 'Quiz')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file),
                label: Text(l10n?.choosePdfFile ?? 'اختر ملف PDF'),
              ),
              const SizedBox(height: 12),
              if (_fileName != null)
                Text(
                  _fileName!,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 30),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _pdfBytes == null ? null : _generateQuiz,
                  child: Text(l10n?.generateQuiz ?? 'توليد اختبار من ملف PDF'),
                ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
