import 'package:barknito/first_bark/blinking_dot_with_text.dart';
import 'package:barknito/ui/typography.dart';
import 'package:flutter/material.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BlinkingDotWithText(
                text: '(If your dog didn\'t bark, swipe up)',
                dotColor: Colors.black,
                dotSize: 10,
                spacing: 12,
              ),
              const SizedBox(height: 50),
              Center(child: Image.asset('assets/images/reward.png')),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: NarrationBlack(
                    'Some mana was offered to the loud spirit, and it was pleased'),
              ),
              const SizedBox(height: 50),
              const BlinkingDotWithText(
                text: '(Swipe down after rewarding your dog)',
                dotColor: Colors.black,
                dotSize: 10,
                spacing: 12,
              ),
            ],
          ),
        ));
  }
}
