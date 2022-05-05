import 'package:json_annotation/json_annotation.dart';

part 'video_info.g.dart';

/// Class that contains info attributes of a video file.
/// Contains [height], the [width] and the [duration] of the file.
/// This class is loaded once the video is loaded in the player.
@JsonSerializable()
class VideoInfo {
  final int height;
  final int width;

  /// Duration in seconds of the file.
  final int duration;

  double get aspectRatio => //
      height > 0 && width > 0 //
          ? width / height
          : 1;

  VideoInfo({
    required this.height,
    required this.width,
    required this.duration,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) => _$VideoInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoInfoToJson(this);
}
