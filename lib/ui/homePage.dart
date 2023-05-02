import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pacman/ui/widgets/ghost.dart';
import 'package:pacman/ui/widgets/player.dart';
import 'package:pacman/ui/widgets/pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;

  late int playerPos;
  late int ghost1Pos;
  late int ghost2Pos;
  late int ghost3Pos;

  late String playerDirection;
  late String ghost1Direction;
  late String ghost2Direction;
  late String ghost3Direction;

  late int mazeNum;
  late bool paused;
  late bool gameStarted;
  late bool gameOver;
  late bool mouthClosed;
  late int score;
  bool firstRound = true;

  List<List<int>> barriers = [
    //Easy
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      21,
      22,
      24,
      30,
      32,
      33,
      37,
      38,
      43,
      44,
      48,
      49,
      54,
      55,
      65,
      66,
      76,
      77,
      80,
      81,
      82,
      83,
      87,
      88,
      91,
      92,
      93,
      94,
      98,
      99,
      109,
      110,
      120,
      121,
      125,
      126,
      131,
      132,
      136,
      137,
      142,
      143,
      145,
      151,
      153,
      154,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175
    ],
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      21,
      22,
      32,
      33,
      35,
      41,
      43,
      44,
      54,
      55,
      59,
      60,
      61,
      65,
      66,
      70,
      71,
      72,
      76,
      77,
      81,
      82,
      83,
      97,
      88,
      92,
      93,
      94,
      98,
      99,
      109,
      110,
      112,
      118,
      120,
      121,
      131,
      132,
      142,
      143,
      153,
      154,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175
    ],
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      21,
      22,
      32,
      33,
      43,
      44,
      54,
      55,
      65,
      66,
      76,
      77,
      97,
      88,
      98,
      99,
      109,
      110,
      120,
      121,
      131,
      132,
      142,
      143,
      153,
      154,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175
    ],
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      21,
      22,
      32,
      33,
      35,
      36,
      40,
      41,
      43,
      44,
      47,
      51,
      54,
      55,
      59,
      60,
      61,
      65,
      66,
      70,
      71,
      72,
      76,
      77,
      81,
      82,
      83,
      97,
      88,
      92,
      93,
      94,
      98,
      99,
      102,
      106,
      109,
      110,
      112,
      113,
      117,
      118,
      120,
      121,
      131,
      132,
      142,
      143,
      153,
      154,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175
    ],
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      21,
      22,
      24,
      30,
      32,
      33,
      37,
      38,
      43,
      44,
      48,
      49,
      54,
      55,
      59,
      60,
      65,
      66,
      70,
      71,
      76,
      77,
      80,
      81,
      82,
      83,
      87,
      88,
      91,
      92,
      93,
      94,
      98,
      99,
      103,
      104,
      109,
      110,
      114,
      115,
      120,
      121,
      125,
      126,
      131,
      132,
      136,
      137,
      142,
      143,
      145,
      151,
      153,
      154,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175
    ],

    //Medium
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
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
      129,
      140,
      151,
      103,
      114,
      125,
      105,
      116,
      127,
      147,
      148,
      149
    ],
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      21,
      22,
      27,
      32,
      33,
      43,
      44,
      46,
      47,
      48,
      49,
      50,
      51,
      52,
      54,
      55,
      65,
      66,
      76,
      77,
      78,
      79,
      80,
      81,
      82,
      83,
      84,
      85,
      87,
      88,
      98,
      99,
      101,
      102,
      103,
      105,
      106,
      107,
      108,
      109,
      110,
      120,
      121,
      122,
      131,
      132,
      133,
      137,
      140,
      142,
      143,
      148,
      153,
      154,
      160,
      162,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175
    ],
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
      0,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      13,
      15,
      21,
      22,
      24,
      26,
      32,
      33,
      35,
      37,
      41,
      43,
      44,
      46,
      52,
      54,
      55,
      57,
      59,
      61,
      65,
      66,
      68,
      70,
      72,
      75,
      76,
      77,
      79,
      81,
      83,
      85,
      87,
      88,
      92,
      94,
      96,
      98,
      99,
      101,
      103,
      109,
      110,
      112,
      114,
      116,
      118,
      120,
      121,
      123,
      125,
      127,
      129,
      131,
      132,
      134,
      136,
      138,
      142,
      143,
      145,
      149,
      152,
      153,
      154,
      156,
      159,
      160,
      163,
      164,
      165,
      171,
      175
    ],
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      22,
      23,
      24,
      25,
      28,
      29,
      30,
      32,
      33,
      44,
      48,
      49,
      55,
      59,
      60,
      65,
      78,
      79,
      80,
      81,
      83,
      86,
      94,
      95,
      96,
      97,
      99,
      100,
      103,
      110,
      113,
      120,
      121,
      124,
      127,
      131,
      132,
      137,
      143,
      144,
      149,
      154,
      155,
      158,
      159,
      160,
      161,
      162,
      163,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175
    ],
    [
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
      21,
      32,
      43,
      54,
      65,
      76,
      87,
      98,
      109,
      120,
      131,
      142,
      153,
      164,
      175,
      174,
      173,
      172,
      171,
      170,
      169,
      168,
      167,
      166,
      165,
      154,
      143,
      132,
      121,
      110,
      99,
      88,
      77,
      66,
      55,
      44,
      33,
      22,
      11,
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
      21,
      22,
      24,
      30,
      32,
      33,
      37,
      38,
      43,
      44,
      48,
      49,
      54,
      55,
      65,
      66,
      76,
      77,
      80,
      81,
      82,
      83,
      87,
      88,
      91,
      92,
      93,
      94,
      98,
      99,
      109,
      110,
      120,
      121,
      125,
      126,
      131,
      132,
      136,
      137,
      142,
      143,
      145,
      151,
      153,
      154,
      164,
      165,
      166,
      167,
      168,
      169,
      170,
      171,
      172,
      173,
      174,
      175
    ],
  ];

  late List<int> food = [];

  @override
  void initState() {
    super.initState();
    reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            // flex: MediaQuery.of(context).size.height.toInt() ~/ 170.857,
            flex: 10,
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
                    // childAspectRatio: 1.1,
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
                    } else if (barriers[mazeNum].contains(index)) {
                      return MyPixel(
                        innerColor: Colors.blue[800]!,
                        outerColor: Colors.blue[900]!,
                      );
                    } else if (food.contains(index)) {
                      return const MyPixel(
                        innerColor: Colors.yellow,
                        outerColor: Colors.black,
                      );
                    } else {
                      return const MyPixel(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // restart button
                GestureDetector(
                  onTap: () {
                    reset();
                  },
                  child: const Icon(
                    Icons.restart_alt,
                    color: Colors.white,
                  ),
                ),
                // displaying the score
                Text(
                  "Score: $score",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                // play/pause buttons
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
                    : GestureDetector(
                        onTap: () {
                          gameStarted = true;
                          if (firstRound) {
                            play();
                            firstRound = false;
                          }
                        },
                        child: const Text(
                          'Start',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void reset() {
    setState(() {
      // Initial positions
      playerPos = numberInRow * 13 + 3;
      ghost1Pos = numberInRow * 12 - 2;
      ghost2Pos = numberInRow + 1;
      ghost3Pos = numberInRow * 5 + 1;

      // Initial directions
      playerDirection = "right";
      ghost1Direction = "left";
      ghost2Direction = "right";
      ghost3Direction = "down";

      // Choose a random maze
      mazeNum = Random().nextInt(barriers.length);

      paused = false;
      gameStarted = false;
      gameOver = false;

      mouthClosed = false;
      score = 0;
      food.clear();
      getFood();
      score = food.length;
      food.clear();
    });
  }

  // Get the food's initial position.
  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers[mazeNum].contains(i)) {
        food.add(i);
      }
    }
  }

  void play() {
    // Moving the player
    Timer.periodic(const Duration(milliseconds: 170), (_) {
      if (!gameOver && gameStarted) {
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
      }
    });

    // Moving the ghosts.
    Timer.periodic(
      const Duration(milliseconds: 600),
      (_) {
        if (!gameOver && !paused && gameStarted) {
          moveGhost1();
          moveGhost2();
          moveGhost3();
        }
      },
    );

    // Checking winning/losing scenarios
    Timer.periodic(const Duration(milliseconds: 10), (_) {
      if (!gameOver && gameStarted) {
        if (playerPos == ghost1Pos ||
            playerPos == ghost2Pos ||
            playerPos == ghost3Pos ||
            food.isEmpty) {
          gameOver = true;
          mouthClosed = false;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  title: food.isEmpty
                      ? const Center(child: Text("Level completed"))
                      : const Center(child: Text("Game Over!")),
                  content: food.isEmpty
                      ? const Text("Congratulations!")
                      : Text("Your Score : $score"),
                  // contentPadding: const EdgeInsets.only(top: 10),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Restart'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        reset();
                      },
                    ),
                  ],
                );
              });
        }
      }
    });
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
    if (!barriers[mazeNum].contains(index)) {
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
