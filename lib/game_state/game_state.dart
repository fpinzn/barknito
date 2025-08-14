import 'package:barknito/game_state/interaction_event.dart';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  static const int BARK_WINDOW_MS = 500;

  bool sessionActive = false;
  List<InteractionEvent<String>> soundClassificationHistory = [];
  late String gameName;
  late int tasksRequired;

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
            if (e.value.startsWith('dog')) {
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
}
