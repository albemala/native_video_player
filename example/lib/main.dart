import 'dart:core';

import 'package:flutter/material.dart';
import 'package:native_video_player/native_video_player.dart';

class ExampleVideoSource {
  final String path;
  final VideoSourceType type;

  ExampleVideoSource({
    required this.path,
    required this.type,
  });
}

final videoSources = [
  ExampleVideoSource(path: 'assets/video/01.mp4', type: VideoSourceType.asset),
  ExampleVideoSource(path: 'assets/video/02.mp4', type: VideoSourceType.asset),
  ExampleVideoSource(path: 'assets/video/03.mp4', type: VideoSourceType.asset),
  ExampleVideoSource(path: 'assets/video/04.mp4', type: VideoSourceType.asset),
  ExampleVideoSource(path: 'assets/video/05.mp4', type: VideoSourceType.asset),
  ExampleVideoSource(path: 'assets/video/06.mp4', type: VideoSourceType.asset),
  ExampleVideoSource(
    path:
        'https://cdn.videvo.net/videvo_files/video/free/2017-12/large_watermarked/171124_B1_HD_001_preview.mp4',
    type: VideoSourceType.network,
  ),
  ExampleVideoSource(
    path:
        'https://cdn.videvo.net/videvo_files/video/free/2018-01/large_watermarked/171124_G1_013_preview.mp4',
    type: VideoSourceType.network,
  ),
];

void main() {
  runApp(
    const AppView(),
  );
}

enum AppRoute {
  videoPlayer,
  videoList,
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  var _appRoute = AppRoute.videoPlayer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: _buildBodyView(),
        bottomNavigationBar: BottomNavigationView(
          selectedAppRoute: _appRoute,
          onAppRouteSelected: (appRoute) {
            setState(() {
              _appRoute = appRoute;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBodyView() {
    switch (_appRoute) {
      case AppRoute.videoPlayer:
        return const VideoPlayerScreenView();
      case AppRoute.videoList:
        return const VideoListScreenView();
    }
  }
}

class BottomNavigationView extends StatelessWidget {
  final AppRoute selectedAppRoute;
  final void Function(AppRoute) onAppRouteSelected;

  const BottomNavigationView({
    Key? key,
    required this.selectedAppRoute,
    required this.onAppRouteSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_display),
          label: 'Video Player',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_stream),
          label: 'Video List',
        ),
      ],
      currentIndex: selectedAppRoute.index,
      onTap: (index) => onAppRouteSelected(AppRoute.values[index]),
    );
  }
}

class VideoPlayerScreenView extends StatefulWidget {
  const VideoPlayerScreenView({Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreenView> createState() => _VideoPlayerScreenViewState();
}

class _VideoPlayerScreenViewState extends State<VideoPlayerScreenView> {
  var selectedVideoSource = videoSources.first;

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
                videoSource: selectedVideoSource,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 128,
              child: VideoCarouselView(
                onVideoSourceSelected: (videoSource) {
                  setState(() {
                    selectedVideoSource = videoSource;
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
    Key? key,
    required this.onVideoSourceSelected,
  }) : super(key: key);

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
                  );
                  controller.loadVideoSource(videoSource);
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
    Key? key,
    required this.videoSource,
  }) : super(key: key);

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

  Future<void> _initController(controller) async {
    _controller = controller;

    _controller?. //
        onPlaybackStatusChanged
        .addListener(_onPlaybackStatusChanged);
    _controller?. //
        onPlaybackPositionChanged
        .addListener(_onPlaybackPositionChanged);
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
    return await VideoSource.init(
      path: widget.videoSource.path,
      type: widget.videoSource.type,
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

  void _onPlaybackEnded() {
    if (isPlaybackLoopEnabled) {
      _controller?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
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
          min: 0,
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
            const Text("Volume"),
            Expanded(
              child: Slider(
                value: _controller?.playbackInfo?.volume ?? 0,
                onChanged: (value) => _controller?.setVolume(value),
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

class VideoListScreenView extends StatelessWidget {
  const VideoListScreenView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const VideoListView();
  }
}

class VideoListView extends StatelessWidget {
  const VideoListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return VideoListItemView(
          videoSource: videoSources[index],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: videoSources.length,
    );
  }
}

class VideoListItemView extends StatefulWidget {
  final ExampleVideoSource videoSource;

  const VideoListItemView({
    Key? key,
    required this.videoSource,
  }) : super(key: key);

  @override
  State<VideoListItemView> createState() => _VideoListItemViewState();
}

class _VideoListItemViewState extends State<VideoListItemView> {
  NativeVideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          NativeVideoPlayerView(
            onViewReady: (controller) async {
              _controller = controller;
              _controller?.setVolume(1);
              await _loadVideoSource();
            },
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _togglePlayback,
              child: Center(
                child: FutureBuilder(
                  future: _isPlaying,
                  initialData: false,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<bool> snapshot,
                  ) {
                    final isPlaying = snapshot.data ?? false;
                    return Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 64,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadVideoSource() async {
    final videoSource = await VideoSource.init(
      type: widget.videoSource.type,
      path: widget.videoSource.path,
    );
    _controller?.loadVideoSource(videoSource);
  }

  Future<void> _togglePlayback() async {
    final isPlaying = await _isPlaying;
    if (isPlaying) {
      await _controller?.pause();
    } else {
      await _controller?.play();
    }
    setState(() {});
  }

  Future<bool> get _isPlaying async => await _controller?.isPlaying() ?? false;
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
