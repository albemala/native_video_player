import FlutterMacOS

public class NativeVideoPlayerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = NativeVideoPlayerViewFactory(messenger: registrar.messenger)
        registrar.register(factory, withId: NativeVideoPlayerViewFactory.id)
    }
}
