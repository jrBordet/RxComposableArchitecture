//
//  Favorites.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 24/08/21.
//

import Foundation
import RxComposableArchitecture

public struct FavoritesState: Equatable {
	var selected: Int?
	var favorites: [Int]
	var isPrime: Bool?
	var trivia: String?
}

extension FavoritesState {
	static let empty = Self(
		selected: nil,
		favorites: [],
		isPrime: nil,
		trivia: nil
	)
}

public enum FavoritesAction: Equatable {
	case selectAt(Int)
	case remove
	
	case isPrime, isPrimeResponse(Result<Bool, NSError>)
	case trivia, triviaResponse(String)
}

public typealias FavoritesEnvironment = (
	isPrime: (Int) -> Effect<Result<Bool, NSError>>,
	trivia: (Int) -> Effect<String>
)

public let favoritesReducer: Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment> = .init { state, action, environment in
	switch action {
	case .remove:
		return .none
	
	case .trivia:
		state.trivia = nil
		
		guard let selected = state.selected else {
			return .none
		}
	
		return .none

		
//		return [
//			environment.trivia(selected).map(FavoritesAction.triviaResponse)
//		]
		
	case let .triviaResponse(v):
		state.trivia = v
		return .none

		
	case .isPrime:
		guard let selected = state.selected else {
			return .none

		}
		return .none

//		return [
//			environment.isPrime(selected).map(FavoritesAction.isPrimeResponse)
//		]
		
	case let .isPrimeResponse(.success(value)):
		state.isPrime = value
		return .none

		
	case let .isPrimeResponse(.failure(e)):
		return .none

		
	case let .selectAt(index):
		guard state.favorites.isEmpty == false else {
			return .none

		}
		
		guard index >= 0 && index <= state.favorites.count-1 else {
			return .none

		}
		
		state.selected = state.favorites[index]
		return .none

		
	}
}
