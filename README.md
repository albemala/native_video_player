# native_video_player

[![Pub](https://img.shields.io/pub/v/native_video_player)](https://pub.dev/packages/native_video_player)

A Flutter widget to play videos on iOS, macOS and Android using a native implementation.

Perfect for building video-centric apps like TikTok, Instagram Reels, or YouTube Shorts, as well as general video playback needs.

|             | Android | iOS  | macOS |
|:------------|:--------|:-----|:------|
| **Support** | 16+     | 9.0+ | 10.11+|

<img src="https://raw.githubusercontent.com/albemala/native_video_player/main/screenshots/1.gif" width="320"/>
<img src="https://raw.githubusercontent.com/albemala/native_video_player/main/screenshots/2.gif" width="320"/>
<img src="https://raw.githubusercontent.com/albemala/native_video_player/main/screenshots/3.gif" width="320"/>

### Implementation

- On iOS and macOS, the video is displayed using a combination
  of [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer)
  and [AVPlayerLayer](https://developer.apple.com/documentation/avfoundation/avplayerlayer).
- On Android, the video is displayed using a combination
  of [MediaPlayer](https://developer.android.com/guide/topics/media/mediaplayer)
  and [VideoView](https://developer.android.com/reference/android/widget/VideoView).

## Usage

### Loading a video

```dart
@override
Widget build(BuildContext context) {
  return NativeVideoPlayerView(
    onViewReady: (controller) async {
      await controller.loadVideo(
        VideoSource(
          path: 'path/to/file',
          type: VideoSourceType.asset,
        ),
      );
    },
  );
}
```

### Listen to events

```dart
StreamSubscription<void>? _eventsSubscription;

_eventsSubscription = controller.events.listen((event) {
  switch (event) {
    case PlaybackStatusChangedEvent():
      // Emitted when playback status changes (playing, paused, or stopped)
      final playbackStatus = controller.playbackStatus;
    case PlaybackPositionChangedEvent():
      // Emitted when playback position changes
      final position = controller.playbackPosition;
    case PlaybackReadyEvent():
      // Emitted when video is loaded and ready to play
      final height = controller.videoInfo?.height;
      final width = controller.videoInfo?.width;
      final duration = controller.videoInfo?.duration;
    case PlaybackEndedEvent():
      // Emitted when video playback ends
    case PlaybackSpeedChangedEvent():
      // Emitted when playback speed changes
    case VolumeChangedEvent():
      // Emitted when volume changes
    case PlaybackErrorEvent():
      // Emitted when an error occurs
      print('Playback error: ${event.errorMessage}');
  }
});

// Don't forget to dispose the subscription
@override
void dispose() {
  _eventsSubscription?.cancel();
  super.dispose();
}
```

### Autoplay

```dart
bool isAutoplayEnabled = false;

Future<void> _loadVideoSource() async {
  await controller.loadVideo(videoSource);
  if (isAutoplayEnabled) {
    await controller.play();
  }
}
```

### Playback loop

```dart
bool isPlaybackLoopEnabled = false;

void _onPlaybackEnded() {
  if (isPlaybackLoopEnabled) {
    controller.stop();
    controller.play();
  }
}

// Set up event listener
_eventsSubscription = controller.events.listen((event) {
  switch (event) {
    case PlaybackEndedEvent():
      _onPlaybackEnded();
    // ... handle other events ...
  }
});
```

### Controller disposal

```dart
class VideoPlayerState extends State<VideoPlayer> {
  NativeVideoPlayerController? _controller;
  StreamSubscription<void>? _eventsSubscription;

  Future<void> _initController(NativeVideoPlayerController controller) async {
    _controller = controller;
    _eventsSubscription = _controller?.events.listen((event) {
      // ... handle events ...
    });
  }

  @override
  void dispose() {
    // Cancel any event subscriptions
    _eventsSubscription?.cancel();
    // Dispose of the controller
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }
}
```

It's important to properly dispose of both the controller and any event subscriptions when you're done with them to prevent memory leaks. This typically happens in the `dispose()` method of your widget's State.

### Advanced usage

See the [example app](https://github.com/albemala/native_video_player/tree/main/example) for a complete usage example.

## Support this project

- [GitHub Sponsor](https://github.com/sponsors/albemala)
- [Buy Me A Coffee](https://www.buymeacoffee.com/albemala)

Sponsors:

- [@enteio](https://github.com/enteio)
- [@bsutton](https://github.com/bsutton)

Thank you to all sponsors for supporting this project! ❤️

## Other projects

[All my projects](https://projects.albemala.me/)

## Credits

Created by [@albemala](https://github.com/albemala) ([Twitter](https://twitter.com/albemala))
