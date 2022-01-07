//
//  CounterViewController.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 24/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxComposableArchitecture
import SwiftSpinner

extension CounterViewController {
	static let sample = CounterViewController(
		store: Store<CounterState, CounterAction>(
			initialState: CounterState.empty,
			reducer: counterReducer.debug(),
			environment: CounterEnvironment.live
		)
	)
}

class CounterViewController: UIViewController {
	@IBOutlet var decrButton: UIButton!
	@IBOutlet var counterLabel: UILabel!
	@IBOutlet var incrButton: UIButton!
	@IBOutlet var isPrimeButton: UIButton!
	@IBOutlet var addButton: UIButton!
		
	let viewStore: ViewStore<CounterState, CounterAction>
	var disposeBag = DisposeBag()

	init(store: Store<CounterState, CounterAction>) {
	  self.viewStore = ViewStore(store)
	  super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
	  fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
				
		decrButton.rx
			.tap
			.bind { [weak self] in self?.viewStore.send(.decrTapped) }
			.disposed(by: disposeBag)
		
		incrButton.rx
			.tap
			.bind { [weak self] in self?.viewStore.send(.incrTapped) }
			.disposed(by: disposeBag)
		
		viewStore.publisher
		  .map { "\($0.count)" }
		  .bind(to: counterLabel.rx.text)
		  .disposed(by: disposeBag)
		
		isPrimeButton.rx
			.tap
			.bind { [weak self] in self?.viewStore.send(.isPrime) }
			.disposed(by: disposeBag)
		
		
		viewStore.publisher
			.map { $0.isLoading }
			.bind(to: SwiftSpinner.shared.rx_visible)
			.disposed(by: disposeBag)
		
		viewStore.publisher
			.map { $0.isPrime }
			.ignoreNil()
			.map { $0 ? "yep" : "nope" }
			.messageAlertController { [weak self] in
				self?.viewStore.send(CounterAction.resetPrime)
			}
            .bind(to: self.rx.presentAlert)
            .disposed(by: disposeBag)

		addButton.rx
			.tap
			.flatMapLatest { [weak self] v -> Observable<Bool> in
				guard let self = self else {
					return .just(false)
				}
				
				return self.viewStore.publisher
					.take(1)
					.map { (fav: $0.favorites, counter: $0.count) }
					.map { $0.contains($1) } // true: remove; false: add
			}
			.bind { [weak self] value in
				if value {
					self?.viewStore.send(CounterAction.removeFavorite)
				} else {
					self?.viewStore.send(CounterAction.addFavorite)
				}
			}
			.disposed(by: disposeBag)
		
		viewStore
			.publisher
			.distinctUntilChanged()
			.map { (fav: $0.favorites, counter: $0.count) }
			.map { (fav: [Int], counter: Int) -> String in
				fav.contains(counter) ? "remove from favorites" : "add to favorites"
			}
			.map { $0.capitalized }
			.asDriver(onErrorJustReturn: "")
			.drive(addButton.rx.title(for: .normal))
			.disposed(by: disposeBag)
    
	}

}
