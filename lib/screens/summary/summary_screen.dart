import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/pdf_service.dart';
import '../../services/gemini_service.dart';
import '../../services/summary_service.dart';
import 'summary_result_screen.dart';
import '../../l10n/app_localizations.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // نخزن محتوى الملف (bytes) واسمه بدل File، عشان يشتغل ع الويب
  Uint8List? _pdfBytes;
  String? _fileName;
  bool _isLoading = false;
  bool _isLoadingList = true;
  String? _errorMessage;
  List<SummaryResult> _savedSummaries = [];

  @override
  void initState() {
    super.initState();
    _loadSummaries();
  }

  Future<void> _loadSummaries() async {
    final summaries = await SummaryService.getSummaries();
    if (!mounted) return;
    setState(() {
      _savedSummaries = summaries;
      _isLoadingList = false;
    });
  }

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

  Future<void> _generateSummary() async {
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

      final summary = await GeminiService.summarizeText(text);
      final fileName = _fileName ?? 'file.pdf';

      // احفظ التلخيص
      await SummaryService.addSummary(
        SummaryResult(
          fileName: fileName,
          date: DateTime.now(),
          summary: summary,
        ),
      );

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SummaryResultScreen(
            summary: summary,
            fileName: fileName,
          ),
        ),
      );

      // بعد الرجوع من شاشة النتيجة، رجّع تحميل القائمة عشان تظهر التلخيص الجديد
      if (!mounted) return;
      setState(() {
        _pdfBytes = null;
        _fileName = null;
      });
      _loadSummaries();
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.summarizeFile)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.summarize_rounded,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.choosePdfFile),
                ),
                const SizedBox(height: 12),
                if (_fileName != null)
                  Text(
                    _fileName!,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _pdfBytes == null ? null : _generateSummary,
                    child: Text(l10n.summarizeFile),
                  ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                l10n.savedSummaries,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: _isLoadingList
                ? const Center(child: CircularProgressIndicator())
                : _savedSummaries.isEmpty
                    ? Center(child: Text(l10n.noSummariesYet))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _savedSummaries.length,
                        itemBuilder: (context, index) {
                          final s = _savedSummaries[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: const Icon(Icons.description_outlined),
                              title: Text(s.fileName),
                              subtitle: Text(
                                '${s.date.day}/${s.date.month}/${s.date.year}',
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SummaryResultScreen(
                                      summary: s.summary,
                                      fileName: s.fileName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
