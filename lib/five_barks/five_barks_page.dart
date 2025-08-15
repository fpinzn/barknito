import 'package:barknito/five_barks/five_barks_state.dart';
import 'package:barknito/game_state/user_instruction.dart';
import 'package:barknito/ui/progress_masked_image.dart';
import 'package:flutter/material.dart';

import 'package:sound_classification/sound_classification_flutter_plugin.dart';
import 'package:barknito/sound_eventization/sound_events_manager.dart';
import 'package:barknito/first_bark/first_bark_state.dart';
import 'package:barknito/first_bark/blinking_dot.dart';
import 'package:barknito/ui/typography.dart';

class InstructionWidget extends StatelessWidget {
  final bool isActive;
  final String imagePath;
  final bool useOpacity;
  final double progress;
  const InstructionWidget({
    Key? key,
    required this.isActive,
    required this.imagePath,
    this.useOpacity = true,
    this.progress = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double activeSize = 200.0;
    const double inactiveSize = 100.0;
    final size = isActive ? activeSize : inactiveSize;

    Widget image = ProgressMaskedImage(
      assetPath: imagePath,
      progress: progress,
    );

    if (useOpacity) {
      image = Opacity(
        opacity: isActive ? 1.0 : 0.2,
        child: image,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: image,
    );
  }
}

class InstructionConfig {
  final String imagePath;
  final bool useOpacity;

  const InstructionConfig({
    required this.imagePath,
    this.useOpacity = true,
  });
}

class FiveBarksPage extends StatefulWidget {
  final PageController pageController;
  const FiveBarksPage({super.key, required this.pageController});

  @override
  State<FiveBarksPage> createState() => _FiveBarksPageState();
}

class _FiveBarksPageState extends State<FiveBarksPage> {
  late final BarkDetectionManager _barkDetectionManager;
  late final FiveBarksState _state;
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
    _state = FiveBarksState(pageController: widget.pageController);
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
            const BlinkingDot(),
            const SizedBox(height: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InstructionWidget(
                  isActive:
                      _state.userInstruction == UserInstruction.makeDogBark,
                  imagePath: 'assets/images/bark.png',
                  useOpacity: false,
                ),
                InstructionWidget(
                  isActive: _state.userInstruction == UserInstruction.reward,
                  imagePath: 'assets/images/reward.png',
                  progress: _state.rewardProgress ?? 1.0,
                ),
                // if (_state.userInstruction == UserInstruction.reward)
                //   LinearProgressIndicator(
                //     minHeight: 20,
                //     value: _state.rewardProgress,
                //     color: Colors.white,
                //     backgroundColor: Colors.white.withOpacity(0.2),
                //   ),
                InstructionWidget(
                  isActive: _state.userInstruction ==
                          UserInstruction.makeDogSilence ||
                      _state.userInstruction == UserInstruction.restartSilence,
                  imagePath: _state.isBarking()
                      ? 'assets/images/bark-black.png'
                      : 'assets/images/nito.png',
                  progress: _state.silenceProgress ?? 1.0,
                ),
                // if (_state.userInstruction == UserInstruction.makeDogSilence ||
                //     _state.userInstruction == UserInstruction.restartSilence)
                //   LinearProgressIndicator(
                //     value: _state.silenceProgress,
                //     color: Colors.white,
                //     backgroundColor: Colors.white.withOpacity(0.2),
                //   ),
              ],
            ),
            const NarrationWhite(
              'Five more barks. Each rewarded and followed by silence.',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image(
                      image: _state.tasksCompleted < 1
                          ? AssetImage('assets/images/nito.png')
                          : AssetImage('assets/images/bark.png')),
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image(
                      image: _state.tasksCompleted < 2
                          ? AssetImage('assets/images/nito.png')
                          : AssetImage('assets/images/bark.png')),
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image(
                      image: _state.tasksCompleted < 3
                          ? AssetImage('assets/images/nito.png')
                          : AssetImage('assets/images/bark.png')),
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image(
                      image: _state.tasksCompleted < 4
                          ? AssetImage('assets/images/nito.png')
                          : AssetImage('assets/images/bark.png')),
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image(
                      image: _state.tasksCompleted < 5
                          ? AssetImage('assets/images/nito.png')
                          : AssetImage('assets/images/bark.png')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
