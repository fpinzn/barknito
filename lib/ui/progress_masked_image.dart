import 'package:flutter/material.dart';

class ProgressMaskedImage extends StatelessWidget {
  final String assetPath;
  final double progress; // expected 0.0..1.0
  final double filledOpacity;
  final double unfilledOpacity;
  final BoxFit fit;

  const ProgressMaskedImage({
    super.key,
    required this.assetPath,
    required this.progress,
    this.filledOpacity = 1.0,
    this.unfilledOpacity = 0.2,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final double clampedProgress = progress.clamp(0.0, 1.0);
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: unfilledOpacity,
          child: Image.asset(assetPath, fit: fit),
        ),
        ClipRect(
          clipper: _ProgressClipper(clampedProgress),
          child: Opacity(
            opacity: filledOpacity,
            child: Image.asset(assetPath, fit: fit),
          ),
        ),
      ],
    );
  }
}

class _ProgressClipper extends CustomClipper<Rect> {
  final double progress; // 0..1
  _ProgressClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(covariant _ProgressClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
