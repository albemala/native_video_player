import 'package:flutter/material.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:native_video_player_example/defines.dart';

class VideoListScreenView extends StatelessWidget {
  const VideoListScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const VideoListView();
  }
}

class VideoListView extends StatelessWidget {
  const VideoListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: videoSources.length,
      itemBuilder: (context, index) {
        return VideoListItemView(
          videoSource: videoSources[index],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16);
      },
    );
  }
}

class VideoListItemView extends StatefulWidget {
  final VideoSource videoSource;

  const VideoListItemView({
    super.key,
    required this.videoSource,
  });

  @override
  State<VideoListItemView> createState() => _VideoListItemViewState();
}

class _VideoListItemViewState extends State<VideoListItemView> {
  NativeVideoPlayerController? _controller;
  bool _isPlaying = false;

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          NativeVideoPlayerView(
            onViewReady: (controller) async {
              _controller = controller;
              await _controller?.setVolume(1);
              await _controller?.loadVideo(widget.videoSource);
            },
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: togglePlayback,
              child: Center(
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> togglePlayback() async {
    final controller = _controller;
    if (controller == null) return;

    if (_isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }

    final isPlaying = await controller.isPlaying();
    setState(() {
      _isPlaying = isPlaying;
    });
  }
}
