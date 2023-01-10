// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:native_video_player/src/playback_status.dart';
import 'package:native_video_player/src/video_info.dart';

import 'platform_interface/native_video_player_api.dart';
import 'playback_info.dart';
import 'video_source.dart';

class NativeVideoPlayerController {
  late final NativeVideoPlayerApi _api;
  VideoSource? _videoSource;
  VideoInfo? _videoInfo;

  Timer? _playbackPositionTimer;

  double _volume = 0;

  PlaybackStatus get _playbackStatus => onPlaybackStatusChanged.value;

  int get _playbackPosition => onPlaybackPositionChanged.value;

  double get _playbackPositionFraction => videoInfo != null //
      ? _playbackPosition / videoInfo!.duration
      : 0;

  String? get _error => onError.value;

  /// Emitted when the video loaded successfully and it's ready to play.
  /// At this point, [videoInfo] and [playbackInfo] are available.
  final onPlaybackReady = ChangeNotifier();

  /// You can query the playback status with [playbackInfo]
  final onPlaybackStatusChanged = ValueNotifier<PlaybackStatus>(
    PlaybackStatus.stopped,
  );

  /// You can query the playback position with [playbackInfo]
  final onPlaybackPositionChanged = ValueNotifier<int>(0);

  /// Emitted when the video has finished playing.
  final onPlaybackEnded = ChangeNotifier();

  /// Emitted when a playback error occurs
  /// or when it's not possible to load the video source
  final onError = ValueNotifier<String?>(
    null,
  );

  /// The video source that is currently loaded.
  VideoSource? get videoSource => _videoSource;

  /// The video info about the current video source.
  VideoInfo? get videoInfo => _videoInfo;

  /// The playback info about the video being played.
  PlaybackInfo? get playbackInfo => PlaybackInfo(
        status: _playbackStatus,
        position: _playbackPosition,
        positionFraction: _playbackPositionFraction,
        volume: _volume,
        error: _error,
      );

  /// NOTE: For internal use only.
  /// See [NativeVideoPlayerView.onViewReady] instead.
  @protected
  NativeVideoPlayerController(int viewId) {
    _api = NativeVideoPlayerApi(
      viewId: viewId,
      onPlaybackReady: _onPlaybackReady,
      onPlaybackEnded: _onPlaybackEnded,
      onError: _onError,
    );
  }

  Future<void> _onPlaybackReady() async {
    _videoInfo = await _api.getVideoInfo();
    // Make sure the volume is reset to the correct value
    await setVolume(_volume);
    onPlaybackReady.notifyListeners();
  }

  Future<void> _onPlaybackEnded() async {
    await stop();
    onPlaybackEnded.notifyListeners();
  }

  void _onError(String? message) {
    onError.value = message;
  }

  // NOTE: For internal use only.
  @protected
  void dispose() {
    _stopPlaybackPositionTimer();
    _api.dispose();
  }

  /// Loads a new video source.
  ///
  /// NOTE: This method might throw an exception if the video source is invalid.
  Future<void> loadVideoSource(VideoSource videoSource) async {
    await stop();
    await _api.loadVideoSource(videoSource);
    _videoSource = videoSource;
  }

  /// Starts/resumes the playback of the video.
  ///
  /// NOTE: This method might throw an exception if the video cannot be played.
  Future<void> play() async {
    await _api.play();
    _startPlaybackPositionTimer();
    onPlaybackStatusChanged.value = PlaybackStatus.playing;
  }

  /// Pauses the playback of the video.
  /// Use [play] to resume the playback from the paused position.
  ///
  /// NOTE: This method might throw an exception if the video cannot be paused.
  Future<void> pause() async {
    await _api.pause();
    _stopPlaybackPositionTimer();
    onPlaybackStatusChanged.value = PlaybackStatus.paused;
  }

  /// Stops the playback of the video.
  /// The playback position is reset to 0.
  /// Use [play] to start the playback from the beginning.
  ///
  /// NOTE: This method might throw an exception if the video cannot be stopped.
  Future<void> stop() async {
    await _api.stop();
    _stopPlaybackPositionTimer();
    onPlaybackStatusChanged.value = PlaybackStatus.stopped;
    await _onPlaybackPositionTimerChanged(null);
  }

  /// Returns true if the video is playing, or false if it's stopped or paused.
  Future<bool> isPlaying() async {
    try {
      return await _api.isPlaying() ?? false;
    } catch (exception) {
      return false;
    }
  }

  /// Moves the playback position to the given position in seconds.
  ///
  /// NOTE: This method might throw an exception if the video cannot be seeked.
  Future<void> seekTo(int seconds) async {
    var position = seconds;
    if (seconds < 0) position = 0;
    final duration = videoInfo?.duration ?? 0;
    if (seconds > duration) position = duration;
    await _api.seekTo(position);
  }

  /// Seeks the video forward by the given number of seconds.
  Future<void> seekForward(int seconds) async {
    if (seconds < 0) return;
    if (seconds == 0) return;
    final duration = videoInfo?.duration ?? 0;
    final newPlaybackPosition = _playbackPosition + seconds > duration //
        ? duration
        : _playbackPosition + seconds;
    await seekTo(newPlaybackPosition);
  }

  /// Seeks the video backward by the given number of seconds.
  Future<void> seekBackward(int seconds) async {
    if (seconds < 0) return;
    if (seconds == 0) return;
    final newPlaybackPosition = _playbackPosition - seconds < 0 //
        ? 0
        : _playbackPosition - seconds;
    await seekTo(newPlaybackPosition);
  }

  /// Sets the volume of the player.
  ///
  /// NOTE: This method might throw an exception if the volume cannot be set.
  Future<void> setVolume(double volume) async {
    await _api.setVolume(volume);
    _volume = volume;
  }

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

  /// NOTE: This method can throw an exception
  /// if the playback position cannot be retrieved.
  Future<void> _onPlaybackPositionTimerChanged(Timer? timer) async {
    final position = await _api.getPlaybackPosition() ?? 0;
    onPlaybackPositionChanged.value = position;
  }
}
