class Trial {
  final int? targetDurationMs;
  final int? durationMs;
  final bool successful;

  Trial({required this.successful, this.targetDurationMs, this.durationMs});

  static Trial fromJson(Map<String, dynamic> json) => Trial(
        successful: json['successful'],
        targetDurationMs: json['target_duration'],
        durationMs: json['duration'],
      );

  Map<String, dynamic> toJson() => {
        'successful': successful,
        'target_duration': targetDurationMs,
        'duration': durationMs,
      };

  @override
  String toString() {
    return "{successful: $successful, targetDurationMs: $targetDurationMs, durationMs: $durationMs}";
  }

  Map<String, dynamic> toSimplifiedRelativeJson(DateTime referenceTime) {
    return {
      'successful': successful,
      'target_duration': targetDurationMs,
      'duration': durationMs,
    };
  }
}
