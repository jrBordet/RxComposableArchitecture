//
//  CounterViewTests.swift
//  RxComposableArchitectureDemoTests
//
//  Created by Jean Raphael Bordet on 24/08/21.
//

import XCTest
@testable import RxComposableArchitectureDemo
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa

let counterEnvironment: CounterEnvironment = (
	isPrime: { _ in
		Effect.sync { true }
	},
	trivia: { (v: Int) in
		Effect.sync { "\(v) is awesome" }
	}
)

class AppTests: XCTestCase {
	let initialValue = AppState(counter: .empty, favorites: .empty)
	
	let env = AppEnvironment(counter: counterEnvironment)
	
	func testCounterViewAddFavorite() {
		assert(
			initialValue: initialValue,
			reducer: appReducer,
			environment: env,
			steps: Step(.send, AppAction.counter(CounterAction.incrTapped), { state in
				state.counter.count = 1
			}),
			Step(.send, AppAction.counter(CounterAction.incrTapped), { state in
				state.counter.count = 2
			}),
			Step(.send, .counter(CounterAction.addFavorite), { state in				
				state.counter.favorites = [2]
				state.favorites = FavoritesState(selected: nil, favorites: [2], isPrime: nil)
			}),
			Step(.send, .counter(CounterAction.isPrime), { state in
				state.counter.isLoading = true
			}),
			Step(.receive, AppAction.counter(CounterAction.isPrimeResponse(true)), { state in
				state.counter.isLoading = false
				state.counter.isPrime = true
			})
		)
	}
	
}
