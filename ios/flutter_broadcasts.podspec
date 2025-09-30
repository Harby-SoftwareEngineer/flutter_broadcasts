#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_broadcasts.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_broadcasts'
  s.version          = '0.5.0'
  s.summary          = 'A plugin for sending and receiving broadcasts with Android intents and iOS notifications.'
  s.description      = <<-DESC
A plugin for sending and receiving broadcasts with Android intents and iOS notifications.
                       DESC
  s.homepage         = 'https://github.com/kevlatus/flutter_broadcasts'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'flutter_broadcasts' => 'maintainer@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  # Modern Flutter iOS build settings; i386 no longer supported; 16KB page size supported by setting minimum iOS.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.9'
end
