import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/me/albemala/native_video_player/Api.g.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Classes/Api.g.swift',
    swiftOptions: SwiftOptions(),
    // copyrightHeader: 'pigeons/copyright.txt',
    // dartPackageName: 'pigeon_example_package',
  ),
)

// ---

enum VideoSourceType {
  asset,
  file,
  network,
}

class VideoSource {
  final String path;
  final VideoSourceType type;
  final Map<String, String>? headers;

  VideoSource({
    required this.path,
    required this.type,
    this.headers,
  });
}

class VideoInfo {
  final int height;
  final int width;
  final int duration;

  VideoInfo({
    required this.height,
    required this.width,
    required this.duration,
  });
}

enum PlaybackStatus {
  playing,
  paused,
  stopped,
}

@HostApi()
abstract class NativeVideoPlayerHostApi {
  void loadVideo(VideoSource source);

  VideoInfo getVideoInfo();

  void play(double speed);

  void pause();

  void stop();

  bool isPlaying();

  void seekTo(int position);

  int getPlaybackPosition();

  void setVolume(double volume);

  double getVolume();

  void setPlaybackSpeed(double speed);

  double getPlaybackSpeed();
}

sealed class PlaybackEvent {
  const PlaybackEvent();
}

class PlaybackStatusChangedEvent extends PlaybackEvent {
  final PlaybackStatus status;

  const PlaybackStatusChangedEvent(this.status);
}

class PlaybackPositionChangedEvent extends PlaybackEvent {
  final int position;

  const PlaybackPositionChangedEvent(this.position);
}

class PlaybackSpeedChangedEvent extends PlaybackEvent {
  final double speed;

  const PlaybackSpeedChangedEvent(this.speed);
}

class VolumeChangedEvent extends PlaybackEvent {
  final double volume;

  const VolumeChangedEvent(this.volume);
}

/// Emitted when the video loaded successfully and it's ready to play.
/// At this point, [videoInfo] is available.
class PlaybackReadyEvent extends PlaybackEvent {
  const PlaybackReadyEvent();
}

class PlaybackEndedEvent extends PlaybackEvent {
  const PlaybackEndedEvent();
}

class PlaybackErrorEvent extends PlaybackEvent {
  final String errorMessage;

  const PlaybackErrorEvent(this.errorMessage);
}

@FlutterApi()
abstract class NativeVideoPlayerFlutterApi {
  void onPlaybackEvent(PlaybackEvent event);
}
