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
    return Center(
      child: SingleChildScrollView(
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
      ),
    );
  }
}

class VideoCarouselView extends StatelessWidget {
  final void Function(ExampleVideoSource) onVideoSourceSelected;

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
                  final videoSource = await VideoSource.init(
                    type: videoSources[index].type,
                    path: videoSources[index].path,
                    headers: videoSources[index].headers,
                  );
                  await controller.loadVideoSource(videoSource);
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

class VideoPlayerView extends StatefulWidget {
  final ExampleVideoSource videoSource;

  const VideoPlayerView({
    super.key,
    required this.videoSource,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  NativeVideoPlayerController? _controller;

  bool isAutoplayEnabled = false;
  bool isPlaybackLoopEnabled = false;

  @override
  void didUpdateWidget(VideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoSource != widget.videoSource) {
      _loadVideoSource();
    }
  }

  Future<void> _initController(NativeVideoPlayerController controller) async {
    _controller = controller;

    _controller?. //
        onPlaybackStatusChanged
        .addListener(_onPlaybackStatusChanged);
    _controller?. //
        onPlaybackPositionChanged
        .addListener(_onPlaybackPositionChanged);
    _controller?. //
        onPlaybackSpeedChanged
        .addListener(_onPlaybackSpeedChanged);
    _controller?. //
        onVolumeChanged
        .addListener(_onPlaybackVolumeChanged);
    _controller?. //
        onPlaybackReady
        .addListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .addListener(_onPlaybackEnded);

    await _loadVideoSource();
  }

  Future<void> _loadVideoSource() async {
    final videoSource = await _createVideoSource();
    await _controller?.loadVideoSource(videoSource);
  }

  Future<VideoSource> _createVideoSource() async {
    return VideoSource.init(
      path: widget.videoSource.path,
      type: widget.videoSource.type,
      headers: widget.videoSource.headers,
    );
  }

  @override
  void dispose() {
    _controller?. //
        onPlaybackStatusChanged
        .removeListener(_onPlaybackStatusChanged);
    _controller?. //
        onPlaybackPositionChanged
        .removeListener(_onPlaybackPositionChanged);
    _controller?. //
        onPlaybackSpeedChanged
        .removeListener(_onPlaybackSpeedChanged);
    _controller?. //
        onVolumeChanged
        .removeListener(_onPlaybackVolumeChanged);
    _controller?. //
        onPlaybackReady
        .removeListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .removeListener(_onPlaybackEnded);
    _controller = null;
    super.dispose();
  }

  void _onPlaybackReady() {
    setState(() {});
    if (isAutoplayEnabled) {
      _controller?.play();
    }
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
                setState(() => isAutoplayEnabled = value ?? false);
              },
            ),
            const Text('Autoplay'),
            const SizedBox(width: 24),
            Checkbox(
              value: isPlaybackLoopEnabled,
              onChanged: (value) {
                setState(() => isPlaybackLoopEnabled = value ?? false);
              },
            ),
            const Text('Playback loop'),
          ],
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: NativeVideoPlayerView(
            onViewReady: _initController,
          ),
        ),
        Slider(
          // min: 0,
          max: (_controller?.videoInfo?.duration ?? 0).toDouble(),
          value: (_controller?.playbackInfo?.position ?? 0).toDouble(),
          onChanged: (value) => _controller?.seekTo(value.toInt()),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              formatDuration(
                Duration(seconds: _controller?.playbackInfo?.position ?? 0),
              ),
            ),
            const Spacer(),
            Text(
              formatDuration(
                Duration(seconds: _controller?.videoInfo?.duration ?? 0),
              ),
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
              onPressed: () => _controller?.seekBackward(5),
            ),
            IconButton(
              icon: const Icon(Icons.fast_forward),
              onPressed: () => _controller?.seekForward(5),
            ),
            const Spacer(),
            _buildPlaybackStatusView(),
          ],
        ),
        Row(
          children: [
            Text('''
Volume: ${_controller?.playbackInfo?.volume.toStringAsFixed(2)}'''),
            Expanded(
              child: Slider(
                value: _controller?.playbackInfo?.volume ?? 0,
                onChanged: (value) => _controller?.setVolume(value),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text('''
Speed: ${_controller?.playbackInfo?.speed.toStringAsFixed(2)}'''),
            Expanded(
              child: Slider(
                value: _controller?.playbackInfo?.speed ?? 1,
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
    switch (_controller?.playbackInfo?.status) {
      case PlaybackStatus.playing:
        return Icon(Icons.play_arrow, size: size, color: color);
      case PlaybackStatus.paused:
        return Icon(Icons.pause, size: size, color: color);
      case PlaybackStatus.stopped:
        return Icon(Icons.stop, size: size, color: color);
      default:
        return Container();
    }
  }
}
