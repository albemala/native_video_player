import 'package:native_video_player/native_video_player.dart';

final videoSources = [
  VideoSource(path: 'assets/video/01.mp4', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/02.mp4', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/03.mp4', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/04.mp4', type: VideoSourceType.asset),
  VideoSource(
    path:
        'https://github.com/albemala/native_video_player/raw/refs/heads/main/example/assets/video/05.mp4',
    type: VideoSourceType.network,
  ),
  VideoSource(
    path:
        'https://github.com/albemala/native_video_player/raw/refs/heads/main/example/assets/video/06.mp4',
    type: VideoSourceType.network,
  ),
  VideoSource(path: 'assets/video/07.webm', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/08.mkv', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/09.mov', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/10.asf', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/corrupted.mp4', type: VideoSourceType.asset),
];
