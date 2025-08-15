import 'package:barknito/game_state/game_state.dart';
import 'package:barknito/global_definitions.dart';
import 'package:flutter/material.dart';

class FirstBarkState extends GameState {
  static const String FIRST_BARK_GAME_NAME = 'first_bark';
  final PageController pageController;
  bool _advanced = false;
  FirstBarkState({required this.pageController})
      : super(FIRST_BARK_GAME_NAME, 1);

  @override
  void addTaskCompleted(String task) {
    super.addTaskCompleted(task);
    if (task == GameState.TASK_BARK && !_advanced) {
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
    if (VALID_BARKS.contains(sound)) {
      addTaskCompleted(GameState.TASK_BARK);
    }
  }
}
