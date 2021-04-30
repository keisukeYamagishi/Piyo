#
#  Be sure to run `pod spec lint Piyo.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "Piyo"
  spec.version      = "1.0.2"
  spec.summary      = "Piyo is a lightweight library for Twitter OAuth."
  spec.description  = <<-DESC
  Piyo is an authentication library that allows you to access a variety of APIs offered by Twitter.
Users who have installed Piyo will be asked to create as many Twitter posts and other features as they need for themselves.
Piyo only provides the bare essentials.
                   DESC

  spec.homepage     = "https://github.com/keisukeYamagishi/Piyo"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "keisukeYamagishi" => "jam330257@gmail.com" }
  spec.social_media_url   = "https://twitter.com/keisukeYamagishi"
  spec.platform     = :ios, "11.0"

  #  When using multiple platforms
  spec.ios.deployment_target = "11.0"
  spec.swift_version = '5.0'
  spec.source       = { :git => "https://github.com/keisukeYamagishi/Piyo.git", :tag => "#{spec.version}" }
  spec.source_files  = "Piyo", "Piyo/**/*.swift"
  spec.framework  = "Foundation"
end
