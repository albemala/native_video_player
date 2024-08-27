import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:native_video_player/src/utils/file.dart';
import 'package:native_video_player/src/video_source_type.dart';

part 'video_source.g.dart';

@JsonSerializable()
class VideoSource {
  /// Initialize a video source.
  //
  //  If the source is an asset, it will be copied to a temporary file.
  //
  //  [path] is the path to the video source.
  //  [type] is the type of video source (asset, file, network).
  static Future<VideoSource> init({
    required String path,
    required VideoSourceType type,
    Map<String, String>? headers,
  }) async {
    final String sourcePath;
    if (type == VideoSourceType.asset) {
      final tempFile = await loadAssetFile(path);
      sourcePath = tempFile.path;
    } else {
      sourcePath = path;
    }

    headers ??= {};

    return VideoSource(
      path: sourcePath,
      type: type,
      headers: headers,
    );
  }

  /// Absolute path to the video source.
  final String path;

  /// Type of video source (asset, file, network).
  final VideoSourceType type;

  /// Optional Headers to be used for network request
  final Map<String, String> headers;

  /// A constructor for use in serialization.
  /// NOTE: This constructor is for internal use only.
  /// Please use [init] instead.
  @protected
  VideoSource({
    required this.path,
    required this.type,
    required this.headers,
  });

  factory VideoSource.fromJson(Map<String, dynamic> json) {
    return _$VideoSourceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoSourceToJson(this);
  }
}
