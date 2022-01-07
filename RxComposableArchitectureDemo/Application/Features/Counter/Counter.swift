//
//  Counter.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 29/07/2020.
//

import Foundation
import RxComposableArchitecture
import RxSwift

// MARK: - Business logic domain

public let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
	switch action {
	case .incrTapped:
		state.count += 1
		return .none
		
		
	case .decrTapped:
		state.count -= 1
		return .none
		
		
	case .isPrime:
		state.isLoading = true
		
		return environment
			.isPrime(state.count)
		//			     .delay(.seconds(1), scheduler: scheduler)
			.observe(on: environment.mainQueue)
			.map(CounterAction.isPrimeResponse)
			.eraseToEffect()
		
		//		return .none
		
		//		return [
		//			environment.isPrime(state.count).map(CounterAction.isPrimeResponse)
		//		]
		
	case let .isPrimeResponse(.success(value)):
		state.isLoading = false
		state.isPrime = value
		state.genericError = nil
		
		return .none
		
		
	case let .isPrimeResponse(.failure(e)):
		state.isLoading = false
		state.genericError = GenericErrorState(title: "error", message: "something goes wrong")
		
		return .none
		
		
	case .addFavorite:
		state.favorites.append(state.count)
		return .none
		
		
	case .removeFavorite:
		guard let index = find(value: state.count, in: state.favorites) else {
			return .none
			
		}
		
		var copy = state.favorites
		
		copy.remove(at: index)
		
		state.favorites = copy
		return .none
		
		
	case .resetPrime:
		state.isPrime = nil
		return .none
		
		
	case .dismiss:
		state.genericError = nil
		
		return .none
		
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

// MARK: - Feature domain

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

public struct CounterEnvironment {
	var mainQueue: SchedulerType
	var isPrime: (Int) -> Effect<Result<Bool, NSError>>
	var trivia: (Int) -> Effect<String>
}

extension CounterEnvironment {
	static func mock (
		mainQueue: SchedulerType = MainScheduler.instance,
		isPrime: @escaping (Int) -> Effect<Result<Bool, NSError>> = { _ in fatalError() },
		trivia: @escaping (Int) -> Effect<String> = { _ in fatalError() }
	) -> CounterEnvironment {
		.init(
			mainQueue: mainQueue,
			isPrime: isPrime,
			trivia: trivia
		)
	}
	
	//	static var mock: CounterEnvironment = .init(
	//		mainQueue: <#T##SchedulerType#>,
	//		isPrime: <#T##(Int) -> Effect<Result<Bool, NSError>>#>,
	//		trivia: <#T##(Int) -> Effect<String>#>
	//	)
}

//public typealias CounterEnvironment = (
//	isPrime: (Int) -> Effect<Result<Bool, NSError>>,
//	trivia: (Int) -> Effect<String>
//)
//
//let mock_counter_environment: CounterEnvironment = (
//	isPrime: isprime,
//	trivia: trivia
//)
//
//let trivia = { (v: Int) in
//	fatalError()
//
//	//Effect.sync { "\(v) is awesome" }
//}
//
//let isprime = {
//	fatalError()
//
////	Effect.sync {
////		isPrime(v)
////	}
//}
