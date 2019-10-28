#
# Be sure to run `pod lib lint Deeper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Deeper'
  s.version          = '0.1.2'
  s.summary          = 'Bộ giao diện tuyệt hảo cho phần mềm của bạn'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Chúng tôi cố gắng tạo ra một thư viện về giao diện để có thể đáp ứng các nhu cầu công việc của một người lập trình viên từ chào mừng, đăng nhập đăng kí tới các chức năng phức tạp hơn như thông tin chi tiết và trang chủ
                       DESC

  s.homepage         = 'https://github.com/ntkien2192/Deeper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ntkien2192' => 'ntkien2192@gmail.com' }
  s.source           = { :git => 'https://github.com/ntkien2192/Deeper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.4'
  s.swift_version = '4.0'
  s.source_files = 'Deeper/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Deeper' => ['Deeper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
   s.dependency 'RxSwift', '~> 5'
   s.dependency 'RxCocoa', '~> 5'
end
