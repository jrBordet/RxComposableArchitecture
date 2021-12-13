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

class CounterViewController: UIViewController, StoreViewController {
	var store: Store<CounterState, CounterAction>?
	
	typealias Value = CounterState
	typealias Action = CounterAction
	
	@IBOutlet var decrButton: UIButton!
	@IBOutlet var counterLabel: UILabel!
	@IBOutlet var incrButton: UIButton!
	@IBOutlet var isPrimeButton: UIButton!
	@IBOutlet var addButton: UIButton!

	private let disposeBag = DisposeBag()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		guard let store = self.store else {
			fatalError()
		}
		
		store.state
			.map { $0.count }
			.map { String($0) }
			.asDriver(onErrorJustReturn: "")
			.drive(self.counterLabel.rx.text)
			.disposed(by: disposeBag)
		
		incrButton.rx
			.tap
			.bind(to: store.rx.incr)
			.disposed(by: disposeBag)
		
		decrButton.rx
			.tap
			.bind(to: store.rx.decr)
			.disposed(by: disposeBag)
		
		isPrimeButton.rx
			.tap
			.debounce(.seconds(1), scheduler: MainScheduler.instance)
			//.throttle(.seconds(3), scheduler: MainScheduler.instance)
			.bind(to: store.rx.isPrime)
			.disposed(by: disposeBag)
		
		store.state
			.map { $0.isLoading }
			.bind(to: SwiftSpinner.shared.rx_visible)
			.disposed(by: disposeBag)
				
		store.state
			.map { $0.isPrime }
			.ignoreNil()
			.map { $0 ? "yep" : "nope" }
			.messageAlertController {
				store.send(CounterAction.resetPrime)
			}
            .bind(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
		
		addButton.rx
			.tap
			//.debounce(.milliseconds(280), scheduler: MainScheduler.instance)
			.flatMapLatest { v -> Observable<Bool> in
				store.state
					.take(1)
					.map { (fav: $0.favorites, counter: $0.count) }
					.map { $0.contains($1) } // true: remove; false: add
			}
			.bind(to: store.rx.addRemove)
			.disposed(by: disposeBag)
		
		store.state
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
