import 'package:native_video_player/src/api.g.dart';

extension VideoInfoAspectRatio on VideoInfo {
  double get aspectRatio => height > 0 && width > 0 ? width / height : 0;
}
