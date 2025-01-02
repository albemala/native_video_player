import 'dart:async';

import 'package:flutter/material.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:native_video_player_example/defines.dart';
import 'package:native_video_player_example/functions.dart';

class VideoPlayerScreenView extends StatefulWidget {
  const VideoPlayerScreenView({super.key});

  @override
  State<VideoPlayerScreenView> createState() => _VideoPlayerScreenViewState();
}

class _VideoPlayerScreenViewState extends State<VideoPlayerScreenView> {
  var _selectedVideoSource = videoSources.first;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: VideoPlayerView(
              videoSource: _selectedVideoSource,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 128,
            child: VideoCarouselView(
              onVideoSourceSelected: (videoSource) {
                setState(() {
                  _selectedVideoSource = videoSource;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  final VideoSource videoSource;

  const VideoPlayerView({
    super.key,
    required this.videoSource,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  NativeVideoPlayerController? _controller;
  StreamSubscription<void>? _eventsSubscription;

  bool isAutoplayEnabled = false;
  bool isPlaybackLoopEnabled = false;

  Future<void> _initController(NativeVideoPlayerController controller) async {
    _controller = controller;

    _eventsSubscription = _controller?.events.listen((event) {
      switch (event) {
        case PlaybackStatusChangedEvent():
          _onPlaybackStatusChanged();
        case PlaybackPositionChangedEvent():
          _onPlaybackPositionChanged();
        case PlaybackSpeedChangedEvent():
          _onPlaybackSpeedChanged();
        case VolumeChangedEvent():
          _onPlaybackVolumeChanged();
        case PlaybackReadyEvent():
          _onPlaybackReady();
        case PlaybackEndedEvent():
          _onPlaybackEnded();
        case PlaybackErrorEvent():
          _onPlaybackError(event);
      }
    });

    await _loadVideoSource();
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(VideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoSource != widget.videoSource) {
      _loadVideoSource();
    }
  }

  Future<void> _loadVideoSource() async {
    await _controller?.loadVideo(widget.videoSource);
    if (isAutoplayEnabled) {
      await _controller?.play();
    }
  }

  void _onPlaybackReady() {
    setState(() {});
  }

  void _onPlaybackStatusChanged() {
    setState(() {});
  }

  void _onPlaybackPositionChanged() {
    setState(() {});
  }

  void _onPlaybackSpeedChanged() {
    setState(() {});
  }

  void _onPlaybackVolumeChanged() {
    setState(() {});
  }

  void _onPlaybackEnded() {
    if (isPlaybackLoopEnabled) {
      _controller?.play();
    }
  }

  void _onPlaybackError(PlaybackErrorEvent event) {
    print('Playback error: ${event.errorMessage}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: isAutoplayEnabled,
              onChanged: (value) {
                if (value == null) return;
                setState(() => isAutoplayEnabled = value);
              },
            ),
            const Text('Autoplay'),
            const SizedBox(width: 24),
            Checkbox(
              value: isPlaybackLoopEnabled,
              onChanged: (value) {
                if (value == null) return;
                setState(() => isPlaybackLoopEnabled = value);
              },
            ),
            const Text('Playback loop'),
          ],
        ),
        const SizedBox(height: 4),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: NativeVideoPlayerView(
            onViewReady: _initController,
          ),
        ),
        Slider(
          // min: 0,
          max: (_controller?.videoInfo?.duration ?? 0).toDouble(),
          value: (_controller?.playbackPosition ?? 0).toDouble(),
          onChanged: (value) => _controller?.seekTo(value.toInt()),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              formatTime(_controller?.playbackPosition ?? 0),
            ),
            const Spacer(),
            Text(
              formatTime(_controller?.videoInfo?.duration ?? 0),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => _controller?.play(),
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () => _controller?.pause(),
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () => _controller?.stop(),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.fast_rewind),
              onPressed: () => _controller?.seekBackward(5000),
            ),
            IconButton(
              icon: const Icon(Icons.fast_forward),
              onPressed: () => _controller?.seekForward(5000),
            ),
            const Spacer(),
            _buildPlaybackStatusView(),
          ],
        ),
        Row(
          children: [
            Text('''
Volume: ${_controller?.volume.toStringAsFixed(2)}'''),
            Expanded(
              child: Slider(
                value: _controller?.volume ?? 0,
                onChanged: (value) => _controller?.setVolume(value),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text('''
Speed: ${_controller?.playbackSpeed.toStringAsFixed(2)}'''),
            Expanded(
              child: Slider(
                value: _controller?.playbackSpeed ?? 1,
                onChanged: (value) => _controller?.setPlaybackSpeed(value),
                min: 0.25,
                max: 2,
                divisions: (2 - 0.25) ~/ 0.25,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaybackStatusView() {
    const size = 16.0;
    final color = Colors.black.withOpacity(0.3);
    switch (_controller?.playbackStatus) {
      case PlaybackStatus.playing:
        return Icon(Icons.play_arrow, size: size, color: color);
      case PlaybackStatus.paused:
        return Icon(Icons.pause, size: size, color: color);
      case PlaybackStatus.stopped:
        return Icon(Icons.stop, size: size, color: color);
      case null:
        return const SizedBox.shrink();
    }
  }
}

class VideoCarouselView extends StatelessWidget {
  final void Function(VideoSource) onVideoSourceSelected;

  const VideoCarouselView({
    super.key,
    required this.onVideoSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: videoSources.length,
      itemBuilder: (context, index) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              NativeVideoPlayerView(
                onViewReady: (controller) async {
                  await controller.loadVideo(videoSources[index]);
                },
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    onVideoSourceSelected(videoSources[index]);
                  },
                  child: Container(),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 8);
      },
    );
  }
}
