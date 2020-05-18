Pod::Spec.new do |spec|
  spec.name         = 'RxComposableArchitecture'
  spec.version      = '1.0.0'
  spec.license      = 'MIT'
  spec.summary      = 'A Rx version of ComposableArchitecture.'
  spec.homepage     = 'https://github.com/jrBordet/RxComposableArchitecture.git'
  spec.author       = 'Jean Raphaël Bordet'
  spec.source       = { :git => 'https://github.com/jrBordet/RxComposableArchitecture.git', :tag => '1.0.0' }
  spec.source_files = 'RxComposableArchitecture/**/*.{swift}'
  spec.requires_arc = true
  spec.dependency 'RxSwift'
  spec.dependency 'RxCocoa'

end
