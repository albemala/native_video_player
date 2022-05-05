import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'utils/file.dart';
import 'video_source_type.dart';

part 'video_source.g.dart';

@JsonSerializable()
class VideoSource {
  static Future<VideoSource> init({
    required String path,
    required VideoSourceType type,
  }) async {
    final String sourcePath;
    if (type == VideoSourceType.asset) {
      final tempFile = await loadAssetFile(path);
      sourcePath = tempFile.path;
    } else {
      sourcePath = path;
    }

    return VideoSource(
      path: sourcePath,
      type: type,
    );
  }

  final String path;
  final VideoSourceType type;

  /// A constructor for use in serialization.
  /// NOTE: This constructor is for internal use only.
  /// Please use [init] instead.
  @protected
  VideoSource({
    required this.path,
    required this.type,
  });

  factory VideoSource.fromJson(Map<String, dynamic> json) {
    return _$VideoSourceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoSourceToJson(this);
  }
}
