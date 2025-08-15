import 'dart:async';

import 'package:barknito/five_barks/five_barks_state.dart';
import 'package:barknito/game_state/game_state.dart';
import 'package:barknito/game_state/user_instruction.dart';
import 'package:barknito/util.dart';

class FiveBarksCycle {
  FiveBarksState state;
  FiveBarksCycle({required this.state});
  Timer? timer;
  void start() {
    state.setUserInstruction(UserInstruction.makeDogBark);
    timer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      cycle(state, timer);
    });
  }

  void cycle(FiveBarksState state, Timer timer) {
    switch (state.userInstruction) {
      case UserInstruction.zero:
        state.setUserInstruction(UserInstruction.makeDogBark);
      case UserInstruction.makeDogBark:
        if (state.isBarking()) {
          state.addTaskCompleted(GameState.TASK_BARK);
          state.setUserInstruction(UserInstruction.reward);
        }
        break;
      case UserInstruction.reward:
        if (state.rewardProgress! >= 1.0) {
          state.setUserInstruction(UserInstruction.makeDogSilence);
        }
        break;
      case UserInstruction.restartSilence:
        state.setUserInstruction(UserInstruction.makeDogSilence);
        break;
      case UserInstruction.makeDogSilence:
        if (state.silenceProgress! >= 1.0) {
          state.addTaskCompleted(GameState.TASK_BARK_REWARD_SILENCE_CYCLE);
          state.setUserInstruction(UserInstruction.makeDogBark);
        }
        if (barkBeforeSilenceFinished(state)) {
          state.setUserInstruction(UserInstruction.restartSilence);
        }

        break;
    }

    // if (state.isBarking()) {
    //   state.addTaskCompleted(GameState.BARK_TASK_NAME);
    // } else {
    //   state.addTaskCompleted(GameState.SILENCE_TASK_NAME);
    // }

    state.asyncNotifyListeners("cycle");
  }

  bool barkBeforeSilenceFinished(FiveBarksState state) {
    final lastValidBarkTime = state.lastValidBark?.time;
    final startSilenceTime = state.userInstructionHistory.last.time;

    if (lastValidBarkTime!.isAfter(startSilenceTime) &&
        state.silenceProgress! < 1.0) {
      return true;
    }
    return false;
  }
}
