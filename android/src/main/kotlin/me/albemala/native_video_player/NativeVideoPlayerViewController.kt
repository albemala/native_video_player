package me.albemala.native_video_player

import NativeVideoPlayerFlutterApi
import NativeVideoPlayerHostApi
import PlaybackEndedEvent
import PlaybackErrorEvent
import PlaybackReadyEvent
import VideoInfo
import VideoSource
import VideoSourceType
import android.content.Context
import android.net.Uri
import android.view.SurfaceView
import android.view.View
import android.widget.RelativeLayout
import androidx.annotation.OptIn
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.source.ProgressiveMediaSource
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView

class NativeVideoPlayerViewController(
    private val messenger: BinaryMessenger,
    viewId: Int,
    context: Context?,
) : PlatformView, NativeVideoPlayerHostApi, Player.Listener {

    private val player: ExoPlayer = ExoPlayer.Builder(context!!).build()
    private val view: SurfaceView = SurfaceView(context)
    private val relativeLayout: RelativeLayout = RelativeLayout(context)

    private val flutterApi = NativeVideoPlayerFlutterApi(
        messenger,
        messageChannelSuffix = viewId.toString(),
    )

    override fun getView(): View {
        return relativeLayout
    }

    init {
        NativeVideoPlayerHostApi.setUp(
            messenger,
            this,
            messageChannelSuffix = viewId.toString(),
        )
        player.addListener(this)
        initViews()
    }

    private fun initViews() {
        view.setBackgroundColor(0)

        val layoutParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT)
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP)
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT)
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM)
        view.layoutParams = layoutParams
        player.setVideoSurfaceView(view)

        relativeLayout.layoutParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        relativeLayout.addView(view)
    }

    override fun dispose() {
        NativeVideoPlayerHostApi.setUp(messenger, null)
        relativeLayout.removeAllViews()
        if (player.mediaItemCount > 0) {
            player.removeMediaItem(0)
        }
        player.setVideoSurfaceView(null)
        player.removeListener(this)
        player.release()
    }

    override fun onPlaybackStateChanged(state: Int) {
        when (state) {
            Player.STATE_READY -> flutterApi.onPlaybackEvent(PlaybackReadyEvent()) { _ -> }
            Player.STATE_ENDED -> flutterApi.onPlaybackEvent(PlaybackEndedEvent()) { _ -> }
            Player.STATE_BUFFERING -> {}
            Player.STATE_IDLE -> {}
        }
    }

    override fun onPlayerError(error: PlaybackException) {
        val errorMessage = error.cause?.message ?: "Unknown playback error occurred"
        flutterApi.onPlaybackEvent(PlaybackErrorEvent(errorMessage)) { _ -> }
    }

    @OptIn(UnstableApi::class)
    override fun loadVideo(source: VideoSource) {
        player.stop()
        if (player.mediaItemCount > 0) {
            player.removeMediaItem(0)
        }

        when (source.type) {
            VideoSourceType.ASSET,
            VideoSourceType.FILE -> {
                val mediaItem = MediaItem.fromUri(source.path)
                player.setMediaItem(mediaItem)
            }

            VideoSourceType.NETWORK -> {
                val mediaItem = MediaItem.fromUri(Uri.parse(source.path))
                val headers = source.headers ?: mapOf()
                val dataSource =
                    DefaultHttpDataSource.Factory().setDefaultRequestProperties(headers)
                val mediaSource =
                    ProgressiveMediaSource.Factory(dataSource).createMediaSource(mediaItem)
                player.setMediaSource(mediaSource)
            }
        }
        player.prepare()
    }

    override fun getVideoInfo(): VideoInfo {
        val videoSize = player.videoSize
        return VideoInfo(videoSize.height.toLong(), videoSize.width.toLong(), player.duration)
    }

    override fun getPlaybackPosition(): Long {
        return player.currentPosition
    }

    override fun play(speed: Double) {
        player.play()
        setPlaybackSpeed(speed)
    }

    override fun pause() {
        player.pause()
    }

    override fun stop() {
        player.pause()
        player.seekTo(0)
    }

    override fun isPlaying(): Boolean {
        return player.isPlaying
    }

    override fun seekTo(position: Long) {
        player.seekTo(position)
    }

    override fun setPlaybackSpeed(speed: Double) {
        player.setPlaybackSpeed(speed.toFloat())
    }

    override fun setVolume(volume: Double) {
        player.volume = volume.toFloat()
    }
}