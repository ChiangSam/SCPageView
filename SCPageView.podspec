#
# Be sure to run `pod lib lint SCPageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SCPageView'
  s.version          = '0.1.0'
  s.summary          = '一个简单的基于 CollectionView 的 Banner 轮播'
  s.swift_version    = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  基于 UICollectionView 的 Banner 轮播图，用三个 Cell 实现，提供轮播图实现的一种方式
                       DESC

  s.homepage         = 'https://github.com/ChiangSam/SCPageView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SamChiang' => 'SamChiang' }
  s.source           = { :git => 'https://github.com/ChiangSam/SCPageView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SCPageView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SCPageView' => ['SCPageView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
