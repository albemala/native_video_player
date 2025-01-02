import 'package:native_video_player/native_video_player.dart';

final videoSources = [
  VideoSource(path: 'assets/video/01.mp4', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/02.mp4', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/03.mp4', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/04.mp4', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/05.mp4', type: VideoSourceType.asset),
  VideoSource(path: 'assets/video/06.mp4', type: VideoSourceType.asset),
  VideoSource(
    path:
        'https://file-examples.com/storage/fea8fc38fd63bc5c39cf20b/2017/04/file_example_MP4_480_1_5MG.mp4',
    type: VideoSourceType.network,
  ),
];
