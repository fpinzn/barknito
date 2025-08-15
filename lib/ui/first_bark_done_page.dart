import 'package:barknito/first_bark/blinking_dot.dart';
import 'package:barknito/ui/typography.dart';
import 'package:flutter/material.dart';

class FirstBarkDonePage extends StatelessWidget {
  const FirstBarkDonePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Image.asset('assets/images/bark.png')),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: NarrationBlack(
                    'The bestial and loud spirit filled the desert with its power'),
              ),
              const SizedBox(height: 50),
              const BlinkingDot(color: Colors.black),
            ],
          ),
        ));
  }
}
