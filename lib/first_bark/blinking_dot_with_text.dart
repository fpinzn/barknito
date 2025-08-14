import 'dart:async';
import 'package:flutter/material.dart';

class BlinkingDotWithText extends StatelessWidget {
  final String text;
  final double dotSize;
  final Color dotColor;
  final Duration period;
  final double spacing;
  final TextStyle? textStyle;

  const BlinkingDotWithText({
    super.key,
    required this.text,
    this.dotSize = 20,
    this.dotColor = Colors.red,
    this.period = const Duration(milliseconds: 2000),
    this.spacing = 12,
    this.textStyle,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: spacing),
              Text(text, style: textStyle),
            ],
          ),
        );
      },
    );
  }
}
