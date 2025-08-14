import 'dart:async';
import 'package:barknito/game_state/game_state.dart';
import 'package:sound_classification/sound_classification_flutter_plugin.dart';

class BarkDetectionManager {
  final SoundClassificationFlutterPlugin _soundClassificationFlutterPlugin;
  final GameState? _gameState;
  StreamSubscription<Map<String, double>>? _classificationSubscription;
  final StreamController<Map<String, double>> _dogClassificationsController =
      StreamController<Map<String, double>>.broadcast();
  final StreamController<String> _dogDetectionsController =
      StreamController<String>.broadcast();
  final StreamController<String> _speechDetectionsController =
      StreamController<String>.broadcast();
  final StreamController<Map<String, double>> _allClassificationsController =
      StreamController<Map<String, double>>.broadcast();

  List<String> _dogClasses = [];
  List<String> _speechClasses = [];
  final Map<String, double> _lastDogProbabilities = {};
  final Map<String, int> _aboveThresholdStreaks = {};
  final Map<String, int> _speechAboveThresholdStreaks = {};

  /// Number of consecutive windows required to trigger an event.
  final int consecutiveWindowsToTrigger;

  /// Probability threshold that must be met or exceeded.
  final double probabilityThreshold;

  bool _started = false;

  BarkDetectionManager(
    this._soundClassificationFlutterPlugin, {
    GameState? gameState,
    this.consecutiveWindowsToTrigger = 2,
    this.probabilityThreshold = 0.6,
  }) : _gameState = gameState;

  /// Stream of class probabilities for dog-prefixed classes only (continuous values per window).
  Stream<Map<String, double>> get dogClassifications =>
      _dogClassificationsController.stream;

  /// Stream of all class probabilities from the plugin per window.
  Stream<Map<String, double>> get allClassifications =>
      _allClassificationsController.stream;

  /// Stream of eventified dog detections. Emits the class name when it stays
  /// above [probabilityThreshold] for [consecutiveWindowsToTrigger] consecutive windows.
  Stream<String> get dogDetections => _dogDetectionsController.stream;

  /// Stream of eventified speech detections using the same thresholding logic.
  Stream<String> get speechDetections => _speechDetectionsController.stream;

  /// The list of available classes that start with the 'dog' prefix.
  List<String> get dogClasses => List.unmodifiable(_dogClasses);

  /// Starts sound classification, emits continuous dog probabilities and eventified detections.
  Future<void> start() async {
    if (_started) return;
    _started = true;
    try {
      await _discoverDogClasses();
      _initializeCachesForClasses();
      _attachClassificationListener();
      _startPlugin();
    } catch (e) {
      // Reset started state on failure so caller can retry
      _started = false;
      rethrow;
    }
  }

  Future<void> _discoverDogClasses() async {
    final availableClasses =
        await _soundClassificationFlutterPlugin.listSoundClasses() ??
            <String>[];
    _dogClasses = availableClasses
        .where((c) => c.toLowerCase().startsWith('dog'))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    _speechClasses = availableClasses
        .where((c) => c.toLowerCase().startsWith('speech'))
        .toList()
      ..sort((a, b) => a.compareTo(b));
  }

  void _initializeCachesForClasses() {
    _lastDogProbabilities.clear();
    _aboveThresholdStreaks.clear();
    _speechAboveThresholdStreaks.clear();
    for (final c in _dogClasses) {
      _lastDogProbabilities[c] = 0.0;
      _aboveThresholdStreaks[c] = 0;
    }
    for (final c in _speechClasses) {
      _speechAboveThresholdStreaks[c] = 0;
    }
    _emitProbabilitiesSnapshot();
  }

  void _attachClassificationListener() {
    _classificationSubscription?.cancel();
    _classificationSubscription = _soundClassificationFlutterPlugin
        .classifications
        .listen(_processClassificationEvent);
  }

  void _processClassificationEvent(Map<String, double> event) {
    // Broadcast raw classifications for all classes
    _allClassificationsController.add(Map<String, double>.from(event));

    // Update dog-only state, emit detections and dog probabilities
    for (final className in _dogClasses) {
      final value = event[className] ?? 0.0;
      _updateDogStateAndMaybeEmit(className, value);
    }

    // Update speech detection streaks and emit
    for (final className in _speechClasses) {
      final value = event[className] ?? 0.0;
      _updateSpeechStateAndMaybeEmit(className, value);
    }

    _emitProbabilitiesSnapshot();
  }

  void _updateDogStateAndMaybeEmit(String className, double value) {
    _lastDogProbabilities[className] = value;

    final currentStreak = _aboveThresholdStreaks[className] ?? 0;
    if (value >= probabilityThreshold) {
      final updated = currentStreak + 1;
      _aboveThresholdStreaks[className] = updated;
      if (updated == consecutiveWindowsToTrigger) {
        // Emit stream event
        _dogDetectionsController.add(className);
        // Push directly into game state if provided
        _gameState?.addSoundClassification(className);
        // Reset after emitting to avoid continuous firing; require a new streak
        _aboveThresholdStreaks[className] = 0;
      }
    } else {
      _aboveThresholdStreaks[className] = 0;
    }
  }

  void _updateSpeechStateAndMaybeEmit(String className, double value) {
    final currentStreak = _speechAboveThresholdStreaks[className] ?? 0;
    if (value >= probabilityThreshold) {
      final updated = currentStreak + 1;
      _speechAboveThresholdStreaks[className] = updated;
      if (updated == consecutiveWindowsToTrigger) {
        _speechDetectionsController.add(className);
        _gameState?.addSoundClassification(className);
        _speechAboveThresholdStreaks[className] = 0;
      }
    } else {
      _speechAboveThresholdStreaks[className] = 0;
    }
  }

  void _emitProbabilitiesSnapshot() {
    _dogClassificationsController
        .add(Map<String, double>.from(_lastDogProbabilities));
  }

  void _startPlugin() {
    _soundClassificationFlutterPlugin.start();
  }

  /// Stops sound classification and cancels internal subscriptions.
  void stop() {
    _classificationSubscription?.cancel();
    _classificationSubscription = null;
    _soundClassificationFlutterPlugin.stop();
    _started = false;
  }

  /// Releases resources. Call from widget dispose.
  void dispose() {
    stop();
    _dogClassificationsController.close();
    _dogDetectionsController.close();
    _speechDetectionsController.close();
    _allClassificationsController.close();
  }
}
