import 'package:flutter/material.dart';

class MontyHallRulesDialog extends StatelessWidget {
  const MontyHallRulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Правила игры'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              '1. Перед вами три двери: за одной из них находится приз, '
              'а за двумя другими – нет.\n',
            ),
            Text(
              '2. Сначала вы выбираете одну дверь, но не открываете её сразу.\n',
            ),
            Text(
              '3. Ведущий, знающий расположение приза, открывает одну из '
              'оставшихся дверей, за которой приза точно нет.\n',
            ),
            Text(
              '4. Вам предлагается либо остаться при своём первоначальном выборе, '
              'либо переключиться на другую дверь.\n',
            ),
            Text(
              '5. Затем выбранная вами дверь открывается, и становится ясно, '
              'где был приз.\n',
            ),
            Divider(),
            Text(
              'Совет: согласно теории вероятностей, '
              'изменение выбора после открытия одной двери повышает '
              'шанс на победу с 1/3 до 2/3!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Понятно'),
        ),
      ],
    );
  }
}
