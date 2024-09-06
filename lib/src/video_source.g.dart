// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoSource _$VideoSourceFromJson(Map<String, dynamic> json) => VideoSource(
      path: json['path'] as String,
      type: $enumDecode(_$VideoSourceTypeEnumMap, json['type']),
      headers: Map<String, String>.from(json['headers'] as Map),
    );

Map<String, dynamic> _$VideoSourceToJson(VideoSource instance) =>
    <String, dynamic>{
      'path': instance.path,
      'type': _$VideoSourceTypeEnumMap[instance.type]!,
      'headers': instance.headers,
    };

const _$VideoSourceTypeEnumMap = {
  VideoSourceType.asset: 'asset',
  VideoSourceType.file: 'file',
  VideoSourceType.network: 'network',
};
