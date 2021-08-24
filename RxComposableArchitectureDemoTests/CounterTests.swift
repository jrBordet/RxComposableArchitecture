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
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testCounterView() {
		let initialValue = CounterViewState(
			counter: CounterState(
				count: 1,
				isLoading: false,
				isPrime: false,
				favorites: []
			),
			favorites: FavoritesState(
				selected: nil,
				favorites: [],
				isPrime: false
			)
		)
		
		let env = CounterViewEnvironment { _ -> Effect<Bool> in
			Effect.sync {
				true
			}
		}
		
		//		assert(
		//			initialValue: initialValue,
		//			reducer: counterViewReducer,
		//			environment: env,
		//			steps: Step(.send, CounterViewAction.counter(CounterAction.incrTapped), { state in
		//				state.counter.count = 2
		//			}),
		//			Step(.send, CounterViewAction.counter(CounterAction.addFavorite), { state in
		//				state.counter.count = 2
		//				state.counter.favorites = [2]
		//				state.favorites.favorites = [2]
		//			})
		//
		//		)
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
	
}
