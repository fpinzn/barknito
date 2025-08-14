import 'package:flutter/material.dart';

import 'package:sound_classification/sound_classification_flutter_plugin.dart';
import 'package:barknito/sound_eventization/sound_events_manager.dart';
import 'package:barknito/first_bark/first_bark_state.dart';
import 'package:barknito/first_bark/blinking_dot.dart';
import 'package:barknito/typography.dart';

class FiveBarksPage extends StatefulWidget {
  final PageController pageController;
  const FiveBarksPage({super.key, required this.pageController});

  @override
  State<FiveBarksPage> createState() => _FiveBarksPageState();
}

class _FiveBarksPageState extends State<FiveBarksPage> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BlinkingDot(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/bark.png'),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/fire.png'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/bark.png'),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/fire.png'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/bark.png'),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/fire.png'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/bark.png'),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/fire.png'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/bark.png'),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/fire.png'),
                ),
              ],
            ),
            const NarrationWhite(
              'Five more barks with silence between them were required to prove intention',
            ),
          ],
        ),
      ),
    );
  }
}
