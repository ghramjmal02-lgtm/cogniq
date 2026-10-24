import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SummaryResultScreen extends StatelessWidget {
  final String summary;
  final String? fileName;

  const SummaryResultScreen({
    super.key,
    required this.summary,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          fileName ?? AppLocalizations.of(context)!.summaryResultTitle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            summary,
            style: const TextStyle(fontSize: 15, height: 1.6),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}
