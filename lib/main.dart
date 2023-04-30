import 'package:flutter/material.dart';
import 'package:pacman/ui/homePage.dart';

void main() {
  runApp(const Pacman());
}

class Pacman extends StatelessWidget {
  const Pacman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
