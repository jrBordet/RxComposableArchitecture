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
	
	case isPrime, isPrimeResponse(Bool)
	case trivia, triviaResponse(String)
}

public typealias FavoritesEnvironment = (
	isPrime: (Int) -> Effect<Bool>,
	trivia: (Int) -> Effect<String>
)

public let favoritesReducer: Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment> = .init { state, action, environment in
	switch action {
	case .remove:
		return []
	
	case .trivia:
		state.trivia = nil
		
		guard let selected = state.selected else {
			return []
		}
		
		return [
			environment.trivia(selected).map(FavoritesAction.triviaResponse)
		]
		
	case let .triviaResponse(v):
		state.trivia = v
		return []
		
	case .isPrime:
		guard let selected = state.selected else {
			return []
		}
		
		return [
			environment.isPrime(selected).map(FavoritesAction.isPrimeResponse)
		]
		
	case let .isPrimeResponse(v):
		state.isPrime = v
		return []
		
	case let .selectAt(index):
		guard state.favorites.isEmpty == false else {
			return []
		}
		
		guard index >= 0 && index <= state.favorites.count-1 else {
			return []
		}
		
		state.selected = state.favorites[index]
		return []
		
	}
}
