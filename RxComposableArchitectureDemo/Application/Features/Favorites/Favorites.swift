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
	var isPrime: Bool
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
