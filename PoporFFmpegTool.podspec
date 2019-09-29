#
# Be sure to run `pod lib lint PoporFFmpegTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PoporFFmpegTool'
  s.version          = '0.02'
  s.summary          = 'ios10以上使用FFmpeg4.2lib,以下的只能用3.1lib.'

  s.homepage         = 'https://github.com/popor/PoporFFmpegTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangkq' => '908891024@qq.com' }
  s.source           = { :git => 'https://github.com/popor/PoporFFmpegTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PoporFFmpegTool/Classes/**/*'
  
  s.dependency 'mobile-ffmpeg-full'
  
end
