import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pacman/ui/widgets/barrier.dart';
import 'package:pacman/ui/widgets/ghost.dart';
import 'package:pacman/ui/widgets/path.dart';
import 'package:pacman/ui/widgets/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 17;
  int playerPos = numberInRow * 15 + 1;
  int ghostPos = numberInRow * 2 - 2;

  final List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    156,
    129,
    140,
    151,
    162,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149,
    158,
    160
  ];
  late List<int> food = [];

  late String direction;
  late bool mouthClosed;
  late int score;

  @override
  void initState() {
    super.initState();
    direction = "right";
    mouthClosed = false;
    score = 0;
    _getFood();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: MediaQuery.of(context).size.height.toInt() ~/ 85.42857,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    _isNotBarrier(playerPos + numberInRow)) {
                  direction = "down";
                } else if (details.delta.dy < 0 &&
                    _isNotBarrier(playerPos - numberInRow)) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && _isNotBarrier(playerPos + 1)) {
                  direction = "right";
                } else if (details.delta.dx < 0 &&
                    _isNotBarrier(playerPos - 1)) {
                  direction = "left";
                }
              },
              child: GridView.builder(
                  itemCount: numberOfSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInRow,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (mouthClosed && playerPos == index) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    } else if (playerPos == index) {
                      switch (direction) {
                        case "right":
                          return const MyPlayer();
                          break;
                        case "left":
                          return Transform.rotate(
                            angle: pi,
                            child: const MyPlayer(),
                          );
                          break;
                        case "up":
                          return Transform.rotate(
                            angle: 3 * pi / 2,
                            child: const MyPlayer(),
                          );
                          break;
                        case "down":
                          return Transform.rotate(
                            angle: pi / 2,
                            child: const MyPlayer(),
                          );
                          break;
                        default:
                          const MyPlayer();
                      }
                    } else if (ghostPos == index) {
                      return const Ghost();
                    } else if (barriers.contains(index)) {
                      return MyBarrier(
                        innerColor: Colors.blue[800]!,
                        outerColor: Colors.blue[900]!,
                      );
                    } else if (food.contains(index)) {
                      return const MyPath(
                        innerColor: Colors.yellow,
                        outerColor: Colors.black,
                      );
                    } else {
                      return const MyPath(
                        innerColor: Colors.black,
                        outerColor: Colors.black,
                      );
                    }
                  }),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Score: $score",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    _play();
                  },
                  child: const Text(
                    'play',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get the food's initial position.
  _getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  _play() {
    direction = "right";
    Timer.periodic(
      const Duration(milliseconds: 120),
      (timer) {
        setState(() {
          mouthClosed = !mouthClosed;
        });
        if (food.contains(playerPos)) {
          food.remove(playerPos);
          score++;
        }
        switch (direction) {
          case "right":
            _moveRight();
            break;
          case "left":
            _moveLeft();
            break;
          case "up":
            _moveUp();
            break;
          case "down":
            _moveDown();
            break;
        }
      },
    );
  }

  _moveRight() {
    if (_isNotBarrier(playerPos + 1)) {
      setState(() {
        playerPos++;
      });
    }
  }

  _moveLeft() {
    if (_isNotBarrier(playerPos - 1)) {
      setState(() {
        playerPos--;
      });
    }
  }

  _moveUp() {
    if (_isNotBarrier(playerPos - numberInRow)) {
      setState(() {
        playerPos -= numberInRow;
      });
    }
  }

  _moveDown() {
    if (_isNotBarrier(playerPos + numberInRow)) {
      setState(() {
        playerPos += numberInRow;
      });
    }
  }

  // Return true if the given index is located in the path and not in the barrier.
  bool _isNotBarrier(int index) {
    if (!barriers.contains(index)) {
      return true;
    }
    return false;
  }
}
