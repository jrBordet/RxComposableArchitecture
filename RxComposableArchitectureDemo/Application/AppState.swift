//
//  AppState.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import Foundation
import RxComposableArchitecture
import os.log

public struct AppState: Equatable {
	var counter: CounterState
	var favorites: FavoritesState
}

extension AppState {
	var counterView: CounterState {
		get {
			self.counter
		}
		
		set {
			self.counter = newValue
			
			self.favorites = FavoritesState(
				selected: self.favorites.selected,
				favorites: newValue.favorites,
				isPrime: self.favorites.isPrime
			)
		}
	}
	
	var favoritesView: FavoritesState {
		get {
			self.favorites
		}
		
		set {
			self.favorites = newValue
			
			self.counter = CounterState(
				count: self.counter.count,
				isLoading: self.counter.isLoading,
				isPrime: self.counter.isPrime,
				favorites: newValue.favorites
			)
		}
	}
}

let initialAppState = AppState(
	counter: .empty,
	favorites: .empty
)

func activityFeed(
	_ reducer: Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {
	return .init { state, action, environment in
		
		if case AppAction.counter(CounterAction.incrTapped) = action {
			os_log("counter %{public}@ ", log: OSLog.counter, type: .info, [action, state])
		}
		
		return reducer(&state, action, environment)
	}
}

extension OSLog {
	private static var subsystem = Bundle.main.bundleIdentifier!
	
	static let counter = OSLog(subsystem: subsystem, category: "Counter")
}
