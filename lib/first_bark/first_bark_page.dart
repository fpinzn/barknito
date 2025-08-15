import 'package:barknito/first_bark/base_bark_page.dart';
import 'package:flutter/material.dart';

import 'package:sound_classification/sound_classification_flutter_plugin.dart';
import 'package:barknito/sound_eventization/sound_events_manager.dart';
import 'package:barknito/first_bark/first_bark_state.dart';
import 'package:barknito/first_bark/blinking_dot.dart';
import 'package:barknito/ui/typography.dart';

class FirstBarkPage extends BaseBarkPage {
  final PageController pageController;
  const FirstBarkPage({super.key, required this.pageController})
      : super(pageController: pageController);

  @override
  State<FirstBarkPage> createState() => _FirstBarkPageState();
}

class _FirstBarkPageState extends BaseBarkPageState<FirstBarkPage> {
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
    _state = FirstBarkState(pageController: widget.pageController);
    _state.startSession();
    _stateListener = () => setState(() {});
    _state.addListener(_stateListener);
  }

  void _teardownGameState() {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BlinkingDot(),
              ],
            ),
            const SizedBox(height: 32),
            Image.asset('assets/images/fire.png'),
            const NarrationWhite(
              'Summon the loud spirit out of him, we\'ll wait by the fire',
            ),
          ],
        ),
      ),
    );
  }
}
