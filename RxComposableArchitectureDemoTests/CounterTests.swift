//
//  LensLoginTests.swift
//  RxComposableArchitectureDemoTests
//
//  Created by Jean Raphael Bordet on 17/08/21.
//

import XCTest
@testable import RxComposableArchitectureDemo
import Login
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa

class CounterTests: XCTestCase {
	
	let initialValue = CounterState.empty
	
	let env: CounterEnvironment = { _ in
		Effect.sync {
			true
		}
	}
	
	func testCounterIncr() {
		assert(
			initialValue: initialValue,
			reducer: counterReducer,
			environment: env,
			steps: Step(.send, .incrTapped, { state in
				state.count = 1
			}),
			Step(.send, .incrTapped, { state in
				state.count = 2
			})
		)
	}
	
	func testCounterDecr() {
		assert(
			initialValue: initialValue,
			reducer: counterReducer,
			environment: env,
			steps: Step(.send, .decrTapped, { state in
				state.count = -1
			}),
			Step(.send, .decrTapped, { state in
				state.count = -2
			})
		)
	}
	
	func testCounterIsPrime() {
		assert(
			initialValue: initialValue,
			reducer: counterReducer,
			environment: env,
			steps: Step(.send, .incrTapped, { state in
				state.count = 1
			}),
			Step(.send, .incrTapped, { state in
				state.count = 2
			}),
			Step(.send, .isPrime, { state in
				state.isLoading = true
			}),
			Step(.receive, CounterAction.isPrimeResponse(true), { state in
				state.isPrime = true
			})
		)
	}
	
	func testCounterAddFavorite() {
		assert(
			initialValue: initialValue,
			reducer: counterReducer,
			environment: env,
			steps: Step(.send, .incrTapped, { state in
				state.count = 1
			}),
			Step(.send, .incrTapped, { state in
				state.count = 2
			}),
			Step(.send, .addFavorite, { state in
				state.favorites = [2]
			})
		)
	}
	
	func testCounterRemoveFavorite() {
		
		let initialValue = CounterState(
			count: 0,
			isLoading: false,
			isPrime: false,
			favorites: [2, 3, 5, 7]
		)
		
		assert(
			initialValue: initialValue,
			reducer: counterReducer,
			environment: env,
			steps: Step(.send, .incrTapped, { state in
				state.count = 1
			}),
			Step(.send, .incrTapped, { state in
				state.count = 2
			}),
			Step(.send, CounterAction.removeFavorite, { state in
				state.favorites = [3, 5, 7]
			})
		)
	}
	
}
