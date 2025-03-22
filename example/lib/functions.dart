String formatTime(Duration time) {
  String formatDigits(
    int n, {
    required int digits,
  }) {
    return n.toString().padLeft(digits, '0');
  }

  final formattedMinutes = formatDigits(
    time.inMinutes.remainder(60),
    digits: 2,
  );
  final formattedSeconds = formatDigits(
    time.inSeconds.remainder(60),
    digits: 2,
  );
  final formattedMillis = formatDigits(
    time.inMilliseconds.remainder(1000),
    digits: 3,
  );
  return '$formattedMinutes:$formattedSeconds.$formattedMillis';
}
