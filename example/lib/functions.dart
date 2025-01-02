String formatTime(int milliseconds) {
  String formatDigits(
    int n, {
    required int digits,
  }) {
    return n.toString().padLeft(digits, '0');
  }

  final duration = Duration(milliseconds: milliseconds);
  final formattedMinutes = formatDigits(
    duration.inMinutes.remainder(60),
    digits: 2,
  );
  final formattedSeconds = formatDigits(
    duration.inSeconds.remainder(60),
    digits: 2,
  );
  final formattedMillis = formatDigits(
    duration.inMilliseconds.remainder(1000),
    digits: 3,
  );
  return '$formattedMinutes:$formattedSeconds.$formattedMillis';
}
