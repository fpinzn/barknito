import 'dart:convert';

import 'package:barknito/game_state/trial.dart';

class InteractionEvent<T> {
  T value;
  DateTime time;
  InteractionEvent(this.value, this.time);

  toJson() {
    return {'value': value.toString(), 'time': time.toIso8601String()};
  }

  toRelativeTimeJson(DateTime referenceTime) {
    String value_str;

    if (value is Enum) {
      value_str = (value as Enum).name;
    } else if (value is Trial) {
      final trial = (value as Trial).toSimplifiedRelativeJson(referenceTime);
      return {
        'value': trial,
        'time': time.difference(referenceTime).inMilliseconds
      };
    } else {
      value_str = value.toString();
    }
    return {
      'value': value_str,
      'time': time.difference(referenceTime).inMilliseconds
    };
  }

  @override
  String toString() {
    return "$time (${T.toString()}): $value";
  }
}
