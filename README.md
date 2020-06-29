# RxComposableArchitecture


## Installation

To run the project, clone the repo, and run `pod install` from the root directory first.

```ruby
source 'https://github.com/jrBordet/Sources.git'
source 'https://cdn.cocoapods.org/'

target 'Target' do

pod 'RxComposableArchitecture', '1.0.0'

  target 'TargetTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxComposableArchitectureTests', '1.0.0'
  end

end

```

```ruby
pod install
```

## Frameworks


| Pod               | Version         
| -------------     |:-------------:| 
| RxSwift           | 5.0.x         |
| RxCocoa           | 5.0.x         |


## Author

Jean Raphaël Bordet, jr.bordet@gmail.com

## License

RxComposableArchitecture is available under the MIT license. See the LICENSE file for more info.
