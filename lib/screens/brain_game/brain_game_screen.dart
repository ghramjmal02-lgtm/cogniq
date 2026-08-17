import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class BrainGameScreen extends StatefulWidget {
  const BrainGameScreen({super.key});

  @override
  State<BrainGameScreen> createState() => _BrainGameScreenState();
}

class _BrainGameScreenState extends State<BrainGameScreen> {
  int _gridSize = 4; // 4x4 افتراضي
  late List<String> _cards;
  late List<bool> _flipped;
  late List<bool> _matched;
  int? _firstIndex;
  int? _secondIndex;
  bool _canFlip = true;
  int _moves = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _gameStarted = false;
  bool _gameWon = false;

  final List<String> _emojis = [
    '🧠',
    '📚',
    '✏️',
    '🎯',
    '💡',
    '🔬',
    '📐',
    '🎓',
    '🖊️',
    '📖',
    '🔭',
    '🧪',
    '📝',
    '🗺️',
    '🏆',
    '⭐',
    '🎨',
    '🔢',
    '🌍',
    '💻',
    '🎵',
    '🧮',
    '📊',
    '🔑',
  ];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initGame() {
    final totalCards = _gridSize * _gridSize;
    final pairsCount = totalCards ~/ 2;
    final selectedEmojis = _emojis.sublist(0, pairsCount);
    _cards = [...selectedEmojis, ...selectedEmojis]..shuffle(Random());
    _flipped = List.filled(totalCards, false);
    _matched = List.filled(totalCards, false);
    _firstIndex = null;
    _secondIndex = null;
    _canFlip = true;
    _moves = 0;
    _seconds = 0;
    _gameStarted = false;
    _gameWon = false;
    _timer?.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _flipCard(int index) {
    if (!_canFlip) return;
    if (_flipped[index]) return;
    if (_matched[index]) return;

    if (!_gameStarted) {
      _gameStarted = true;
      _startTimer();
    }

    setState(() {
      _flipped[index] = true;

      if (_firstIndex == null) {
        _firstIndex = index;
      } else {
        _secondIndex = index;
        _moves++;
        _canFlip = false;

        if (_cards[_firstIndex!] == _cards[_secondIndex!]) {
          // تطابق!
          _matched[_firstIndex!] = true;
          _matched[_secondIndex!] = true;
          _firstIndex = null;
          _secondIndex = null;
          _canFlip = true;

          if (_matched.every((m) => m)) {
            _timer?.cancel();
            _gameWon = true;
            _showWinDialog();
          }
        } else {
          // مش متطابق
          Future.delayed(const Duration(milliseconds: 800), () {
            setState(() {
              _flipped[_firstIndex!] = false;
              _flipped[_secondIndex!] = false;
              _firstIndex = null;
              _secondIndex = null;
              _canFlip = true;
            });
          });
        }
      }
    });
  }

  void _showWinDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          l10n.wellDone,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.gameFinishedStats(_moves, _formatTime(_seconds)),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text('🌟🌟🌟', style: TextStyle(fontSize: 32)),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              minimumSize: const Size(double.infinity, 44),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _initGame());
            },
            child: Text(l10n.playAgain,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memoryGameTitle),
        actions: [
          IconButton(
            onPressed: () => setState(() => _initGame()),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l10n.replay,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════════
            //   اختيار المستوى
            // ═══════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.level,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  _levelButton(l10n.easy, 4),
                  const SizedBox(width: 8),
                  _levelButton(l10n.hard, 6),
                ],
              ),
            ),

            // ═══════════════════
            //   الإحصائيات
            // ═══════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statCard(l10n.timeLabel, _formatTime(_seconds)),
                  _statCard(l10n.attemptsLabel, '$_moves'),
                  _statCard(l10n.matchedLabel,
                      '${_matched.where((m) => m).length ~/ 2}/${_gridSize * _gridSize ~/ 2}'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ═══════════════════
            //   الشبكة
            // ═══════════════════
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridSize,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, i) {
                    final isFlipped = _flipped[i];
                    final isMatched = _matched[i];

                    return GestureDetector(
                      onTap: () => _flipCard(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isMatched
                              ? AppTheme.primary.withValues(alpha: 0.2)
                              : isFlipped
                                  ? scheme.surface
                                  : AppTheme.primary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMatched
                                ? AppTheme.primary
                                : isFlipped
                                    ? AppTheme.primary.withValues(alpha: 0.3)
                                    : AppTheme.primary.withValues(alpha: 0.5),
                          ),
                          boxShadow: isFlipped || isMatched
                              ? []
                              : [
                                  BoxShadow(
                                    color:
                                        AppTheme.primary.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: isFlipped || isMatched
                              ? Text(
                                  _cards[i],
                                  style: TextStyle(
                                    fontSize: _gridSize == 4 ? 28 : 20,
                                  ),
                                )
                              : Icon(
                                  Icons.psychology_rounded,
                                  color: Colors.white,
                                  size: _gridSize == 4 ? 28 : 20,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelButton(String label, int size) {
    final isSelected = _gridSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _gridSize = size;
          _initGame();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.primaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
