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
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.view.View
import android.widget.RelativeLayout
import android.widget.VideoView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView

class NativeVideoPlayerViewController(
    private val messenger: BinaryMessenger,
    viewId: Int,
    context: Context?,
) : PlatformView,
    NativeVideoPlayerHostApi,
    MediaPlayer.OnPreparedListener,
    MediaPlayer.OnCompletionListener,
    MediaPlayer.OnErrorListener {

    private var mediaPlayer: MediaPlayer? = null

    private val videoView: VideoView = VideoView(context)
    private val relativeLayout: RelativeLayout = RelativeLayout(context)

    private val flutterApi = NativeVideoPlayerFlutterApi(
        messenger,
        messageChannelSuffix = viewId.toString(),
    )

    init {
        videoView.setOnPreparedListener(this)
        videoView.setOnCompletionListener(this)
        videoView.setOnErrorListener(this)

        NativeVideoPlayerHostApi.setUp(
            messenger,
            this,
            messageChannelSuffix = viewId.toString(),
        )

        initViews()
    }

    private fun initViews() {
        videoView.setBackgroundColor(0)
        // videoView.setZOrderOnTop(true)

        val layoutParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT)
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP)
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT)
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM)
        videoView.layoutParams = layoutParams

        relativeLayout.layoutParams = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )
        relativeLayout.addView(videoView)
    }

    override fun getView(): View {
        return relativeLayout
    }

    override fun dispose() {
        videoView.stopPlayback()

        NativeVideoPlayerHostApi.setUp(messenger, null)

        videoView.setOnPreparedListener(null)
        videoView.setOnErrorListener(null)
        videoView.setOnCompletionListener(null)

        mediaPlayer = null
    }

    override fun onPrepared(mediaPlayer: MediaPlayer?) {
        this.mediaPlayer = mediaPlayer
        videoView.seekTo(1)
        flutterApi.onPlaybackEvent(PlaybackReadyEvent()) { _ -> }
    }

    override fun onCompletion(mediaPlayer: MediaPlayer?) {
        flutterApi.onPlaybackEvent(PlaybackEndedEvent()) { _ -> }
    }

    override fun onError(mediaPlayer: MediaPlayer?, what: Int, extra: Int): Boolean {
        flutterApi.onPlaybackEvent(PlaybackErrorEvent("MediaPlayer error: $what, $extra")) { _ -> }
        return true
    }

    override fun loadVideo(source: VideoSource) {
        videoView.stopPlayback()
        mediaPlayer = null
        when (source.type) {
            VideoSourceType.ASSET -> videoView.setVideoPath(source.path)
            VideoSourceType.FILE -> videoView.setVideoPath(source.path)
            VideoSourceType.NETWORK -> videoView.setVideoURI(Uri.parse(source.path), source.headers)
        }
    }

    override fun getVideoInfo(): VideoInfo {
        val height = mediaPlayer?.videoHeight?.toLong() ?: 0
        val width = mediaPlayer?.videoWidth?.toLong() ?: 0
        val duration = (videoView.duration).toLong()
        return VideoInfo(height, width, duration)
    }

    override fun getPlaybackPosition(): Long {
        return (videoView.currentPosition).toLong()
    }

    override fun play(speed: Double) {
        videoView.start()
        setPlaybackSpeed(speed)
    }

    override fun pause() {
        videoView.pause()
    }

    override fun stop() {
        videoView.pause()
        videoView.seekTo(0)
    }

    override fun isPlaying(): Boolean {
        return videoView.isPlaying
    }

    override fun seekTo(position: Long) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            mediaPlayer?.seekTo(position, MediaPlayer.SEEK_CLOSEST)
        else
            videoView.seekTo(position.toInt())
    }

    override fun setPlaybackSpeed(speed: Double) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            mediaPlayer?.playbackParams =
                mediaPlayer?.playbackParams?.setSpeed(speed.toFloat()) ?: return
    }

    override fun setVolume(volume: Double) {
        mediaPlayer?.setVolume(volume.toFloat(), volume.toFloat())
    }
}