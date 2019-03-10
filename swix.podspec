#
#  Be sure to run `pod spec lint swix.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "swix"
  s.version      = "1.0.8"
  s.summary      = "Refactored version of https://github.com/stsievert/swix."

  s.description  = <<-DESC
  Refactored version of https://github.com/stsievert/swix.
                   DESC
  s.homepage     = "https://github.com/vasiliydumanov/swix"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Vasiliy Dumanov" => "vasiliy.dumanov@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = '12.0'
  s.source       = { :git => "https://github.com/vasiliydumanov/swix.git", :tag => "#{s.version}" }
  s.source_files  = "swix-ios/swix/*.swift", "swix-ios/swix/**/*.{h,m,mm,swift}"
  s.ios.vendored_frameworks = "swix-ios/opencv2.framework"
  s.swift_version = "4.2"

end
