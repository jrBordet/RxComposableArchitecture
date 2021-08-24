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
	
	var isPrime: Bool
	
	var favorites: [Int]
}

extension CounterState: Equatable { }

extension CounterState {
	public static let empty = Self(
		count: 0,
		isLoading: false,
		isPrime: false,
		favorites: []
	)
}

extension CounterState {
	
	enum mock {
		static let sample = CounterState(
			count: 1,
			isLoading: false,
			isPrime: false,
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
}

// MARK: - Counter Environment

public typealias CounterEnvironment = (Int) -> Effect<Bool>

// MARK: - Common

public struct PrimeAlert: Equatable, Identifiable {
	let prime: Int
	public var id: Int { self.prime }
}


public func isPrime (_ p: Int) -> Bool {
	if p <= 1 { return false }
	if p <= 3 { return true }
	
	for i in 2...Int(sqrtf(Float(p))) {
		if p % i == 0 { return false }
	}
	
	return true
}

let mock_counter_environment: CounterEnvironment = { v in
	Effect.sync {
		isPrime(v)
	}
}
