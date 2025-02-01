import 'package:flutter/material.dart';

/// Модель для хранения результатов одной партии
class GameResult {
  final int doorWithPrize;
  final int finalChoice;
  final bool isWin;
  final DateTime playedAt;

  GameResult({
    required this.doorWithPrize,
    required this.finalChoice,
    required this.isWin,
    required this.playedAt,
  });
}

/// Экран, который показывает историю всех сыгранных партий
class GameHistoryPage extends StatelessWidget {
  final List<GameResult> gameHistory;

  const GameHistoryPage({super.key, required this.gameHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История игр'),
      ),
      body: gameHistory.isEmpty
          ? const Center(child: Text('Пока нет сыгранных партий'))
          : ListView.builder(
              itemCount: gameHistory.length,
              itemBuilder: (context, index) {
                final result = gameHistory[index];
                final formattedDate = '${result.playedAt.hour.toString().padLeft(2, '0')}:'
                    '${result.playedAt.minute.toString().padLeft(2, '0')}'
                    '  ${result.playedAt.day.toString().padLeft(2, '0')}.'
                    '${result.playedAt.month.toString().padLeft(2, '0')}.'
                    '${result.playedAt.year}';

                return ListTile(
                  leading: Icon(
                    result.isWin ? Icons.emoji_events : Icons.close,
                    color: result.isWin ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    result.isWin
                        ? 'Выигрыш! Приз за дверью ${result.doorWithPrize}'
                        : 'Проигрыш... Приз был за дверью ${result.doorWithPrize}',
                  ),
                  subtitle: Text(
                    'Финальный выбор: дверь ${result.finalChoice}\n$formattedDate',
                  ),
                );
              },
            ),
    );
  }
}
