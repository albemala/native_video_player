package me.albemala.native_video_player

import android.content.Context
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
import me.albemala.native_video_player.platform_interface.*

class NativeVideoPlayerViewController(
    messenger: BinaryMessenger,
    viewId: Int,
    context: Context,
    private val api: NativeVideoPlayerApi = NativeVideoPlayerApi(messenger, viewId),
) : PlatformView,
    NativeVideoPlayerApiDelegate,
    Player.Listener {

    private val player: ExoPlayer
    private val view: SurfaceView
    private val relativeLayout: RelativeLayout

    init {
        api.delegate = this
        player = ExoPlayer.Builder(context).build()
        player.addListener(this)

        view = SurfaceView(context)
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

        relativeLayout = RelativeLayout(context)
        relativeLayout.layoutParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        relativeLayout.addView(view)
    }

    override fun getView(): View {
        return relativeLayout
    }

    override fun dispose() {
        api.dispose()
        player.removeListener(this)
        player.release()
    }

    @OptIn(UnstableApi::class)
    override fun loadVideoSource(videoSource: VideoSource) {
        val mediaItem = MediaItem.fromUri(videoSource.path)
        when (videoSource.type) {
            VideoSourceType.Asset, VideoSourceType.File -> player.setMediaItem(mediaItem)
            VideoSourceType.Network -> {
                val dataSource = DefaultHttpDataSource.Factory().setDefaultRequestProperties(videoSource.headers)
                val mediaSource = ProgressiveMediaSource.Factory(dataSource).createMediaSource(mediaItem)
                player.setMediaSource(mediaSource)
            }
        }
        player.prepare()
    }

    override fun getVideoInfo(): VideoInfo {
        val videoSize = player.videoSize
        return VideoInfo(videoSize.height, videoSize.width, player.duration.toInt() / 1000)
    }

    override fun getPlaybackPosition(): Int {
        return player.currentPosition.toInt() / 1000
    }

    override fun play() {
        player.play()
    }

    override fun pause() {
        player.pause()
    }

    override fun stop() {
        player.stop()
    }

    override fun isPlaying(): Boolean {
        return player.isPlaying
    }

    override fun seekTo(position: Int) {
        player.seekTo(position.toLong() * 1000)
    }

    override fun setPlaybackSpeed(speed: Double) {
        player.setPlaybackSpeed(speed.toFloat())
    }

    override fun setVolume(volume: Double) {
        player.volume = volume.toFloat()
    }

    override fun setLoop(loop: Boolean) {
        player.repeatMode = if (loop) Player.REPEAT_MODE_ALL else Player.REPEAT_MODE_OFF
    }

    override fun onPlaybackStateChanged(@Player.State state: Int) {
        if (state == Player.STATE_READY) {
            return api.onPlaybackReady()
        }

        if (state == Player.STATE_ENDED) {
            return api.onPlaybackEnded()
        }
    }

    override fun onPlayerError(error: PlaybackException) {
        if (error.cause == null) {
            api.onError(Error("Unknown playback error occurred"))
        } else {
            api.onError(error.cause as Error)
        }
    }
}