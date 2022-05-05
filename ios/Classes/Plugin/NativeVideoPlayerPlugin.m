#import "NativeVideoPlayerPlugin.h"
#if __has_include(<native_video_player/native_video_player-Swift.h>)
#import <native_video_player/native_video_player-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_video_player-Swift.h"
#endif

@implementation NativeVideoPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftNativeVideoPlayerPlugin registerWithRegistrar:registrar];
}
@end
