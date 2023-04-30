import 'package:flutter/material.dart';

class Ghost extends StatelessWidget {
  const Ghost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        'images/ghost.png',
      ),
    );
    ;
  }
}
