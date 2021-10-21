# RxComposableArchitecture


## Installation

To run the project, clone the repo, and run `make setup` and `pod install` from the root directory first.

```ruby
source 'https://github.com/jrBordet/Sources.git'
source 'https://cdn.cocoapods.org/'

target 'Target' do

pod 'RxComposableArchitecture', '2.0.0'

  target 'TargetTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxComposableArchitectureTests', '2.0.0'
  end

end

```

```ruby
make setup

pod install
```

### Case Studies
* [CoachTimer](https://github.com/jrBordet/CoachTimer)
* [GithubStargazers](https://github.com/jrBordet/GithubStargazers)
* [WhoSings](https://github.com/jrBordet/WhoSings)

## Frameworks


| Pod               | Version         
| -------------     |:-------------:| 
| RxSwift           | 6.2.x         |
| RxCocoa           | 6.2.x         |


## Author

Jean Raphaël Bordet, jr.bordet@gmail.com

## License

RxComposableArchitecture is available under the MIT license. See the LICENSE file for more info.
