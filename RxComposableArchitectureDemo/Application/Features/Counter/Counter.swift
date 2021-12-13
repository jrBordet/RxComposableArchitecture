//
//  Counter.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 29/07/2020.
//

import Foundation
import RxComposableArchitecture

public let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
	switch action {
	case .incrTapped:
		state.count += 1
		return []
		
	case .decrTapped:
		state.count -= 1
		return []
		
	case .isPrime:
		state.isLoading = true
		return [
			environment.isPrime(state.count).map(CounterAction.isPrimeResponse)
		]
		
	case let .isPrimeResponse(.success(value)):
		state.isLoading = false
		state.isPrime = value
		state.genericError = nil
		
		return []
	
	case let .isPrimeResponse(.failure(e)):
		state.isLoading = false
		state.genericError = GenericErrorState(
			title: "error",
			message: "something goes wrong",
			isDismissed: false
		)
		
		return []
		
	case .addFavorite:
		state.favorites.append(state.count)
		return []
		
	case .removeFavorite:
		guard let index = find(value: state.count, in: state.favorites) else {
			return []
		}
		
		var copy = state.favorites
		
		copy.remove(at: index)
		
		state.favorites = copy
		return []
		
	case .resetPrime:
		state.isPrime = nil
		return []
		
	case .dismiss:
		state.genericError = nil
		
		return []
	}
}

private func find(value searchValue: Int, in array: [Int]) -> Int? {
	for (index, value) in array.enumerated() {
		if value == searchValue {
			return index
		}
	}
	
	return nil
}

public struct CounterState {
	var count: Int
	var isLoading: Bool
	
	var isPrime: Bool?
	
	var favorites: [Int]
	
	var genericError: GenericErrorState?
}

extension CounterState: Equatable { }

extension CounterState {
	public static let empty = Self(
		count: 0,
		isLoading: false,
		isPrime: nil,
		favorites: []
	)
}

extension CounterState {
	
	enum mock {
		static let sample = CounterState(
			count: 1,
			isLoading: false,
			isPrime: nil,
			favorites: []
		)
	}
	
}

// MARK: - Counter Action

public enum CounterAction: Equatable {
	case incrTapped
	
	case decrTapped
	
	case isPrime
	case isPrimeResponse(Result<Bool, NSError>)
	
	case addFavorite
	case removeFavorite
	
	case resetPrime
	
	case dismiss
}

// MARK: - Counter Environment

public typealias CounterEnvironment = (
	isPrime: (Int) -> Effect<Result<Bool, NSError>>,
	trivia: (Int) -> Effect<String>
)

let mock_counter_environment: CounterEnvironment = (
	isPrime: isprime,
	trivia: trivia
)

let trivia = { (v: Int) in
	Effect.sync { "\(v) is awesome" }
}

let isprime = { v in
	Effect.sync {
		isPrime(v)
	}
}
