//
//  FavoritesTests.swift
//  RxComposableArchitectureDemoTests
//
//  Created by Jean Raphael Bordet on 23/08/21.
//

import XCTest
@testable import RxComposableArchitectureDemo
import Login
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa

class FavoritesTests: XCTestCase {
	
	let initialValue = FavoritesState.empty
	
	let env: CounterEnvironment = { _ in
		Effect.sync {
			true
		}
	}
	
	func testFavoritesSelecteAt0Empty() {
		assert(
			initialValue: initialValue,
			reducer: favoritesReducer,
			environment: env,
			steps: Step(.send, FavoritesAction.selectAt(0), { state in
				state.selected = nil
			})
		)
	}
	
	func testFavoritesSelecteAt0Filled() {
		let initialValue = FavoritesState(
			selected: nil,
			favorites: [2, 3],
			isPrime: false
		)
		
		assert(
			initialValue: initialValue,
			reducer: favoritesReducer,
			environment: env,
			steps: Step(.send, FavoritesAction.selectAt(0), { state in
				state.selected = 2
			})
		)
	}
	
	func testFavoritesSelecteAtOutOfRange() {
		let initialValue = FavoritesState(
			selected: nil,
			favorites: [2, 3],
			isPrime: false
		)
		
		assert(
			initialValue: initialValue,
			reducer: favoritesReducer,
			environment: env,
			steps: Step(.send, FavoritesAction.selectAt(2), { state in
				state.selected = nil
			}),
			Step(.send, FavoritesAction.selectAt(-1), { state in
				state.selected = nil
			})
			
		)
	}
	
	func testFavoritesIsPrime() {
		let initialValue = FavoritesState(
			selected: 2,
			favorites: [2, 3],
			isPrime: false
		)
		
		assert(
			initialValue: initialValue,
			reducer: favoritesReducer,
			environment: env,
			steps: Step(.send, FavoritesAction.isPrime, { state in
				state.selected = 2
			}),
			Step(.receive, FavoritesAction.isPrimeResponse(true), { state in
				state.isPrime = true
			})
			
		)
	}
	
	
	
}

