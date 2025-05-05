import AVFoundation
import Cocoa
import FlutterMacOS

public class NativeVideoPlayerViewFactory: NSObject, FlutterPlatformViewFactory {
    public static let id = "native_video_player_view"

    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    public func create(
        withViewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> NSView {
        return NativeVideoPlayerView(
            messenger: messenger,
            viewId: viewId
        )
    }
}

class NativeVideoPlayerView: NSView {
    private let messenger: FlutterBinaryMessenger
    private let playerLayer: AVPlayerLayer
    private let controller: NativeVideoPlayerController

    required init?(coder: NSCoder) {
        fatalError("init(coder:) - use init(frame:) instead")
    }

    init(
        messenger: FlutterBinaryMessenger,
        viewId: Int64
    ) {
        self.messenger = messenger

        self.controller = NativeVideoPlayerController(
            messenger: messenger,
            viewId: viewId)

        self.playerLayer = AVPlayerLayer(
            player: controller.player)

        super.init(frame: NSRect.zero)

        NativeVideoPlayerHostApiSetup.setUp(
            binaryMessenger: messenger,
            api: controller,
            messageChannelSuffix: String(viewId))

        setupView(viewId: viewId)
    }

    deinit {
        playerLayer.removeFromSuperlayer()

        controller.dispose()

        NativeVideoPlayerHostApiSetup.setUp(
            binaryMessenger: messenger,
            api: nil)
    }

    private func setupView(viewId: Int64) {
        playerLayer.videoGravity = .resize
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        layer?.addSublayer(playerLayer)
    }

    override func layout() {
        super.layout()
        playerLayer.frame = bounds
        playerLayer.removeAllAnimations()
    }
}
