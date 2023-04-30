import 'package:flutter/material.dart';

class Ghost extends StatelessWidget {
  final Image image;

  const Ghost({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: image,
    );
    ;
  }
}
