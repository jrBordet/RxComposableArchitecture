//
//  Counter.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 29/07/2020.
//

import Foundation
import RxComposableArchitecture

//
//public let counterViewReducer: Reducer<CounterViewState, CounterViewAction, CounterViewEnvironment> = Reducer.combine(
//		counterReducer.pullback(
//        value: \CounterViewState.counter,
//        action: /CounterViewAction.counter,
//        environment: { $0.counter }
//    )
//)
//

//extension FavoriteCounterState {
//	enum lens {
//		static let current = Lens<FavoriteCounterState, Int?>(
//			get: { state in
//				state.current
//			},
//			set: { current, state in
//				var copy = state
//				copy.current = current
//				return copy
//			}
//		)
//
//		static let favorites = Lens<FavoriteCounterState, [Int]>(
//			get: { state in
//				state.favorites
//			},
//			set: { favorites, state in
//				var copy = state
//				copy.favorites = favorites
//				return copy
//			}
//		)
//	}
//}

//public let favoriteCounterReducer: Reducer<FavoriteCounterState, FavoriteCounterAction, FavoriteCounterEnvironment> =
//	Reducer.combine(
//		favoritesReducer.pullback(
//			state: FavoriteCounterState.lens.favorites,
//			action: /FavoriteCounterAction.favorites,
//			environment: { $0.nthPrime }
//		)
//	)

// MARK: - CounterView

public struct CounterViewState: Equatable {
	var currentCount: Int
	var isLoading: Bool
	var isPrime: Bool

	var favorites: [Int]
	var selectedFavorite: Int?
		
	var counter: CounterState {
		get {
			CounterState(
				count: self.currentCount,
				isLoading: self.isLoading,
				isPrime: self.isPrime,
				favorites: self.favorites
			)
		}
		
		set {
			self.currentCount = newValue.count
			self.isLoading = newValue.isLoading
			self.isPrime = newValue.isPrime
			self.favorites = newValue.favorites
		}
	}
	
	var fav: FavoritesState {
		get {
			FavoritesState(
				selected: self.selectedFavorite,
				favorites: self.favorites,
				isPrime: self.isPrime
			)
		}
		
		set {
			self.selectedFavorite = newValue.selected
			self.favorites = newValue.favorites
			self.isPrime = newValue.isPrime
		}
	}
}

/**

these lenses all share the same Whole, but focus on different Parts.

Lens<CounterViewState, B1> + Lens<CounterViewState ,B2> = Lens<A, (B1, B2)>

Lens<CounterViewState ,B1> + Lens<CounterViewState ,B2> = Lens<CounterViewState, (B1, B2)>

*/

/**

public struct CounterState {
	var count: Int
	var isLoading: Bool
	var alertNthPrime: PrimeAlert?
	
	var favorites: [Int]
}

*/

//extension CounterState {
//	enum lens {
//		static let favorites = Lens<CounterState, [Int]>(
//			get: { $0.favorites },
//			set: { favorites, state in
//				var copy = state
//				copy.favorites = favorites
//				return copy
//			}
//		)
//
//		static let count = Lens<CounterState, Int>(
//			get: { $0.count },
//			set: { count, whole in
//				var copy = whole
//				copy.count = count
//				return copy
//			}
//		)
//	}
//}

/**

a set that update the whole in two parts

*/

//extension CounterViewState {
//	enum lens {
//		static let counter = Lens<CounterViewState, CounterState>(
//			get: { counterViewState -> CounterState in
//				counterViewState.counter
//			},
//			set: { counterState, counterViewState -> CounterViewState in
//				var copy = counterViewState
//				copy.counter = counterState
//
//				copy.favorites.favorites = CounterState.lens.favorites.get(counterState)
//
//				return copy
//			}
//		)
//
//		static let favorites = Lens<CounterViewState, FavoritesState>(
//			get: { counterViewState -> FavoritesState in
//				counterViewState.favorites
//			},
//			set: { favoritesState, counterViewState -> CounterViewState in
//				var copy = counterViewState
//				copy.favorites = favoritesState
//
//				copy.counter.favorites = FavoritesState.lens.favorites.get(favoritesState)
//
//				return copy
//			}
//		)
//
//		// (Whole, part) -> Wholes
//		static let update: (CounterViewState, [Int]) -> CounterViewState = { whole, part in
//			var copy = whole
//
//			copy.counter.favorites = part
//			copy.favorites.favorites = part
//
//			return whole
//		}
//
//		static let counterFavorites: Lens<CounterViewState, [Int]> = CounterViewState.lens.counter.then(CounterState.lens.favorites)
//	}
//}

public enum CounterViewAction: Equatable {
	case counter(CounterAction)
	case favorites(FavoritesAction)
}

public struct CounterViewEnvironment {
	let isPrime: (Int) -> Effect<Bool>
}

public let counterViewReducer: Reducer<CounterViewState, CounterViewAction, CounterViewEnvironment> = Reducer.combine(
	favoritesReducer.pullback(
		value: \CounterViewState.fav,
		action: /CounterViewAction.favorites,
		environment: { $0.isPrime }
	),
	counterReducer.pullback(
		value: \CounterViewState.counter,
		action: /CounterViewAction.counter,
		environment: { $0.isPrime }
	)
)

// MARK: - FavoriteCounter

public struct FavoriteCounterState: Equatable {
	var favorites: [Int]
	var current: Int?
}

public enum FavoriteCounterAction: Equatable {
	case favorites(FavoritesAction)
	case counter(CounterAction)
}

public struct FavoriteCounterEnvironment {
	let isPrime: (Int) -> Effect<Bool>
}

// MARK: - Favourites

public struct FavoritesState: Equatable {
	var selected: Int?
	var favorites: [Int]
	var isPrime: Bool
}

extension FavoritesState {
	enum lens {
		static let favorites = Lens<FavoritesState, [Int]>(
			get: { $0.favorites },
			set: { v, s in FavoritesState(selected: s.selected, favorites: v, isPrime: false) }
		)
	}
}

extension FavoritesState {
	static let empty = Self(
		selected: nil,
		favorites: [],
		isPrime: false
	)
}

public enum FavoritesAction: Equatable {
	case selectAt(Int)
	case remove
	
	case isPrime, isPrimeResponse(Bool)
}

public typealias FavoritesEnvironment = (Int) -> Effect<Bool>

public let favoritesReducer: Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment> = .init { state, action, environment in
	switch action {
	case .remove:
		return []
		
	case .isPrime:
		guard let selected = state.selected else {
			return []
		}
		
		return [
			environment(selected).map(FavoritesAction.isPrimeResponse)
		]
		
	case let .isPrimeResponse(v):
		state.isPrime = v
		return []
		
	case let .selectAt(index):
		guard state.favorites.isEmpty == false else {
			return []
		}
				
		guard (0..<state.favorites.count-1).contains(index) && index >= 0 else {
			return []
		}
		
		state.selected = state.favorites[index]
		return []
		
	}
}

// MARK: - Counter Reducer

public let counterReducer: Reducer<CounterState, CounterAction, CounterEnvironment> = .init { state, action, environment in
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
		state.isLoading = true
		state.isPrime = value
		return []
		
		
	case .addFavorite:
		state.favorites.append(state.count)
		return []
		
	case .removeFavorite:
//		state.favorites
		return []
	}
}

// MARK: - Counter State

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

//struct WolframAlphaResult: Decodable {
//  let queryresult: QueryResult
//
//  struct QueryResult: Decodable {
//	let pods: [Pod]
//
//	struct Pod: Decodable {
//	  let primary: Bool?
//	  let subpods: [SubPod]
//
//	  struct SubPod: Decodable {
//		let plaintext: String
//	  }
//	}
//  }
//}
//
//let wolframAlphaApiKey = ""
//
//func wolframAlpha(query: String, callback: @escaping (WolframAlphaResult?) -> Void) -> Void {
//  var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
//  components.queryItems = [
//	URLQueryItem(name: "input", value: query),
//	URLQueryItem(name: "format", value: "plaintext"),
//	URLQueryItem(name: "output", value: "JSON"),
//	URLQueryItem(name: "appid", value: wolframAlphaApiKey),
//  ]
//
//  URLSession.shared.dataTask(with: components.url(relativeTo: nil)!) { data, response, error in
//	callback(
//	  data
//		.flatMap { try? JSONDecoder().decode(WolframAlphaResult.self, from: $0) }
//	)
//	}
//	.resume()
//}
//
//func nthPrime(_ n: Int, callback: @escaping (Int?) -> Void) -> Void {
//  wolframAlpha(query: "prime \(n)") { result, response, error in
//	callback(
//	  result
//		.flatMap {
//		  $0.queryresult
//			.pods
//			.first(where: { $0.primary == .some(true) })?
//			.subpods
//			.first?
//			.plaintext
//		}
//		.flatMap(Int.init)
//	)
//  }
//}
