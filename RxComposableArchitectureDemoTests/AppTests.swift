//
//  CounterViewTests.swift
//  RxComposableArchitectureDemoTests
//
//  Created by Jean Raphael Bordet on 24/08/21.
//

import XCTest
@testable import RxComposableArchitectureDemo
import Login
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa

class AppTests: XCTestCase {
	let initialValue = AppState(counter: .empty, favorites: .empty)
	
	let env = AppEnvironment { _ -> Effect<Bool> in
		Effect.sync { true }
	}
	
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
