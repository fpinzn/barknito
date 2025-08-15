import 'package:barknito/game_state/interaction_event.dart';
import 'package:barknito/game_state/user_instruction.dart';
import 'package:barknito/global_definitions.dart';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  static const int BARK_WINDOW_MS = 500;
  static const String TASK_BARK = 'bark';
  // static const String TASK_REWARD = 'reward';
  static const String TASK_SILENCE = 'silence';
  static const String TASK_BARK_REWARD_SILENCE_CYCLE =
      'bark_reward_silence_cycle';

  bool sessionActive = false;
  List<InteractionEvent<String>> soundClassificationHistory = [];
  List<InteractionEvent<String>> tasksCompletedHistory = [];
  List<InteractionEvent<UserInstruction>> userInstructionHistory = [];

  late String gameName;
  late int tasksRequired;

  UserInstruction get userInstruction => userInstructionHistory.last.value;

  GameState(this.gameName, this.tasksRequired);

  void startSession() {
    sessionActive = true;
    notifyListeners();
  }

  void endSession() {
    sessionActive = false;
    notifyListeners();
  }

  void addSoundClassification(String sound) {
    soundClassificationHistory.add(InteractionEvent(sound, DateTime.now()));
    asyncNotifyListeners("addSoundClassification");
  }

  void addTaskCompleted(String task) {
    tasksCompletedHistory.add(InteractionEvent(task, DateTime.now()));
    asyncNotifyListeners("addTaskCompleted");
    if (tasksCompleted == tasksRequired) {
      endSession();
    }
  }

  int get tasksCompleted => tasksCompletedHistory.length;

  Future<void> asyncNotifyListeners(String caller) async {
    await Future.delayed(const Duration(milliseconds: 0));
    if (!sessionActive) {
    } else {
      notifyListeners();
    }
  }

  bool isBarking() {
    return soundClassificationHistory.isNotEmpty &&
        (() {
          final result = soundClassificationHistory.any((e) {
            if (VALID_BARKS.contains(e.value)) {
              final ms = DateTime.now().difference(e.time).inMilliseconds;
              if (ms <= BARK_WINDOW_MS) {
                return true;
              }
            }
            return false;
          });
          return result;
        })();
  }

  int? msSinceLastBark() {
    // Find the most recent valid bark sound event
    final last = lastValidBark;
    if (last != null) {
      return DateTime.now().difference(last.time).inMilliseconds;
    }
    return null;
  }

  InteractionEvent<String>? get lastValidBark {
    for (int i = soundClassificationHistory.length - 1; i >= 0; i--) {
      final event = soundClassificationHistory[i];
      if (VALID_BARKS.contains(event.value)) {
        return event;
      }
    }
    return null;
  }

  void setUserInstruction(UserInstruction instruction) {
    userInstructionHistory.add(InteractionEvent(instruction, DateTime.now()));
    asyncNotifyListeners("setUserInstruction");
  }
}
