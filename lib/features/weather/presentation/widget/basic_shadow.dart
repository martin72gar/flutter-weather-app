import 'package:flutter/material.dart';

class BasicShadow extends StatelessWidget {
  final bool topDown;
  const BasicShadow({super.key, required this.topDown});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: topDown ? Alignment.topCenter : Alignment.bottomCenter,
            end: topDown ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent]),
      ),
    );
  }
}
