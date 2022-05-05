import 'playback_status.dart';

class PlaybackInfo {
  final PlaybackStatus status;
  final int position;
  final double positionFraction;
  final double volume;
  final String? error;

  PlaybackInfo({
    required this.status,
    required this.position,
    required this.positionFraction,
    required this.volume,
    this.error,
  });
}
