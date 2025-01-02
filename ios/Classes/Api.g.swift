// Autogenerated from Pigeon (v22.7.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
final class PigeonError: Error {
  let code: String
  let message: String?
  let details: Any?

  init(code: String, message: String?, details: Any?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "PigeonError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
      }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? PigeonError {
    return [
      pigeonError.code,
      pigeonError.message,
      pigeonError.details,
    ]
  }
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func createConnectionError(withChannelName channelName: String) -> PigeonError {
  return PigeonError(code: "channel-error", message: "Unable to establish connection on channel: '\(channelName)'.", details: "")
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

enum VideoSourceType: Int {
  case asset = 0
  case file = 1
  case network = 2
}

enum PlaybackStatus: Int {
  case playing = 0
  case paused = 1
  case stopped = 2
}

/// Generated class from Pigeon that represents data sent in messages.
struct VideoSource {
  var path: String
  var type: VideoSourceType
  var headers: [String: String]? = nil


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> VideoSource? {
    let path = pigeonVar_list[0] as! String
    let type = pigeonVar_list[1] as! VideoSourceType
    let headers: [String: String]? = nilOrValue(pigeonVar_list[2])

    return VideoSource(
      path: path,
      type: type,
      headers: headers
    )
  }
  func toList() -> [Any?] {
    return [
      path,
      type,
      headers,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct VideoInfo {
  var height: Int64
  var width: Int64
  var duration: Int64


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> VideoInfo? {
    let height = pigeonVar_list[0] as! Int64
    let width = pigeonVar_list[1] as! Int64
    let duration = pigeonVar_list[2] as! Int64

    return VideoInfo(
      height: height,
      width: width,
      duration: duration
    )
  }
  func toList() -> [Any?] {
    return [
      height,
      width,
      duration,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
/// This protocol should not be extended by any user class outside of the generated file.
protocol PlaybackEvent {

}

/// Generated class from Pigeon that represents data sent in messages.
struct PlaybackStatusChangedEvent: PlaybackEvent {
  var status: PlaybackStatus


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PlaybackStatusChangedEvent? {
    let status = pigeonVar_list[0] as! PlaybackStatus

    return PlaybackStatusChangedEvent(
      status: status
    )
  }
  func toList() -> [Any?] {
    return [
      status
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct PlaybackPositionChangedEvent: PlaybackEvent {
  var position: Int64


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PlaybackPositionChangedEvent? {
    let position = pigeonVar_list[0] as! Int64

    return PlaybackPositionChangedEvent(
      position: position
    )
  }
  func toList() -> [Any?] {
    return [
      position
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct PlaybackSpeedChangedEvent: PlaybackEvent {
  var speed: Double


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PlaybackSpeedChangedEvent? {
    let speed = pigeonVar_list[0] as! Double

    return PlaybackSpeedChangedEvent(
      speed: speed
    )
  }
  func toList() -> [Any?] {
    return [
      speed
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct VolumeChangedEvent: PlaybackEvent {
  var volume: Double


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> VolumeChangedEvent? {
    let volume = pigeonVar_list[0] as! Double

    return VolumeChangedEvent(
      volume: volume
    )
  }
  func toList() -> [Any?] {
    return [
      volume
    ]
  }
}

/// Emitted when the video loaded successfully and it's ready to play.
/// At this point, [videoInfo] is available.
///
/// Generated class from Pigeon that represents data sent in messages.
struct PlaybackReadyEvent: PlaybackEvent {


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PlaybackReadyEvent? {

    return PlaybackReadyEvent(
    )
  }
  func toList() -> [Any?] {
    return [
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct PlaybackEndedEvent: PlaybackEvent {


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PlaybackEndedEvent? {

    return PlaybackEndedEvent(
    )
  }
  func toList() -> [Any?] {
    return [
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct PlaybackErrorEvent: PlaybackEvent {
  var errorMessage: String


  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> PlaybackErrorEvent? {
    let errorMessage = pigeonVar_list[0] as! String

    return PlaybackErrorEvent(
      errorMessage: errorMessage
    )
  }
  func toList() -> [Any?] {
    return [
      errorMessage
    ]
  }
}

private class ApiPigeonCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 129:
      let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
      if let enumResultAsInt = enumResultAsInt {
        return VideoSourceType(rawValue: enumResultAsInt)
      }
      return nil
    case 130:
      let enumResultAsInt: Int? = nilOrValue(self.readValue() as! Int?)
      if let enumResultAsInt = enumResultAsInt {
        return PlaybackStatus(rawValue: enumResultAsInt)
      }
      return nil
    case 131:
      return VideoSource.fromList(self.readValue() as! [Any?])
    case 132:
      return VideoInfo.fromList(self.readValue() as! [Any?])
    case 133:
      return PlaybackStatusChangedEvent.fromList(self.readValue() as! [Any?])
    case 134:
      return PlaybackPositionChangedEvent.fromList(self.readValue() as! [Any?])
    case 135:
      return PlaybackSpeedChangedEvent.fromList(self.readValue() as! [Any?])
    case 136:
      return VolumeChangedEvent.fromList(self.readValue() as! [Any?])
    case 137:
      return PlaybackReadyEvent.fromList(self.readValue() as! [Any?])
    case 138:
      return PlaybackEndedEvent.fromList(self.readValue() as! [Any?])
    case 139:
      return PlaybackErrorEvent.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class ApiPigeonCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? VideoSourceType {
      super.writeByte(129)
      super.writeValue(value.rawValue)
    } else if let value = value as? PlaybackStatus {
      super.writeByte(130)
      super.writeValue(value.rawValue)
    } else if let value = value as? VideoSource {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else if let value = value as? VideoInfo {
      super.writeByte(132)
      super.writeValue(value.toList())
    } else if let value = value as? PlaybackStatusChangedEvent {
      super.writeByte(133)
      super.writeValue(value.toList())
    } else if let value = value as? PlaybackPositionChangedEvent {
      super.writeByte(134)
      super.writeValue(value.toList())
    } else if let value = value as? PlaybackSpeedChangedEvent {
      super.writeByte(135)
      super.writeValue(value.toList())
    } else if let value = value as? VolumeChangedEvent {
      super.writeByte(136)
      super.writeValue(value.toList())
    } else if let value = value as? PlaybackReadyEvent {
      super.writeByte(137)
      super.writeValue(value.toList())
    } else if let value = value as? PlaybackEndedEvent {
      super.writeByte(138)
      super.writeValue(value.toList())
    } else if let value = value as? PlaybackErrorEvent {
      super.writeByte(139)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class ApiPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return ApiPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return ApiPigeonCodecWriter(data: data)
  }
}

class ApiPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = ApiPigeonCodec(readerWriter: ApiPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol NativeVideoPlayerHostApi {
  func loadVideo(source: VideoSource) throws
  func getVideoInfo() throws -> VideoInfo
  func play(speed: Double) throws
  func pause() throws
  func stop() throws
  func isPlaying() throws -> Bool
  func seekTo(position: Int64) throws
  func getPlaybackPosition() throws -> Int64
  func setVolume(volume: Double) throws
  func setPlaybackSpeed(speed: Double) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class NativeVideoPlayerHostApiSetup {
  static var codec: FlutterStandardMessageCodec { ApiPigeonCodec.shared }
  /// Sets up an instance of `NativeVideoPlayerHostApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: NativeVideoPlayerHostApi?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let loadVideoChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.loadVideo\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      loadVideoChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let sourceArg = args[0] as! VideoSource
        do {
          try api.loadVideo(source: sourceArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      loadVideoChannel.setMessageHandler(nil)
    }
    let getVideoInfoChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.getVideoInfo\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getVideoInfoChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getVideoInfo()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getVideoInfoChannel.setMessageHandler(nil)
    }
    let playChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.play\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      playChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let speedArg = args[0] as! Double
        do {
          try api.play(speed: speedArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      playChannel.setMessageHandler(nil)
    }
    let pauseChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.pause\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      pauseChannel.setMessageHandler { _, reply in
        do {
          try api.pause()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      pauseChannel.setMessageHandler(nil)
    }
    let stopChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.stop\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      stopChannel.setMessageHandler { _, reply in
        do {
          try api.stop()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      stopChannel.setMessageHandler(nil)
    }
    let isPlayingChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.isPlaying\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      isPlayingChannel.setMessageHandler { _, reply in
        do {
          let result = try api.isPlaying()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      isPlayingChannel.setMessageHandler(nil)
    }
    let seekToChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.seekTo\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      seekToChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let positionArg = args[0] as! Int64
        do {
          try api.seekTo(position: positionArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      seekToChannel.setMessageHandler(nil)
    }
    let getPlaybackPositionChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.getPlaybackPosition\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getPlaybackPositionChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getPlaybackPosition()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getPlaybackPositionChannel.setMessageHandler(nil)
    }
    let setVolumeChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.setVolume\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setVolumeChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let volumeArg = args[0] as! Double
        do {
          try api.setVolume(volume: volumeArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setVolumeChannel.setMessageHandler(nil)
    }
    let setPlaybackSpeedChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.setPlaybackSpeed\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setPlaybackSpeedChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let speedArg = args[0] as! Double
        do {
          try api.setPlaybackSpeed(speed: speedArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      setPlaybackSpeedChannel.setMessageHandler(nil)
    }
  }
}
/// Generated protocol from Pigeon that represents Flutter messages that can be called from Swift.
protocol NativeVideoPlayerFlutterApiProtocol {
  func onPlaybackEvent(event eventArg: PlaybackEvent, completion: @escaping (Result<Void, PigeonError>) -> Void)
}
class NativeVideoPlayerFlutterApi: NativeVideoPlayerFlutterApiProtocol {
  private let binaryMessenger: FlutterBinaryMessenger
  private let messageChannelSuffix: String
  init(binaryMessenger: FlutterBinaryMessenger, messageChannelSuffix: String = "") {
    self.binaryMessenger = binaryMessenger
    self.messageChannelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
  }
  var codec: ApiPigeonCodec {
    return ApiPigeonCodec.shared
  }
  func onPlaybackEvent(event eventArg: PlaybackEvent, completion: @escaping (Result<Void, PigeonError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.native_video_player.NativeVideoPlayerFlutterApi.onPlaybackEvent\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([eventArg] as [Any?]) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(PigeonError(code: code, message: message, details: details)))
      } else {
        completion(.success(Void()))
      }
    }
  }
}
