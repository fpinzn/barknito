import 'dart:async';
import 'dart:math';

import 'package:barknito/game_state/game_state.dart';
import 'package:barknito/game_state/user_instruction.dart';
import 'package:barknito/global_definitions.dart';
import 'package:barknito/five_barks/five_barks_cycle.dart';
import 'package:barknito/util.dart';
import 'package:flutter/material.dart';

class FiveBarksState extends GameState {
  static const String FIVE_BARKS_GAME_NAME = 'five_barks';
  static const int SILENCE_TIME_BEFORE_NEXT_BARK_MS = 7000;
  static const int REWARD_TIME_MS = 3000;
  final PageController pageController;
  late FiveBarksCycle cycle;
  int tasksRequired = 5;

  int timePassedMs = 0;

  // bool _advanced = false;
  FiveBarksState({required this.pageController})
      : super(FIVE_BARKS_GAME_NAME, 5) {
    cycle = FiveBarksCycle(state: this);
  }

  @override
  void startSession() {
    super.startSession();
    cycle.start();
  }

  void addTaskCompleted(String task) {
    super.addTaskCompleted(task);
    if (tasksCompleted >= tasksRequired) {
      endSession();
      pageController.nextPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    }
  }

  double? get silenceProgress {
    if (userInstruction == UserInstruction.makeDogSilence) {
      return tDiffNow(userInstructionHistory.last.time) /
          SILENCE_TIME_BEFORE_NEXT_BARK_MS;
    }
    return null;
  }

  double? get rewardProgress {
    if (userInstruction == UserInstruction.reward) {
      return tDiffNow(userInstructionHistory.last.time) / REWARD_TIME_MS;
    }
    return null;
  }
}
