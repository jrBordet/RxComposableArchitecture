//
//  CounterView.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 24/08/21.
//

import Foundation
import RxComposableArchitecture

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

extension CounterViewState {
	static let empty = Self(
		currentCount: 0,
		isLoading: false,
		isPrime: false,
		favorites: []
	)
}

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
