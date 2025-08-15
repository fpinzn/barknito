import 'dart:math';

int tDiffNow(DateTime time) {
  return DateTime.now().difference(time).inMilliseconds;
}
