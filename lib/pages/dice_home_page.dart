import 'dart:math';

import 'package:flutter/material.dart';

extension on double {
  double get toRad => this * 0.0174533;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index1 = 0;
  int _index2 = 0;
  int sum = 0;
  int target = 0;
  int rolCount = 0;
  bool win = false;
  bool lost = false;
  String result = '';

  final Random _random = Random.secure();
  bool hasGameStarted = false;
  bool isGameRunning = false;
  bool firstRoll = false;
  bool setTarget = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dice Game',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 500),
          firstChild: startBody(),
          secondChild: gameBody(),
          crossFadeState: hasGameStarted
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ),
    );
  }

  Column startBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          height: 300,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Transform(
                  transform: Matrix4.rotationZ(180.0.toRad),
                  alignment: Alignment.topCenter,
                  child: Image.asset(diceList[3], width: 70, height: 70),
                ),
                Transform(
                  transform: Matrix4.rotationZ(60.0.toRad),
                  alignment: Alignment.bottomRight,
                  child: Image.asset(diceList[2], width: 70, height: 70),
                ),
                Transform(
                  transform: Matrix4.rotationZ(-60.0.toRad),
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(diceList[1], width: 70, height: 70),
                ),
                Transform(
                  transform: Matrix4.rotationZ(0.0.toRad),
                  child: Image.asset(diceList[0], width: 70, height: 70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          width: 120,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                hasGameStarted = true;
              });
            },
            child: const Text(
              'Start',
              style: TextStyle(fontSize: 20),
            ),
          ),
        )
      ],
    );
  }

  Column gameBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Welcome',
            style: TextStyle(
              fontSize: 20,
              color: firstRoll ? Colors.grey.shade50 : Colors.black,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                diceList[_index1],
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                diceList[_index2],
                height: 150,
                width: 150,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(1, 20, 1, 1),
          child: Text(
            'Dice Sum : $sum',
            style: TextStyle(
                fontSize: 18,
                color: firstRoll ? Colors.black : Colors.grey.shade50),
          ),
        ),
        Text(
          'Your Target : $target',
          style: TextStyle(
              fontSize: 22,
              color: firstRoll ? Colors.black : Colors.grey.shade50),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Keep Rolling Until You Match Your Point',
            style: TextStyle(
                fontSize: 20,
                color: firstRoll && !win && !lost
                    ? Colors.black
                    : Colors.grey.shade50),
          ),
        ),
        if (lost == false && win == false)
          SizedBox(
            height: 70,
            width: 100,
            child: ElevatedButton(
              onPressed: _diceFunctionRoll,
              child: const Text(
                'Roll',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        if (lost == true || win == true)
          SizedBox(
            height: 70,
            width: 100,
            child: ElevatedButton(
              onPressed: _diceFunctionReset,
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'You $result',
            style: TextStyle(
                fontSize: 30,
                color: firstRoll && win || lost
                    ? Colors.black
                    : Colors.grey.shade50),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '7 or 11 on the first throw, you win.',
                style: TextStyle(
                  fontSize: 15,
                  color: firstRoll ? Colors.grey.shade50 : Colors.black,
                ),
              ),
              Text(
                '2, 3 or 12 on the first throw, you lose.',
                style: TextStyle(
                  fontSize: 15,
                  color: firstRoll ? Colors.grey.shade50 : Colors.black,
                ),
              ),
              Text(
                'If the sum is 4, 5, 6, 8, 9 or 10 on the first throw,',
                style: TextStyle(
                  fontSize: 15,
                  color: firstRoll ? Colors.grey.shade50 : Colors.black,
                ),
              ),
              Text(
                'that sum becomes your target point.',
                style: TextStyle(
                  fontSize: 15,
                  color: firstRoll ? Colors.grey.shade50 : Colors.black,
                ),
              ),
              Text(
                'To win,you must continue rolling the dice until,',
                style: TextStyle(
                  fontSize: 15,
                  color: firstRoll ? Colors.grey.shade50 : Colors.black,
                ),
              ),
              Text(
                'until you make your target point.',
                style: TextStyle(
                  fontSize: 15,
                  color: firstRoll ? Colors.grey.shade50 : Colors.black,
                ),
              ),
              Text(
                'You lose by rolling a 7 before matching your target.',
                style: TextStyle(
                  fontSize: 15,
                  color: firstRoll ? Colors.grey.shade50 : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _diceFunctionRoll() {
    setState(() {
      firstRoll = true;
      rolCount++;
      _index1 = _random.nextInt(6);
      _index2 = _random.nextInt(6);
      sum = _index1 + _index2 + 2;
      if (sum != 7 &&
          sum != 11 &&
          sum != 2 &&
          sum != 3 &&
          sum != 12 &&
          setTarget == false) {
        target = sum;
        setTarget = true;
      }
      if (setTarget == true && sum == 7) {
        result = 'Lost';
        lost = true;
      }
      if (setTarget == true && target == sum && rolCount > 1) {
        result = 'Won';
        win = true;
      }
      if (firstRoll == true && rolCount == 1 && (sum == 7 || sum == 11)) {
        result = 'Won';
        win = true;
      }
      if (firstRoll == true &&
          rolCount == 1 &&
          (sum == 2 || sum == 3 || sum == 12)) {
        result = 'Lost';
        lost = true;
      }
    });
  }

  void _diceFunctionReset() {
    setState(() {
      firstRoll = false;
      target = 0;
      sum = 0;
      rolCount = 0;
      setTarget = false;
      win = false;
      lost = false;
      result = '';
    });
  }
}

final diceList = [
  'images/1.png',
  'images/2.png',
  'images/3.png',
  'images/4.png',
  'images/5.png',
  'images/6.png',
];
