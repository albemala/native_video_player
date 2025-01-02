// Autogenerated from Pigeon (v22.7.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

private fun createConnectionError(channelName: String): FlutterError {
  return FlutterError("channel-error",  "Unable to establish connection on channel: '$channelName'.", "")}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class VideoSourceType(val raw: Int) {
  ASSET(0),
  FILE(1),
  NETWORK(2);

  companion object {
    fun ofRaw(raw: Int): VideoSourceType? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class PlaybackStatus(val raw: Int) {
  PLAYING(0),
  PAUSED(1),
  STOPPED(2);

  companion object {
    fun ofRaw(raw: Int): PlaybackStatus? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class VideoSource (
  val path: String,
  val type: VideoSourceType,
  val headers: Map<String, String>? = null
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): VideoSource {
      val path = pigeonVar_list[0] as String
      val type = pigeonVar_list[1] as VideoSourceType
      val headers = pigeonVar_list[2] as Map<String, String>?
      return VideoSource(path, type, headers)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      path,
      type,
      headers,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class VideoInfo (
  val height: Long,
  val width: Long,
  val duration: Long
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): VideoInfo {
      val height = pigeonVar_list[0] as Long
      val width = pigeonVar_list[1] as Long
      val duration = pigeonVar_list[2] as Long
      return VideoInfo(height, width, duration)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      height,
      width,
      duration,
    )
  }
}

/**
 * Generated class from Pigeon that represents data sent in messages.
 * This class should not be extended by any user class outside of the generated file.
 */
sealed class PlaybackEvent 
/** Generated class from Pigeon that represents data sent in messages. */
data class PlaybackStatusChangedEvent (
  val status: PlaybackStatus
) : PlaybackEvent()
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PlaybackStatusChangedEvent {
      val status = pigeonVar_list[0] as PlaybackStatus
      return PlaybackStatusChangedEvent(status)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      status,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class PlaybackPositionChangedEvent (
  val position: Long
) : PlaybackEvent()
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PlaybackPositionChangedEvent {
      val position = pigeonVar_list[0] as Long
      return PlaybackPositionChangedEvent(position)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      position,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class PlaybackSpeedChangedEvent (
  val speed: Double
) : PlaybackEvent()
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PlaybackSpeedChangedEvent {
      val speed = pigeonVar_list[0] as Double
      return PlaybackSpeedChangedEvent(speed)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      speed,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class VolumeChangedEvent (
  val volume: Double
) : PlaybackEvent()
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): VolumeChangedEvent {
      val volume = pigeonVar_list[0] as Double
      return VolumeChangedEvent(volume)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      volume,
    )
  }
}

/**
 * Emitted when the video loaded successfully and it's ready to play.
 * At this point, [videoInfo] is available.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
 class PlaybackReadyEvent (
) : PlaybackEvent()
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PlaybackReadyEvent {
      return PlaybackReadyEvent()
    }
  }
  fun toList(): List<Any?> {
    return listOf(
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
 class PlaybackEndedEvent (
) : PlaybackEvent()
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PlaybackEndedEvent {
      return PlaybackEndedEvent()
    }
  }
  fun toList(): List<Any?> {
    return listOf(
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class PlaybackErrorEvent (
  val errorMessage: String
) : PlaybackEvent()
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): PlaybackErrorEvent {
      val errorMessage = pigeonVar_list[0] as String
      return PlaybackErrorEvent(errorMessage)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      errorMessage,
    )
  }
}
private open class ApiPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as Long?)?.let {
          VideoSourceType.ofRaw(it.toInt())
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as Long?)?.let {
          PlaybackStatus.ofRaw(it.toInt())
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          VideoSource.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          VideoInfo.fromList(it)
        }
      }
      133.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PlaybackStatusChangedEvent.fromList(it)
        }
      }
      134.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PlaybackPositionChangedEvent.fromList(it)
        }
      }
      135.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PlaybackSpeedChangedEvent.fromList(it)
        }
      }
      136.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          VolumeChangedEvent.fromList(it)
        }
      }
      137.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PlaybackReadyEvent.fromList(it)
        }
      }
      138.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PlaybackEndedEvent.fromList(it)
        }
      }
      139.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PlaybackErrorEvent.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is VideoSourceType -> {
        stream.write(129)
        writeValue(stream, value.raw)
      }
      is PlaybackStatus -> {
        stream.write(130)
        writeValue(stream, value.raw)
      }
      is VideoSource -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is VideoInfo -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      is PlaybackStatusChangedEvent -> {
        stream.write(133)
        writeValue(stream, value.toList())
      }
      is PlaybackPositionChangedEvent -> {
        stream.write(134)
        writeValue(stream, value.toList())
      }
      is PlaybackSpeedChangedEvent -> {
        stream.write(135)
        writeValue(stream, value.toList())
      }
      is VolumeChangedEvent -> {
        stream.write(136)
        writeValue(stream, value.toList())
      }
      is PlaybackReadyEvent -> {
        stream.write(137)
        writeValue(stream, value.toList())
      }
      is PlaybackEndedEvent -> {
        stream.write(138)
        writeValue(stream, value.toList())
      }
      is PlaybackErrorEvent -> {
        stream.write(139)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface NativeVideoPlayerHostApi {
  fun loadVideo(source: VideoSource)
  fun getVideoInfo(): VideoInfo
  fun play(speed: Double)
  fun pause()
  fun stop()
  fun isPlaying(): Boolean
  fun seekTo(position: Long)
  fun getPlaybackPosition(): Long
  fun setVolume(volume: Double)
  fun getVolume(): Double
  fun setPlaybackSpeed(speed: Double)
  fun getPlaybackSpeed(): Double

  companion object {
    /** The codec used by NativeVideoPlayerHostApi. */
    val codec: MessageCodec<Any?> by lazy {
      ApiPigeonCodec()
    }
    /** Sets up an instance of `NativeVideoPlayerHostApi` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: NativeVideoPlayerHostApi?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.loadVideo$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val sourceArg = args[0] as VideoSource
            val wrapped: List<Any?> = try {
              api.loadVideo(sourceArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.getVideoInfo$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.getVideoInfo())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.play$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val speedArg = args[0] as Double
            val wrapped: List<Any?> = try {
              api.play(speedArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.pause$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              api.pause()
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.stop$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              api.stop()
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.isPlaying$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.isPlaying())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.seekTo$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val positionArg = args[0] as Long
            val wrapped: List<Any?> = try {
              api.seekTo(positionArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.getPlaybackPosition$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.getPlaybackPosition())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.setVolume$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val volumeArg = args[0] as Double
            val wrapped: List<Any?> = try {
              api.setVolume(volumeArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.getVolume$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.getVolume())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.setPlaybackSpeed$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val speedArg = args[0] as Double
            val wrapped: List<Any?> = try {
              api.setPlaybackSpeed(speedArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_video_player.NativeVideoPlayerHostApi.getPlaybackSpeed$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.getPlaybackSpeed())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
class NativeVideoPlayerFlutterApi(private val binaryMessenger: BinaryMessenger, private val messageChannelSuffix: String = "") {
  companion object {
    /** The codec used by NativeVideoPlayerFlutterApi. */
    val codec: MessageCodec<Any?> by lazy {
      ApiPigeonCodec()
    }
  }
  fun onPlaybackEvent(eventArg: PlaybackEvent, callback: (Result<Unit>) -> Unit)
{
    val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
    val channelName = "dev.flutter.pigeon.native_video_player.NativeVideoPlayerFlutterApi.onPlaybackEvent$separatedMessageChannelSuffix"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(eventArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
}
