import Flutter
import AVFoundation

class NativeVideoPlayerController: NSObject, NativeVideoPlayerHostApi {
    let player: AVPlayer
    private let flutterApi: NativeVideoPlayerFlutterApi
    
    init(messenger: FlutterBinaryMessenger, viewId: Int64) {
        self.player = AVPlayer(playerItem: nil)
        self.flutterApi = NativeVideoPlayerFlutterApi(
            binaryMessenger: messenger,
            messageChannelSuffix: String(viewId))
        super.init()
        
        player.addObserver(self, forKeyPath: "status", context: nil)
        
        // Allow audio playback when the Ring/Silent switch is set to silent
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            flutterApi.onPlaybackEvent(
                event: PlaybackErrorEvent(errorMessage: "Failed to set audio session category: \(error.localizedDescription)")
            ) { _ in }
        }
    }
    
    func dispose() {
        removePlayerItemObservers()
        player.removeObserver(self, forKeyPath: "status")
        player.replaceCurrentItem(with: nil)
    }
    
    func loadVideo(source: VideoSource) throws {
        let isUrl = source.type == .network
        
        guard let uri = isUrl
            ? URL(string: source.path)
            : URL(fileURLWithPath: source.path)
        else {
            return
        }

        let videoAsset = isUrl 
            ? AVURLAsset(url: uri, options: ["AVURLAssetHTTPHeaderFieldsKey": source.headers]) 
            : AVAsset(url: uri)
        
        if !videoAsset.isPlayable {
            flutterApi.onPlaybackEvent(event: PlaybackErrorEvent(errorMessage: "Video is not playable")) { _ in }
            return
        }

        // loadVideo can be called multiple times,
        // so we need to remove the previous observers
        if player.currentItem != nil {
            removePlayerItemObservers()
        }

        let playerItem = AVPlayerItem(asset: videoAsset)
        player.replaceCurrentItem(with: playerItem)

        addPlayerItemObservers()
    }

    func getVideoInfo() throws -> VideoInfo {
        guard 
            let videoTrack = player.currentItem?.asset.tracks(withMediaType: .video).first,
            let duration = player.currentItem?.asset.duration else {
            return VideoInfo(height: 0, width: 0, durationInMilliseconds: 0)
        }
        let durationInMilliseconds = duration.isValid 
            ? duration.seconds * 1000 
            : 0
        
        return VideoInfo(
            height: Int64(videoTrack.naturalSize.height),
            width: Int64(videoTrack.naturalSize.width),
            durationInMilliseconds: Int64(durationInMilliseconds)
        )
    }

    func play(speed: Double) throws {
        player.rate = Float(speed)
    }

    func pause() throws {
        player.rate = 0.0
    }

    func stop() throws {
        player.rate = 0.0
        player.seek(to: .zero)
    }

    func isPlaying() throws -> Bool {
        return player.rate != 0 && player.error == nil
    }

    func seekTo(position: Int64) throws {
        let positionInMilliseconds = CMTimeMake(value: position, timescale: 1000)
        player.seek(
            to: positionInMilliseconds,
            toleranceBefore: .zero,
            toleranceAfter: .zero)
    }

    func getPlaybackPosition() throws -> Int64 {
        let currentTime = player.currentItem?.currentTime() ?? .zero
        let positionInMilliseconds = currentTime.isValid
            ? currentTime.seconds * 1000
            : 0
        return Int64(positionInMilliseconds)
    }

    func setPlaybackSpeed(speed: Double) throws {
        player.rate = Float(speed)
    }

    func setVolume(volume: Double) throws {
        player.volume = Float(volume)
    }
    
    override public func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "status" {
            // print("AVPlayer status changed to: \(player.status)")
            switch (player.status) {
            case .unknown:
                break
            case .readyToPlay:
                flutterApi.onPlaybackEvent(
                    event: PlaybackReadyEvent()
                ) { _ in }
                break
            case .failed:
                if let error = player.error {
                    flutterApi.onPlaybackEvent(
                        event: PlaybackErrorEvent(errorMessage: error.localizedDescription)
                    ) { _ in }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Player Item Notifications
    
    private let playerItemNotifications: [NSNotification.Name] = [
        // A notification the system posts when a player item plays to its end time.
        AVPlayerItem.didPlayToEndTimeNotification,
        // A notification that the system posts when a player item fails to play to its end time.
        // AVPlayerItem.failedToPlayToEndTimeNotification,
        // A notification the system posts when a player item's time changes discontinuously.
        // AVPlayerItem.timeJumpedNotification,
        // A notification the system posts when a player item media doesn't arrive in time to continue playback.
        // AVPlayerItem.playbackStalledNotification,
        // A notification the player item posts when its media selection changes.
        // AVPlayerItem.mediaSelectionDidChangeNotification,
        // A notification the player item posts when its offset from the live time changes.
        // AVPlayerItem.recommendedTimeOffsetFromLiveDidChangeNotification,
        // A notification the system posts when a player item adds a new entry to its access log.
        // AVPlayerItem.newAccessLogEntryNotification,
        // A notification the system posts when a player item adds a new entry to its error log.
        // AVPlayerItem.newErrorLogEntryNotification
    ]
    
    @objc
    private func onPlayerItemNotification(notification: NSNotification) {
        // print("AVPlayerItem notification: \(notification.name)")
        switch notification.name {
        case AVPlayerItem.didPlayToEndTimeNotification:
            flutterApi.onPlaybackEvent(event: PlaybackEndedEvent()) { _ in }
            break
//        case AVPlayerItem.failedToPlayToEndTimeNotification:
//            break
//        case AVPlayerItem.timeJumpedNotification:
//            break
//        case AVPlayerItem.playbackStalledNotification:
//            break
//       case AVPlayerItem.mediaSelectionDidChangeNotification:
//           break
//       case AVPlayerItem.recommendedTimeOffsetFromLiveDidChangeNotification:
//           break
//        case AVPlayerItem.newAccessLogEntryNotification:
//            break
//        case AVPlayerItem.newErrorLogEntryNotification:
//            break
        default:
            break
        }
    }

    private func addPlayerItemObservers() {
        for notification in playerItemNotifications {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(onPlayerItemNotification(notification:)),
                name: notification,
                object: player.currentItem)
        }
    }

    private func removePlayerItemObservers() {
        for notification in playerItemNotifications {
            NotificationCenter.default.removeObserver(
                self,
                name: notification,
                object: player.currentItem)
        }
    }
}
