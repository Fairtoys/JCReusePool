#
# Be sure to run `pod lib lint JCReusePool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JCReusePool'
  s.version          = '0.1.0'
  s.summary          = '一个复用池的简单实现demo'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
一个复用池的简单实现demo，供自己学习参考
                       DESC

  s.homepage         = 'https://github.com/Fairtoys/JCReusePool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '313574889@qq.com' => 'wangjunchao-hj@huajiao.tv' }
  s.source           = { :git => 'https://github.com/Fairtoys/JCReusePool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JCReusePool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JCReusePool' => ['JCReusePool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
