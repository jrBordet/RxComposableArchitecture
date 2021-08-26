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
			environment(state.count).map(CounterAction.isPrimeResponse)
		]
		
	case let .isPrimeResponse(value):
		state.isLoading = false
		state.isPrime = value
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
	case isPrimeResponse(Bool)
	
	case addFavorite
	case removeFavorite
	
	case resetPrime
}

// MARK: - Counter Environment

public typealias CounterEnvironment = (Int) -> Effect<Bool>

let mock_counter_environment: CounterEnvironment = { v in
	Effect.sync {
		isPrime(v)
	}
}
