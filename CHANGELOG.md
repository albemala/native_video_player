# 4.0.0

This release is sponsored by:

- [@wiredashio](https://github.com/wiredashio)

### Major Changes

- Added macOS support (macOS 10.11+)


# 4.0.0-dev.1

- Added macOS support (macOS 10.11+)


# 3.0.0

This release is sponsored by:

- [@enteio](https://github.com/enteio)
- [@bsutton](https://github.com/bsutton)

### Breaking Changes

- Removed `PlaybackInfo` class - all information now accessible directly from controller
  ```dart
  final duration = controller.videoInfo?.duration;
  final position = controller.playbackPosition;
  ```

- Controllers must now be explicitly disposed using `dispose()` method
  ```dart
  @override
  void dispose() {
    _eventsSubscription?.cancel();
    controller.dispose();
    super.dispose();
  }
  ```

- Removed `init` constructor from `VideoSource` class
  ```dart
  await controller.loadVideo(
    VideoSource(
      path: 'path/to/file',
      type: VideoSourceType.asset,
    ),
  );
  ```

- `seekTo` and playback position values now use `Duration` instead of seconds (#26)
  ```dart
  controller.seekTo(Duration(seconds: 3));
  ```

- Events-based API replaces callback system
  ```dart
  _eventsSubscription = controller.events.listen((event) {
    switch (event) {
      case PlaybackStatusChangedEvent():
        // Handle status change
        final playbackStatus = controller.playbackStatus;
      // Handle other events...
    }
  });
  ```

### Major Changes

- Targeting Dart 3.5 and Flutter 3.24
- API redesign using events instead of callbacks
- Using ExoPlayer on Android
- Set Compile SDK to 35 on Android

### Improvements

- Improved error reporting on Android
- Improved example

### Bug Fixes

- Fixed audio playback on iOS when device is in silent mode (#22)
- Fixed memory leaks on iOS and Android


# 3.0.0-dev.4

- Fixed memory leaks on iOS and Android


# 3.0.0-dev.3

- Using ExoPlayer on Android
- Set Compile SDK to 35 on Android


# 3.0.0-dev.2

- Improved error reporting on android
- Improved example


# 3.0.0-dev.1

- Targeting Dart 3.5 and Flutter 3.24
- API redesign using events instead of callbacks
- Removed `PlaybackInfo` class - all information now accessible directly from controller
- Controllers must now be explicitly disposed using `dispose()` method
- Removed `init` constructor from `VideoSource` class
- `seekTo` and playback position values now use `Duration` instead of seconds (#26)
- Fixed audio playback on iOS when device is in silent mode (#22)


# 2.0.0

- Added support for sending optional headers to the native players to stream videos behind authentication (thanks to
  @shenlong-tanwen)
- Notify when video isn't playable on iOS (thanks to @ashilkn)
- Upgrading to Gradle 8 (thanks to @Pablo-Aldana)
- minSdkVersion on Android is now 21
- Upgraded dependencies


# 1.3.1

- Fixed #10
- Split example into multiple files
- Upgraded dependencies


# 1.3.0

- Targeting Dart 3.0 and Flutter 3.10


# 1.2.0+3

- BREAKING: `NativeVideoPlayerController` now throws exceptions that must be handled by the caller.
- Added new method to set playback speed
- Exposed more controller events (playback speed and volume changed)


# 1.1.0+2

- Fixed gifs not showing in Readme


# 1.1.0

- Targeting Flutter 3


# 1.0.3

- Fixed publishing error


# 1.0.2

- Fixed videos not playing on iOS 14


# 1.0.1

- First public release
