import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final Color innerColor;
  final Color outerColor;
  final Widget? child;

  const MyBarrier(
      {Key? key,
      required this.innerColor,
      required this.outerColor,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(4),
          color: outerColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: innerColor,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
