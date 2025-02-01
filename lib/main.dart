import 'dart:math';
import 'package:flutter/material.dart';
import 'package:montyhall/help.dart';
import 'package:montyhall/history.dart';

void main() {
  runApp(const MontyHallApp());
}

class MontyHallApp extends StatelessWidget {
  const MontyHallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monty Hall Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MontyHallPage(),
    );
  }
}

class MontyHallPage extends StatefulWidget {
  const MontyHallPage({super.key});

  @override
  State<MontyHallPage> createState() => _MontyHallPageState();
}

class _MontyHallPageState extends State<MontyHallPage> {
  // Номера дверей: 0, 1, 2
  // doorWithPrize: за какой дверью приз
  // firstChoice: первая выбранная дверь игроком
  // revealedDoor: дверь, которую открыл «ведущий»
  // finalChoice: итоговая дверь игрока (при "смене" или при оставлении)
  // gameStage: 0 - ещё не выбрали дверь; 1 - дверь выбрана, ведущий открыл; 2 - игра завершена

  late int doorWithPrize;
  int? firstChoice;
  int? revealedDoor;
  int? finalChoice;
  int gameStage = 0; // 0, 1, 2

  @override
  void initState() {
    super.initState();
    _resetGame();
    WidgetsBinding.instance
        .addPostFrameCallback((v) => showDialog(context: context, builder: (context) => MontyHallRulesDialog()));
  }

  void _resetGame() {
    // Случайным образом выбираем одну из трёх дверей для приза.
    doorWithPrize = Random().nextInt(3);

    firstChoice = null;
    revealedDoor = null;
    finalChoice = null;

    gameStage = 0;
    setState(() {});
  }

  void _chooseDoor(int index) {
    if (gameStage == 0) {
      // Игрок выбрал дверь в первый раз
      setState(() {
        firstChoice = index;
        _revealMontyDoor();
        gameStage = 1;
      });
    } else if (gameStage == 1) {
      // Игрок делает финальный выбор
      setState(() {
        finalChoice = index;
        gameStage = 2;
      });
      bool isWin = (finalChoice == doorWithPrize);

      _gameHistory.add(
        GameResult(
          doorWithPrize: doorWithPrize,
          finalChoice: finalChoice!,
          isWin: isWin,
          playedAt: DateTime.now(),
        ),
      );
    }
  }

  void _revealMontyDoor() {
    // Ведущий открывает одну из двух оставшихся дверей, за которой точно нет приза
    List<int> possibleDoorsToReveal = [0, 1, 2];
    possibleDoorsToReveal.remove(firstChoice);

    // Убираем из списка дверь с призом, если она в списке
    if (possibleDoorsToReveal.contains(doorWithPrize)) {
      if (possibleDoorsToReveal.length > 1) {
        possibleDoorsToReveal.removeWhere((door) => door == doorWithPrize);
      }
    }

    // Рандомно выбираем из оставшихся
    revealedDoor = possibleDoorsToReveal[Random().nextInt(possibleDoorsToReveal.length)];
  }

  String _getDoorEmoji(int doorIndex) {
    // Возвращает то, что мы увидим за дверью (если уже открыта)
    // - \u{1F410} — козочка
    // - \u{1F389} — приз (конфетти/победа)

    // Если игра ещё не завершена и дверь – это та, которую открыл «ведущий»:
    if (gameStage >= 1 && doorIndex == revealedDoor) {
      return doorIndex == doorWithPrize ? '🎉' : '🐐';
    }

    // Если игра завершена, показываем, что на самом деле за этой дверью
    if (gameStage == 2) {
      if (doorIndex == doorWithPrize) {
        return '🎉';
      } else {
        return '🐐';
      }
    }

    // Иначе дверь «закрыта», ничего не показываем
    return '';
  }

  Color _getDoorColor(int doorIndex) {
    // Подсвечиваем выбранную дверь
    if (doorIndex == firstChoice && gameStage == 0) {
      return Colors.orange;
    }

    // Когда игра в стадии 1 (первая дверь выбрана, одна дверь открыта ведущим),
    // можно показать подсветку, если игрок кликнет на новую дверь
    if (gameStage == 1 && doorIndex == firstChoice) {
      // Если игрок остановился на этой двери
      return Colors.orange;
    }

    if (gameStage == 2 && doorIndex == finalChoice) {
      // Если эта дверь оказалась финальным выбором
      // Можно подсветить, показывая, что это итоговый выбор
      return Colors.green;
    }

    // Если дверь открыта ведущим
    if (gameStage >= 1 && doorIndex == revealedDoor) {
      return Colors.grey.shade300;
    }

    return Colors.blue;
  }

  void _showHistory() {
    // Переход на отдельную страницу с историей:
    // Navigator.of(context).push(...) или showDialog(...)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameHistoryPage(gameHistory: _gameHistory),
      ),
    );
  }

  final List<GameResult> _gameHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monty Hall Game'),
        actions: [
          ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => MontyHallRulesDialog());
              },
              child: Text('Правила')),
          SizedBox(width: 4),
          ElevatedButton(
            onPressed: _showHistory,
            child: const Text('История'),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Выберите одну из дверей:',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),

          // Рисуем 3 двери
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return InkWell(
                onTap: () => _chooseDoor(index),
                child: Container(
                  width: 80,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _getDoorColor(index),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getDoorEmoji(index),
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 40),

          // Кнопка "Начать заново"
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text('Начать заново'),
          ),

          const SizedBox(height: 20),

          // Итоговый текст
          if (gameStage == 2) ...[
            Text(
              finalChoice == doorWithPrize ? 'Поздравляем, вы нашли приз! 🎉' : 'Увы, приз был не здесь... 😔',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ],
      ),
    );
  }
}
