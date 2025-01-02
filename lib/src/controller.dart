import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:native_video_player/src/api.g.dart';
import 'package:native_video_player/src/utils/file.dart';

class NativeVideoPlayerController implements NativeVideoPlayerFlutterApi {
  late final NativeVideoPlayerHostApi _hostApi;

  final _eventsController = StreamController<PlaybackEvent>.broadcast();
  StreamSubscription<PlaybackEvent>? _eventSubscription;

  Timer? _playbackPositionTimer;

  VideoSource? _videoSource;
  VideoInfo? _videoInfo;
  PlaybackStatus _playbackStatus = PlaybackStatus.stopped;
  double _playbackSpeed = 1;
  double _volume = 1;
  int _playbackPosition = 0;

  /// A broadcast stream of playback events that can be listened to.
  ///
  /// This stream emits [PlaybackEvent] objects representing various
  /// playback-related events, such as status changes, position updates,
  /// speed changes, and more.
  Stream<PlaybackEvent> get events => _eventsController.stream;

  /// The video source that is currently loaded.
  ///
  /// Returns `null` if no video has been loaded yet.
  VideoSource? get videoSource => _videoSource;

  /// Retrieves the video information for the currently loaded video.
  ///
  /// Returns a [VideoInfo] object containing the height, width, and duration
  /// of the video.
  ///
  /// Return `null` if no video has been loaded yet.
  VideoInfo? get videoInfo => _videoInfo;

  /// The current playback status of the video.
  ///
  /// Represents whether the video is currently playing, paused, or stopped.
  PlaybackStatus get playbackStatus => _playbackStatus;

  /// The current playback speed of the video.
  ///
  /// A value of 1.0 represents normal playback speed.
  double get playbackSpeed => _playbackSpeed;

  /// The current volume level of the video.
  ///
  /// Ranges from 0.0 (muted) to 1.0 (full volume).
  double get volume => _volume;

  /// The current playback position of the video in milliseconds.
  ///
  /// Represents the current timestamp of the video being played.
  int get playbackPosition => _playbackPosition;

  /// Returns the current playback progress as a value between 0.0 and 1.0
  Future<double> get playbackProgress async {
    final duration = videoInfo?.duration ?? 0;
    if (duration == 0) return 0.0;
    return playbackPosition / duration;
  }

  /// NOTE: For internal use only.
  /// See [NativeVideoPlayerView.onViewReady] instead.
  @protected
  NativeVideoPlayerController(int viewId) {
    _hostApi = NativeVideoPlayerHostApi(
      messageChannelSuffix: viewId.toString(),
    );
    NativeVideoPlayerFlutterApi.setUp(
      this,
      messageChannelSuffix: viewId.toString(),
    );
    _eventSubscription = events.listen(_handlePlaybackEvent);
  }

  /// Disposes of the controller and releases any resources.
  void dispose() {
    _stopPlaybackPositionTimer();
    _eventSubscription?.cancel();
    _eventsController.close();
    NativeVideoPlayerFlutterApi.setUp(null);
  }

  /// NOTE: For internal use only.
  @protected
  @override
  void onPlaybackEvent(PlaybackEvent event) {
    _eventsController.add(event);
  }

  Future<void> _handlePlaybackEvent(PlaybackEvent event) async {
    switch (event) {
      case PlaybackStatusChangedEvent():
        _playbackStatus = event.status;
      case PlaybackSpeedChangedEvent():
        _playbackSpeed = event.speed;
      case VolumeChangedEvent():
        _volume = event.volume;
      case PlaybackPositionChangedEvent():
        _playbackPosition = event.position;
      case PlaybackReadyEvent():
        _videoInfo = await _hostApi.getVideoInfo();
      case PlaybackEndedEvent():
      case PlaybackErrorEvent():
    }
  }

  /// Loads a new video source.
  Future<void> loadVideo(VideoSource source) async {
    final path = source.type == VideoSourceType.asset
        ? (await loadAssetFile(source.path)).path
        : source.path;
    final actualSource = VideoSource(
      path: path,
      type: source.type,
      headers: source.headers,
    );

    await stop();
    await _hostApi.loadVideo(actualSource);
    _videoSource = videoSource;
  }

  /// Starts/resumes the playback of the video.
  Future<void> play() async {
    await _hostApi.play(playbackSpeed);
    await setVolume(volume);
    _startPlaybackPositionTimer();
    _setPlaybackStatus(PlaybackStatus.playing);
  }

  /// Pauses the playback of the video.
  /// Use [play] to resume the playback from the paused position.
  Future<void> pause() async {
    await _hostApi.pause();
    _stopPlaybackPositionTimer();
    _setPlaybackStatus(PlaybackStatus.paused);
  }

  /// Stops the playback of the video.
  /// The playback position is reset to 0.
  /// Use [play] to start the playback from the beginning.
  Future<void> stop() async {
    await _hostApi.stop();
    _stopPlaybackPositionTimer();
    _setPlaybackStatus(PlaybackStatus.stopped);
    _emitPositionEvent(0);
  }

  /// Returns true if the video is playing, or false if it's stopped or paused.
  Future<bool> isPlaying() async {
    try {
      return await _hostApi.isPlaying();
    } catch (exception) {
      return false;
    }
  }

  /// Moves the playback position to the given position in milliseconds.
  Future<void> seekTo(int milliseconds) async {
    var position = milliseconds;
    if (position < 0) position = 0;
    final duration = videoInfo?.duration ?? 0;
    if (position > duration) position = duration;
    await _hostApi.seekTo(position);
    _emitPositionEvent(position);
  }

  /// Seeks the video forward by the given number of milliseconds.
  Future<void> seekForward(int milliseconds) async {
    final duration = videoInfo?.duration ?? 0;
    final position = min(_playbackPosition + milliseconds, duration);
    await seekTo(position);
  }

  /// Seeks the video backward by the given number of milliseconds.
  Future<void> seekBackward(int milliseconds) async {
    final position = max(0, _playbackPosition - milliseconds);
    await seekTo(position);
  }

  /// Sets the playback speed.
  /// The default value is 1.
  Future<void> setPlaybackSpeed(double speed) async {
    if (playbackStatus == PlaybackStatus.playing) {
      await _hostApi.setPlaybackSpeed(speed);
    }
    onPlaybackEvent(PlaybackSpeedChangedEvent(speed: speed));
  }

  /// Sets the volume of the player.
  Future<void> setVolume(double volume) async {
    await _hostApi.setVolume(volume);
    onPlaybackEvent(VolumeChangedEvent(volume: volume));
  }
}

extension SetPlaybackStatus on NativeVideoPlayerController {
  void _setPlaybackStatus(PlaybackStatus status) {
    onPlaybackEvent(PlaybackStatusChangedEvent(status: status));
  }
}

extension PlaybackPositionTimer on NativeVideoPlayerController {
  void _startPlaybackPositionTimer() {
    _stopPlaybackPositionTimer();
    _playbackPositionTimer ??= Timer.periodic(
      const Duration(milliseconds: 100),
      _onPlaybackPositionTimerChanged,
    );
  }

  void _stopPlaybackPositionTimer() {
    if (_playbackPositionTimer == null) return;
    _playbackPositionTimer!.cancel();
    _playbackPositionTimer = null;
  }

  Future<void> _onPlaybackPositionTimerChanged(Timer? timer) async {
    final position = await _hostApi.getPlaybackPosition();
    _emitPositionEvent(position);
  }

  void _emitPositionEvent(int position) {
    onPlaybackEvent(PlaybackPositionChangedEvent(position: position));
  }
}
