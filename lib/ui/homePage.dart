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
  int ghost1Pos = numberInRow * 2 - 2;
  int ghost2Pos = numberInRow * 6 + 1;
  int ghost3Pos = numberInRow * 11 - 2;

  bool paused = false;
  bool gameStarted = false;

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

  late String playerDirection;
  late String ghost1Direction;
  late String ghost2Direction;
  late String ghost3Direction;
  late bool mouthClosed;
  late int score;

  @override
  void initState() {
    super.initState();
    playerDirection = "right";
    ghost1Direction = "left";
    ghost2Direction = "right";
    ghost3Direction = "down";
    mouthClosed = false;
    score = 0;
    getFood();
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
                if (!paused) {
                  if (details.delta.dy > 0 &&
                      isNotBarrier(playerPos + numberInRow)) {
                    playerDirection = "down";
                  } else if (details.delta.dy < 0 &&
                      isNotBarrier(playerPos - numberInRow)) {
                    playerDirection = "up";
                  }
                }
              },
              onHorizontalDragUpdate: (details) {
                if (!paused) {
                  if (details.delta.dx > 0 && isNotBarrier(playerPos + 1)) {
                    playerDirection = "right";
                  } else if (details.delta.dx < 0 &&
                      isNotBarrier(playerPos - 1)) {
                    playerDirection = "left";
                  }
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
                      switch (playerDirection) {
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
                    } else if (ghost1Pos == index) {
                      return Ghost(
                        image: Image.asset(
                          'images/ghost1.png',
                        ),
                      );
                    } else if (ghost2Pos == index) {
                      return Ghost(
                        image: Image.asset(
                          'images/ghost2.png',
                        ),
                      );
                    } else if (ghost3Pos == index) {
                      return Ghost(
                        image: Image.asset(
                          'images/ghost3.png',
                        ),
                      );
                    } else if (barriers.contains(index)) {
                      return MyBarrier(
                        innerColor: Colors.blue[800]!,
                        outerColor: Colors.blue[900]!,
                        child: Text(index.toString()),
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
                    play();
                  },
                  child: const Text(
                    'Play',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                gameStarted
                    ? paused
                        ? GestureDetector(
                            onTap: () {
                              paused = false;
                            },
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              paused = true;
                              mouthClosed = false;
                            },
                            child: const Icon(
                              Icons.pause,
                              color: Colors.white,
                            ),
                          )
                    : const Text("")
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get the food's initial position.
  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void play() {
    playerDirection = "right";
    gameStarted = true;
    Timer.periodic(
      const Duration(milliseconds: 120),
      (timer) {
        setState(() {
          if (!paused) mouthClosed = !mouthClosed;
        });
        if (food.contains(playerPos)) {
          food.remove(playerPos);
          score++;
        }
        switch (playerDirection) {
          case "right":
            if (!paused) moveRight();
            break;
          case "left":
            if (!paused) moveLeft();
            break;
          case "up":
            if (!paused) moveUp();
            break;
          case "down":
            if (!paused) moveDown();
            break;
        }
      },
    );
    Timer.periodic(
      const Duration(milliseconds: 600),
      (timer) {
        if (!paused) {
          moveGhost1();
          moveGhost2();
          moveGhost3();
        }
      },
    );
  }

  void moveRight() {
    if (isNotBarrier(playerPos + 1)) {
      setState(() {
        playerPos++;
      });
    }
  }

  void moveLeft() {
    if (isNotBarrier(playerPos - 1)) {
      setState(() {
        playerPos--;
      });
    }
  }

  void moveUp() {
    if (isNotBarrier(playerPos - numberInRow)) {
      setState(() {
        playerPos -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (isNotBarrier(playerPos + numberInRow)) {
      setState(() {
        playerPos += numberInRow;
      });
    }
  }

  // Return true if the given index is located in the path and not in the barrier.
  bool isNotBarrier(int index) {
    if (!barriers.contains(index)) {
      return true;
    }
    return false;
  }

  // Move the ghost randomly
  void moveGhost1() {
    List<String> ways = possibleWays(ghost1Pos, ghost1Direction);
    ghost1Direction = ways[Random().nextInt(ways.length)];

    switch (ghost1Direction) {
      case "right":
        ghost1Pos++;
        break;
      case "left":
        ghost1Pos--;
        break;
      case "up":
        ghost1Pos -= numberInRow;
        break;
      case "down":
        ghost1Pos += numberInRow;
        break;
    }
  }

  void moveGhost2() {
    List<String> ways = possibleWays(ghost2Pos, ghost2Direction);
    ghost2Direction = ways[Random().nextInt(ways.length)];

    switch (ghost2Direction) {
      case "right":
        ghost2Pos++;
        break;
      case "left":
        ghost2Pos--;
        break;
      case "up":
        ghost2Pos -= numberInRow;
        break;
      case "down":
        ghost2Pos += numberInRow;
        break;
    }
  }

  void moveGhost3() {
    List<String> ways = possibleWays(ghost3Pos, ghost3Direction);
    ghost3Direction = ways[Random().nextInt(ways.length)];

    switch (ghost3Direction) {
      case "right":
        ghost3Pos++;
        break;
      case "left":
        ghost3Pos--;
        break;
      case "up":
        ghost3Pos -= numberInRow;
        break;
      case "down":
        ghost3Pos += numberInRow;
        break;
    }
  }

  List<String> possibleWays(int position, String direction) {
    late List<String> ways = [];

    if (isNotBarrier(position + 1)) {
      ways.add("right");
    }
    if (isNotBarrier(position - 1)) {
      ways.add("left");
    }
    if (isNotBarrier(position - numberInRow)) {
      ways.add("up");
    }
    if (isNotBarrier(position + numberInRow)) {
      ways.add("down");
    }

    // Do not reverse direction if possible
    if (direction == 'left' && ways.contains('right') && ways.length != 1) {
      ways.remove('right');
    } else if (direction == 'right' &&
        ways.contains('left') &&
        ways.length != 1) {
      ways.remove('left');
    } else if (direction == 'up' && ways.contains('down') && ways.length != 1) {
      ways.remove('down');
    } else if (direction == 'down' && ways.contains('up') && ways.length != 1) {
      ways.remove('up');
    }

    return ways;
  }
}
