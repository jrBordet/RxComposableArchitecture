Pod::Spec.new do |spec|
  spec.name         = 'RxComposableArchitecture'
  spec.version      = '1.0.0'
  spec.license      = 'MIT'
  spec.summary      = 'An ergonomic library for Unit Tests based on RxComposableArchitecture.'
  spec.homepage     = 'https://github.com/jrBordet/RxComposableArchitecture.git'
  spec.author       = 'Jean Raphaël Bordet'
  spec.source       = { :git => 'https://github.com/jrBordet/RxComposableArchitecture.git', :tag => spec.version.to_s }
  spec.source_files = 'RxComposableArchitectureTests/**/*.{swift}'
  spec.requires_arc = true
  spec.ios.deployment_target = '10.0'
  spec.dependency 'RxSwift', '~> 5'
  spec.dependency 'RxCocoa', '~> 5'
end
