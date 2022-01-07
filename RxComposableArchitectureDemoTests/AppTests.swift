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

//let counterEnvironment: CounterEnvironment = (
//	isPrime: { _ in
//		Effect.sync { Result<Bool, NSError>.success(true) }
//	},
//	trivia: { (v: Int) in
//		Effect.sync { "\(v) is awesome" }
//	}
//)
//
//class AppTests: XCTestCase {
//	let initialValue = AppState(counter: .empty, favorites: .empty)
//	
//	let env = AppEnvironment(counter: counterEnvironment)
//	
//	func testCounterViewAddFavorite() {
//		assert(
//			initialValue: initialValue,
//			reducer: appReducer,
//			environment: env,
//			steps: Step(.send, AppAction.counter(CounterAction.incrTapped), { state in
//				state.counter.count = 1
//			}),
//			Step(.send, AppAction.counter(CounterAction.incrTapped), { state in
//				state.counter.count = 2
//			}),
//			Step(.send, .counter(CounterAction.addFavorite), { state in				
//				state.counter.favorites = [2]
//				state.favorites = FavoritesState(selected: nil, favorites: [2], isPrime: nil)
//			}),
//			Step(.send, .counter(CounterAction.isPrime), { state in
//				state.counter.isLoading = true
//			}),
//			Step(.receive, AppAction.counter(CounterAction.isPrimeResponse(.success(true))), { state in
//				state.counter.isLoading = false
//				state.counter.isPrime = true
//			})
//		)
//	}
//	
//	func testCounterError() {
//		let counterEnvironment: CounterEnvironment = (
//			isPrime: { _ in
//				Effect.sync { Result<Bool, NSError>.failure(NSError(domain: "", code: 1, userInfo: nil)) }
//			},
//			trivia: { _ in fatalError() }
//		)
//		
//		let env = AppEnvironment(counter: counterEnvironment)
//		
//		assert(
//			initialValue: initialValue,
//			reducer: appReducer,
//			environment: env,
//			steps: Step(.send, AppAction.counter(CounterAction.decrTapped), { state in
//				state.counter.count = -1
//			}),
//			Step(.send, AppAction.counter(CounterAction.isPrime), { state in
//				state.counter.count = -1
//				state.counter.isLoading = true
//			}),
//			Step(.receive, AppAction.counter(CounterAction.isPrimeResponse(.failure(NSError(domain: "", code: 1, userInfo: nil)))), { state in
//				state.counter.isLoading = false
//				state.counter.isPrime = nil
//				state.genericError = GenericErrorState(title: "error", message: "something goes wrong")
//				state.counter.genericError = GenericErrorState(title: "error", message: "something goes wrong")
//			})
//		)
//	}
//	
//	
//}
