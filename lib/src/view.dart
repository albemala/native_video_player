import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:native_video_player/src/controller.dart';

/// A [StatefulWidget] that is responsible for displaying a video.
///
/// On iOS, the video is displayed using a combination
/// of AVPlayer and AVPlayerLayer.
///
/// On Android, the video is displayed using a combination
/// of MediaPlayer and VideoView.
class NativeVideoPlayerView extends StatefulWidget {
  /// Callback that is triggered when the native video player view is ready.
  ///
  /// This callback provides a [NativeVideoPlayerController] instance that can be used
  /// to control the video playback (play, pause, seek, etc.). The controller is
  /// created after the native platform view has been successfully initialized.
  ///
  /// Example usage:
  /// ```dart
  /// NativeVideoPlayerView(
  ///   onViewReady: (controller) {
  ///     // Store the controller for later use
  ///     _controller = controller;
  ///   },
  /// )
  /// ```
  final void Function(NativeVideoPlayerController) onViewReady;

  const NativeVideoPlayerView({
    super.key,
    required this.onViewReady,
  });

  @override
  State<NativeVideoPlayerView> createState() => _NativeVideoPlayerViewState();
}

class _NativeVideoPlayerViewState extends State<NativeVideoPlayerView> {
  @override
  Widget build(BuildContext context) {
    const viewType = 'native_video_player_view';
    final nativeView = switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidView(
          viewType: viewType,
          onPlatformViewCreated: onPlatformViewCreated,
        ),
      TargetPlatform.iOS => UiKitView(
          viewType: viewType,
          onPlatformViewCreated: onPlatformViewCreated,
        ),
      TargetPlatform.macOS => AppKitView(
          viewType: viewType,
          onPlatformViewCreated: onPlatformViewCreated,
        ),
      _ => Text('$defaultTargetPlatform is not yet supported by this plugin.'),
    };

    /// RepaintBoundary is a widget that isolates repaints
    return RepaintBoundary(
      child: nativeView,
    );
  }

  /// This method is invoked by the platform view
  /// when the native view is created.
  Future<void> onPlatformViewCreated(int id) async {
    final controller = NativeVideoPlayerController(id);
    widget.onViewReady(controller);
  }
}
