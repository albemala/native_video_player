#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint native_video_player.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'native_video_player'
  s.version          = '4.0.0-dev.1'
  s.summary          = 'A Flutter widget to play videos on iOS, macOS and Android using a native implementation.'
  s.description      = <<-DESC
A Flutter widget to play videos on iOS, macOS and Android using a native implementation.
                       DESC
  s.homepage         = 'https://pub.dev/packages/native_video_player'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Alberto Malagoli' => 'albemala@gmail.com' }
  s.source           = { :path => '.' }

  s.source_files     = 'Sources/*.swift'
  
  s.dependency 'Flutter'

  s.platform = :ios, '12.0'
  
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'native_video_player_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
