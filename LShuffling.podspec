#
# Be sure to run `pod lib lint LShuffling.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'LShuffling'
    s.version          = '0.0.2'
    s.summary          = 'a ShufflingView.'
    
    s.homepage         = 'https://github.com/liyonghui16/LShuffling'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'liyonghui16' => '18335103323@163.com' }
    s.source           = { :git => 'https://github.com/liyonghui16/LShuffling.git', :tag => s.version }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '9.0'
    s.swift_version = '4.0'
    s.dependency 'Kingfisher'
    
    s.source_files = 'LShuffling/Classes/*.swift'
    
end

