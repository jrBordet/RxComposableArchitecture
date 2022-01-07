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

func isPrimeEffect(_ p: Int) -> Effect<Result<Bool, NSError>> {
	Effect<Result<Bool, NSError>>.run { subscriber in
		guard p >= 0 else {
			subscriber.onNext(.success(false))
			subscriber.onError(NSError(domain: "is prime error", code: -1, userInfo: nil))
			return Disposables.create()
		}
		
		if p <= 1 {
			subscriber.onNext(.success(false))
			return Disposables.create()
		}
		
		if p <= 3 {
			subscriber.onNext(.success(true))
			return Disposables.create()
		}
		
		for i in 2...Int(sqrtf(Float(p))) {
			if p % i == 0 { subscriber.onNext(.success(false)) }
		}
		
		subscriber.onNext(.success(true))
		
		return Disposables.create()
	}
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
	
	static var live: Self = .init(
		mainQueue: MainScheduler.instance,
		isPrime: { p in
			isPrimeEffect(p)
		},
		trivia: { v in
			fatalError()
			
		}
	)
	
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

func triviaRequest(_ v: Int) -> Observable<String>{
	URLSession.shared.rx
		.data(request: URLRequest(url: URL(string: "http://numbersapi.com/\(v)/trivia")!))
		.debug("[TRIVIA-REQUEST]", trimOutput: false)
		.map { d -> String? in
			String(data: d, encoding: .utf8)
		}
		.map { $0 ?? "" }
		.catchAndReturn("")
}

func isPrime (_ p: Int) -> Result<Bool, NSError> {
	guard p >= 0 else {
		return .failure(NSError(domain: "is prime error", code: -1, userInfo: nil))
	}
	
	if p <= 1 { return  .success(false) }
	if p <= 3 { return  .success(true) }
	
	for i in 2...Int(sqrtf(Float(p))) {
		if p % i == 0 { return .success(false) }
	}
	
	return .success(true)
}
