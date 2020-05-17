#
# Be sure to run `pod lib lint RxBinding.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxComposableArchitecture'
  s.version          = '1.0.0'
  s.summary          = 'A short description of RxComposableArchitecture.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      =

                        "Rx version of ComposableArchitecture"

  s.homepage         = 'https://github.com/jrBordet/RxComposableArchitecture.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jean Raphael Bordet' => 'jr.bordet@gmail.it' }
  s.source           = { :git => 'https://github.com/jrBordet/RxBinding.git', :tag => s.version.to_s }
  spec.social_media_url   = "https://twitter.com/jrBordet"

  s.ios.deployment_target = '10.0'

  spec.source_files  = "Classes", "RxComposableArchitecture/**/*.{swift}"
  spec.exclude_files = "Classes/Exclude"

  #spec.dependency 'RxSwift', '~> 5.0.0'
  #spec.dependency 'RxCocoa', '~> 5.0.0'
  #spec.dependency 'SwiftSpinner'

  end
