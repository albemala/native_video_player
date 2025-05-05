import Flutter
import UIKit
import AVFoundation

public class NativeVideoPlayerViewFactory: NSObject, FlutterPlatformViewFactory {
    public static let id = "native_video_player_view"

    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NativeVideoPlayerView(
            messenger: messenger,
            viewId: viewId,
            frame: frame
        )
    }
}

class NativeVideoPlayerView: UIView, FlutterPlatformView {
    private let messenger: FlutterBinaryMessenger
    private let playerLayer: AVPlayerLayer
    private let controller: NativeVideoPlayerController

    required init?(coder: NSCoder) {
        fatalError("init(coder:) - use init(frame:) instead")
    }

    init(
        messenger: FlutterBinaryMessenger,
        viewId: Int64,
        frame: CGRect
    ) {
        self.messenger = messenger

        self.controller = NativeVideoPlayerController(
            messenger: messenger,
            viewId: viewId)

        self.playerLayer = AVPlayerLayer(
            player: controller.player)

        super.init(frame: frame)

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
        
        backgroundColor = UIColor.clear
        layer.addSublayer(playerLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
        playerLayer.removeAllAnimations()
    }
    
    func view() -> UIView {
        return self
    }
}
