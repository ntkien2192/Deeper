#
# Be sure to run `pod lib lint Deeper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Deeper'
  s.version          = '0.3.8'
  s.summary          = 'The perfect interface framework for your software'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: We try to create a interface framework that can meet the needs of a programmer from welcome, sign-up to more complex functions such as details, master pages.
                       DESC

  s.homepage         = 'https://github.com/ntkien2192/Deeper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ntkien2192' => 'ntkien2192@gmail.com' }
  s.source           = { :git => 'https://github.com/ntkien2192/Deeper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.4'
  s.swift_version = '5.0'

  s.source_files = 'Deeper/Classes/**/*'
  
   s.resource_bundles = {
     'Deeper' => ['Deeper/Classes/**/*.{storyboard,xib,otf}', 'Deeper/Assets/**/*.{xcassets,pdf}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
#   s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'RxSwift', '~> 5'
   s.dependency 'RxCocoa', '~> 5'
   s.dependency 'RealmSwift'
   s.dependency 'SDWebImage/WebP'
end
