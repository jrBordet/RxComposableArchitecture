Pod::Spec.new do |spec|
  spec.name         = 'RxComposableArchitecture'
  spec.version      = '2.1.3'
  spec.license      = 'MIT'
  spec.summary      = 'A Rx version of ComposableArchitecture.'
  spec.homepage     = 'https://github.com/jrBordet/RxComposableArchitecture.git'
  spec.author       = 'Jean Raphaël Bordet'
  spec.source       = { :git => 'https://github.com/jrBordet/RxComposableArchitecture.git', :tag => spec.version.to_s }
  spec.source_files = 'RxComposableArchitecture/**/*.{swift}'
  spec.requires_arc = true
  spec.ios.deployment_target = '10.0'
  spec.dependency 'RxSwift', '6.2.0'
  spec.dependency 'RxCocoa', '6.2.0'
  spec.dependency 'SwiftSpinner', '~> 2.1.0'
end
