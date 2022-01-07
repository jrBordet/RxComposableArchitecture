//
//  LensLoginTests.swift
//  RxComposableArchitectureDemoTests
//
//  Created by Jean Raphael Bordet on 17/08/21.
//

import XCTest
@testable import RxComposableArchitectureDemo
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa
import RxTest

class CounterTests: XCTestCase {
	var disposeBag = DisposeBag()

	let scheduler = TestScheduler.default()

	func testCounterIncr() {
		let store = TestStore(
			initialState: CounterState.empty,
			reducer: counterReducer,
			environment: CounterEnvironment(
				mainQueue: scheduler,
				isPrime: { value in
					Effect(value: .success(true))
				},
				trivia: { _ in
					fatalError()
				}
			)
		)
		
		store.assert(
			.send(CounterAction.incrTapped, { state in
				state.count = 1
			}),

			.send(.isPrime, { state in
				state.isLoading = true
				state.isPrime = nil
			}),
			.do {
				self.scheduler.advance(by: 1)
			},
			.receive(.isPrimeResponse(.success(true)), {
				$0.isLoading = false
				$0.isPrime = true
			})
			
		)
	}
	
}

//class CounterTests: XCTestCase {
//	
//	let initialValue = CounterState.empty
//	
//	let env: CounterEnvironment = (
//		isPrime: { _ in
//			Effect.sync { .success(true) }
//		},
//		trivia: { (v: Int) in
//			Effect.sync { "\(v) is awesome" }
//		}
//	)
//	
//	func testCounterIncr() {
//		assert(
//			initialValue: initialValue,
//			reducer: counterReducer,
//			environment: env,
//			steps: Step(.send, .incrTapped, { state in
//				state.count = 1
//			}),
//			Step(.send, .incrTapped, { state in
//				state.count = 2
//			})
//		)
//	}
//	
//	func testCounterDecr() {
//		assert(
//			initialValue: initialValue,
//			reducer: counterReducer,
//			environment: env,
//			steps: Step(.send, .decrTapped, { state in
//				state.count = -1
//			}),
//			Step(.send, .decrTapped, { state in
//				state.count = -2
//			})
//		)
//	}
//	
//	func testCounterIsPrime() {
//		assert(
//			initialValue: initialValue,
//			reducer: counterReducer,
//			environment: env,
//			steps: Step(.send, .incrTapped, { state in
//				state.count = 1
//			}),
//			Step(.send, .incrTapped, { state in
//				state.count = 2
//			}),
//			Step(.send, .isPrime, { state in
//				state.isLoading = true
//			}),
//			Step(.receive, CounterAction.isPrimeResponse(.success(true)), { state in
//				state.isPrime = true
//				state.isLoading = false
//			})
//		)
//	}
//	
//	func testCounterAddFavorite() {
//		assert(
//			initialValue: initialValue,
//			reducer: counterReducer,
//			environment: env,
//			steps: Step(.send, .incrTapped, { state in
//				state.count = 1
//			}),
//			Step(.send, .incrTapped, { state in
//				state.count = 2
//			}),
//			Step(.send, .addFavorite, { state in
//				state.favorites = [2]
//			})
//		)
//	}
//	
//	func testCounterRemoveFavorite() {
//		let initialValue = CounterState(
//			count: 0,
//			isLoading: false,
//			isPrime: false,
//			favorites: [2, 3, 5, 7]
//		)
//		
//		assert(
//			initialValue: initialValue,
//			reducer: counterReducer,
//			environment: env,
//			steps: Step(.send, .incrTapped, { state in
//				state.count = 1
//			}),
//			Step(.send, .incrTapped, { state in
//				state.count = 2
//			}),
//			Step(.send, CounterAction.removeFavorite, { state in
//				state.favorites = [3, 5, 7]
//			})
//		)
//	}
//	
//}
