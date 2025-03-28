// Autogenerated from Pigeon (v22.7.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

List<Object?> wrapResponse(
    {Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

enum VideoSourceType {
  asset,
  file,
  network,
}

enum PlaybackStatus {
  playing,
  paused,
  stopped,
}

class VideoSource {
  VideoSource({
    required this.path,
    required this.type,
    this.headers,
  });

  String path;

  VideoSourceType type;

  Map<String, String>? headers;

  Object encode() {
    return <Object?>[
      path,
      type,
      headers,
    ];
  }

  static VideoSource decode(Object result) {
    result as List<Object?>;
    return VideoSource(
      path: result[0]! as String,
      type: result[1]! as VideoSourceType,
      headers: (result[2] as Map<Object?, Object?>?)?.cast<String, String>(),
    );
  }
}

class VideoInfo {
  VideoInfo({
    required this.height,
    required this.width,
    required this.durationInMilliseconds,
  });

  int height;

  int width;

  int durationInMilliseconds;

  Object encode() {
    return <Object?>[
      height,
      width,
      durationInMilliseconds,
    ];
  }

  static VideoInfo decode(Object result) {
    result as List<Object?>;
    return VideoInfo(
      height: result[0]! as int,
      width: result[1]! as int,
      durationInMilliseconds: result[2]! as int,
    );
  }
}

sealed class PlaybackEvent {}

class PlaybackStatusChangedEvent extends PlaybackEvent {
  PlaybackStatusChangedEvent({
    required this.status,
  });

  PlaybackStatus status;

  Object encode() {
    return <Object?>[
      status,
    ];
  }

  static PlaybackStatusChangedEvent decode(Object result) {
    result as List<Object?>;
    return PlaybackStatusChangedEvent(
      status: result[0]! as PlaybackStatus,
    );
  }
}

class PlaybackPositionChangedEvent extends PlaybackEvent {
  PlaybackPositionChangedEvent({
    required this.positionInMilliseconds,
  });

  int positionInMilliseconds;

  Object encode() {
    return <Object?>[
      positionInMilliseconds,
    ];
  }

  static PlaybackPositionChangedEvent decode(Object result) {
    result as List<Object?>;
    return PlaybackPositionChangedEvent(
      positionInMilliseconds: result[0]! as int,
    );
  }
}

class PlaybackSpeedChangedEvent extends PlaybackEvent {
  PlaybackSpeedChangedEvent({
    required this.speed,
  });

  double speed;

  Object encode() {
    return <Object?>[
      speed,
    ];
  }

  static PlaybackSpeedChangedEvent decode(Object result) {
    result as List<Object?>;
    return PlaybackSpeedChangedEvent(
      speed: result[0]! as double,
    );
  }
}

class VolumeChangedEvent extends PlaybackEvent {
  VolumeChangedEvent({
    required this.volume,
  });

  double volume;

  Object encode() {
    return <Object?>[
      volume,
    ];
  }

  static VolumeChangedEvent decode(Object result) {
    result as List<Object?>;
    return VolumeChangedEvent(
      volume: result[0]! as double,
    );
  }
}

/// Emitted when the video loaded successfully and it's ready to play.
/// At this point, [videoInfo] is available.
class PlaybackReadyEvent extends PlaybackEvent {
  Object encode() {
    return <Object?>[];
  }

  static PlaybackReadyEvent decode(Object result) {
    result as List<Object?>;
    return PlaybackReadyEvent();
  }
}

class PlaybackEndedEvent extends PlaybackEvent {
  Object encode() {
    return <Object?>[];
  }

  static PlaybackEndedEvent decode(Object result) {
    result as List<Object?>;
    return PlaybackEndedEvent();
  }
}

class PlaybackErrorEvent extends PlaybackEvent {
  PlaybackErrorEvent({
    required this.errorMessage,
  });

  String errorMessage;

  Object encode() {
    return <Object?>[
      errorMessage,
    ];
  }

  static PlaybackErrorEvent decode(Object result) {
    result as List<Object?>;
    return PlaybackErrorEvent(
      errorMessage: result[0]! as String,
    );
  }
}

class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    } else if (value is VideoSourceType) {
      buffer.putUint8(129);
      writeValue(buffer, value.index);
    } else if (value is PlaybackStatus) {
      buffer.putUint8(130);
      writeValue(buffer, value.index);
    } else if (value is VideoSource) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is VideoInfo) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is PlaybackStatusChangedEvent) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is PlaybackPositionChangedEvent) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is PlaybackSpeedChangedEvent) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else if (value is VolumeChangedEvent) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    } else if (value is PlaybackReadyEvent) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    } else if (value is PlaybackEndedEvent) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else if (value is PlaybackErrorEvent) {
      buffer.putUint8(139);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129:
        final int? value = readValue(buffer) as int?;
        return value == null ? null : VideoSourceType.values[value];
      case 130:
        final int? value = readValue(buffer) as int?;
        return value == null ? null : PlaybackStatus.values[value];
      case 131:
        return VideoSource.decode(readValue(buffer)!);
      case 132:
        return VideoInfo.decode(readValue(buffer)!);
      case 133:
        return PlaybackStatusChangedEvent.decode(readValue(buffer)!);
      case 134:
        return PlaybackPositionChangedEvent.decode(readValue(buffer)!);
      case 135:
        return PlaybackSpeedChangedEvent.decode(readValue(buffer)!);
      case 136:
        return VolumeChangedEvent.decode(readValue(buffer)!);
      case 137:
        return PlaybackReadyEvent.decode(readValue(buffer)!);
      case 138:
        return PlaybackEndedEvent.decode(readValue(buffer)!);
      case 139:
        return PlaybackErrorEvent.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class NativeVideoPlayerHostApi {
  /// Constructor for [NativeVideoPlayerHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  NativeVideoPlayerHostApi(
      {BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix =
            messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  Future<void> loadVideo(VideoSource source) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.loadVideo$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[source]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<VideoInfo> getVideoInfo() async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.getVideoInfo$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(null) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as VideoInfo?)!;
    }
  }

  Future<void> play(double speed) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.play$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[speed]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> pause() async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.pause$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(null) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> stop() async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.stop$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(null) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<bool> isPlaying() async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.isPlaying$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(null) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as bool?)!;
    }
  }

  Future<void> seekTo(int position) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.seekTo$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[position]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<int> getPlaybackPosition() async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.getPlaybackPosition$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(null) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as int?)!;
    }
  }

  Future<void> setVolume(double volume) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.setVolume$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[volume]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.setPlaybackSpeed$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[speed]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }
}

abstract class NativeVideoPlayerFlutterApi {
  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  void onPlaybackEvent(PlaybackEvent event);

  static void setUp(
    NativeVideoPlayerFlutterApi? api, {
    BinaryMessenger? binaryMessenger,
    String messageChannelSuffix = '',
  }) {
    messageChannelSuffix =
        messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
    {
      final BasicMessageChannel<
          Object?> pigeonVar_channel = BasicMessageChannel<
              Object?>(
          'dev.flutter.pigeon.native_video_player.NativeVideoPlayerFlutterApi.onPlaybackEvent$messageChannelSuffix',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        pigeonVar_channel.setMessageHandler(null);
      } else {
        pigeonVar_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.native_video_player.NativeVideoPlayerFlutterApi.onPlaybackEvent was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final PlaybackEvent? arg_event = (args[0] as PlaybackEvent?);
          assert(arg_event != null,
              'Argument for dev.flutter.pigeon.native_video_player.NativeVideoPlayerFlutterApi.onPlaybackEvent was null, expected non-null PlaybackEvent.');
          try {
            api.onPlaybackEvent(arg_event!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}
