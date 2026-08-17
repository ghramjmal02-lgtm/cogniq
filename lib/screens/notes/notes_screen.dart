import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/db_helper.dart';
import '../../models/note.dart';
import '../../l10n/app_localizations.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  String? _selectedSubject;
  List<String> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await DBHelper.instance.getNotes();
    setState(() {
      _notes = data.map((e) => Note.fromMap(e)).toList();
      final subjects = _notes.map((n) => n.subject).toSet().toList();
      _subjects = subjects;
    });
  }

  List<Note> get _filteredNotes {
    if (_selectedSubject == null) return _notes;
    return _notes.where((n) => n.subject == _selectedSubject).toList();
  }

  Future<void> _addNote() async {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final subjectController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.newNote,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: l10n.titleField,
                prefixIcon: const Icon(Icons.title_rounded,
                    color: AppTheme.primaryLight),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: l10n.subjectField,
                prefixIcon: const Icon(Icons.book_rounded,
                    color: AppTheme.primaryLight),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.contentField,
                prefixIcon: const Icon(Icons.notes_rounded,
                    color: AppTheme.primaryLight),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) return;
                  final note = Note(
                    title: titleController.text.trim(),
                    content: contentController.text.trim(),
                    subject: subjectController.text.trim().isEmpty
                        ? l10n.generalSubject
                        : subjectController.text.trim(),
                    createdAt: DateTime.now().toString().substring(0, 10),
                  );
                  try {
                    await DBHelper.instance.insertNote(note.toMap());
                    if (context.mounted) Navigator.pop(context);
                    await _loadNotes();
                  } catch (e) {
                    debugPrint('❌ خطأ: $e');
                  }
                },
                child: Text(
                  l10n.saveNote,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteNote(int id) async {
    await DBHelper.instance.deleteNote(id);
    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final txtColor = scheme.onSurface;
    final bgCard = scheme.surface;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notesTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _subjects.length + 1,
                itemBuilder: (context, i) {
                  final label = i == 0 ? l10n.all : _subjects[i - 1];
                  final value = i == 0 ? null : _subjects[i - 1];
                  final selected = _selectedSubject == value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSubject = value),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.primary : bgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppTheme.primary
                              : AppTheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: selected ? Colors.white : txtColor,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: _filteredNotes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_add_rounded,
                            size: 64,
                            color: scheme.onSecondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noNotesYet,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: scheme.onSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredNotes.length,
                      itemBuilder: (context, i) {
                        final note = _filteredNotes[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.title,
                                      style: TextStyle(
                                        color: txtColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        note.subject,
                                        style: const TextStyle(
                                          color: AppTheme.primaryLight,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    if (note.content.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        note.content,
                                        style: TextStyle(
                                          color: scheme.onSecondary,
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    Text(
                                      note.createdAt,
                                      style: TextStyle(
                                        color: scheme.onSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _deleteNote(note.id!),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
