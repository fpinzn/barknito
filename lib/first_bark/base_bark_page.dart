import 'package:flutter/material.dart';

import 'package:sound_classification/sound_classification_flutter_plugin.dart';
import 'package:barknito/sound_eventization/sound_events_manager.dart';
import 'package:barknito/first_bark/first_bark_state.dart';

abstract class BaseBarkPage extends StatefulWidget {
  final PageController pageController;
  const BaseBarkPage({super.key, required this.pageController});
}

abstract class BaseBarkPageState<T extends BaseBarkPage> extends State<T> {
  late final BarkDetectionManager _barkDetectionManager;
  late final FirstBarkState _state;
  late final VoidCallback _stateListener;

  @override
  void initState() {
    super.initState();
    _setupGameState();
    _setupDetectionManager();
  }

  @override
  void dispose() {
    _barkDetectionManager.dispose();
    _teardownGameState();
    super.dispose();
  }

  void _setupGameState() {
    print('setupGameState');
    _state = FirstBarkState(pageController: widget.pageController);
    _state.startSession();
    _stateListener = () => setState(() {});
    _state.addListener(_stateListener);
  }

  void _teardownGameState() {
    print('teardownGameState');
    _state.removeListener(_stateListener);
    _state.endSession();
  }

  void _setupDetectionManager() {
    _barkDetectionManager = BarkDetectionManager(
      SoundClassificationFlutterPlugin(),
      gameState: _state,
      consecutiveWindowsToTrigger: 2,
      probabilityThreshold: 0.6,
    );
    _barkDetectionManager.start();
  }
}
