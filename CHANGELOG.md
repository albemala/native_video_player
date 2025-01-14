## 3.0.0-dev.2

- Improved error reporting on android
- Improved example

## 3.0.0-dev.1

- Targeting Dart 3.5 and Flutter 3.24
- API redesign using events instead of callbacks
- Removed `PlaybackInfo` class - all information now accessible directly from controller
- Controllers must now be explicitly disposed using `dispose()` method
- Removed `init` constructor from `VideoSource` class
- `seekTo` and playback position values now use `Duration` instead of seconds (#26)
- Fixed audio playback on iOS when device is in silent mode (#22)

## 2.0.0

- Added support for sending optional headers to the native players to stream videos behind authentication (thanks to @shenlong-tanwen)
- Notify when video isn't playable on iOS (thanks to @ashilkn)
- Upgrading to Gradle 8 (thanks to @Pablo-Aldana)
- minSdkVersion on Android is now 21
- Upgraded dependencies

## 1.3.1

- Fixed #10 
- Split example into multiple files 
- Upgraded dependencies 

## 1.3.0

- Targeting Dart 3.0 and Flutter 3.10

## 1.2.0+3

- BREAKING: `NativeVideoPlayerController` now throws exceptions that must be handled by the caller.
- Added new method to set playback speed
- Exposed more controller events (playback speed and volume changed)

## 1.1.0+2

- Fixed gifs not showing in Readme

## 1.1.0

- Targeting Flutter 3

## 1.0.3

- Fixed publishing error

## 1.0.2 

- Fixed videos not playing on iOS 14

## 1.0.1

- First public release
