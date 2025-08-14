import 'dart:async';
import 'package:flutter/material.dart';

class BlinkingDot extends StatelessWidget {
  final double size;
  final Color color;
  final Duration period;

  const BlinkingDot({
    super.key,
    this.size = 20,
    this.color = Colors.red,
    this.period = const Duration(milliseconds: 2000),
  });

  @override
  Widget build(BuildContext context) {
    final Duration halfPeriod = period ~/ 2;
    return StreamBuilder<int>(
      stream: Stream.periodic(halfPeriod, (int count) => count),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        final bool visible = ((snapshot.data ?? 0) % 2) == 0;
        return AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: halfPeriod,
          curve: Curves.easeInOut,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
