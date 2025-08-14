import 'package:barknito/game_state/game_state.dart';
import 'package:flutter/material.dart';

class FirstBarkState extends GameState {
  static const String FIRST_BARK_GAME_NAME = 'first_bark';
  final PageController pageController;
  FirstBarkState({required this.pageController})
      : super(FIRST_BARK_GAME_NAME, 1);

  addSoundClassification(String sound) {
    super.addSoundClassification(sound);
    if (sound.startsWith('dog')) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
