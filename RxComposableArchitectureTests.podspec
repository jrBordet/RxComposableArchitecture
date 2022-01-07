Pod::Spec.new do |spec|
  spec.name         = 'RxComposableArchitectureTests'
  spec.version      = '2.1.3'
  spec.license      = 'MIT'
  spec.summary      = 'Utilities for Unit Testing with RxComposableArchitecture.'
  spec.homepage     = 'https://github.com/jrBordet/RxComposableArchitecture.git'
  spec.author       = 'Jean Raphaël Bordet'
  spec.source       = { :git => 'https://github.com/jrBordet/RxComposableArchitecture.git', :tag => spec.version.to_s }
  spec.source_files = 'RxComposableArchitectureTests/**/*.{swift}'
  spec.requires_arc = true
  spec.ios.deployment_target = '10.0'
  spec.dependency 'RxSwift', '6.2.0'
  spec.dependency 'RxCocoa', '6.2.0'
  spec.dependency 'RxTest', '6.2.0'
  spec.dependency 'RxBlocking', '6.2.0'
  spec.dependency 'RxComposableArchitecture', '4.0.0'
  spec.dependency 'Difference', '0.4'
  spec.weak_framework = 'XCTest'
end
