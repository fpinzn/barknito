import 'package:barknito/game_state/game_state.dart';
import 'package:flutter/material.dart';

class FiveBarksState extends GameState {
  static const String FIVE_BARKS_GAME_NAME = 'five_barks';
  final PageController pageController;
  bool _advanced = false;
  FiveBarksState({required this.pageController})
      : super(FIVE_BARKS_GAME_NAME, 5);

  @override
  void addTaskCompleted(String task) {
    super.addTaskCompleted(task);
    if (task == GameState.BARK_TASK_NAME && !_advanced) {
      _advanced = true;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  addSoundClassification(String sound) {
    super.addSoundClassification(sound);
    if (sound == 'dog') {
      addTaskCompleted(GameState.BARK_TASK_NAME);
    }
  }
}
