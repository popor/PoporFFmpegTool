#
# Be sure to run `pod lib lint PoporFFmpegTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PoporFFmpegTool'
  s.version          = '0.03'
  s.summary          = ' 由于github不推荐超过100MB的framework，所以推荐用户自己pod引入。而且cocoapods老说RETURN_CODE_SUCCESS有问题。推荐使用3.1，4.2貌似有问题。3.1已经开始x264，压制的视频可以再chrome等浏览器上播放。'

  s.homepage         = 'https://github.com/popor/PoporFFmpegTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'popor' => '908891024@qq.com' }
  s.source           = { :git => 'https://github.com/popor/PoporFFmpegTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'PoporFFmpegTool/Classes/**/*'
  
end
