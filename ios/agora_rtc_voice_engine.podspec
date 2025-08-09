#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint agora_rtc_voice_engine.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'agora_rtc_voice_engine'
  s.version          = '0.0.1'
  s.summary          = 'Voice-only Agora RTC Flutter plugin iOS — wraps Agora Voice SDKs and exposes audio methods compatible with agora_rtc_engine\'s audio API.'
  s.description      = <<-DESC
Voice-only Agora RTC Flutter plugin iOS — wraps Agora Voice SDKs and exposes audio methods compatible with agora_rtc_engine\'s audio API.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Daniel Uwadi' => 'danieluwadi@yahoo.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.vendored_frameworks = 'Frameworks/AgoraRtcKit.xcframework', 'Frameworks/AgoraSoundTouch.xcframework'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
