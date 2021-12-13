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

struct GenericErrorState: Equatable {
	var title: String
	var message: String
	var isDismissed: Bool
}

enum GenericErrorAction: Equatable {
	case dismiss
}

struct GenericErrorEnvironment { }

let genericErrorReducer = Reducer<GenericErrorState, GenericErrorAction, GenericErrorEnvironment> { state, action, env in
	switch action {
	case .dismiss:
		state.title = ""
		state.message = ""
		state.isDismissed = true
		return []
	}
}


struct AppState: Equatable {
	var counter: CounterState
	var favorites: FavoritesState
	var genericError: GenericErrorState?
}

extension AppState {
	var counterView: CounterState {
		get {
			self.counter
		}
		
		set {
			self.counter = newValue
			
			self.genericError = newValue.genericError
			
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
	
	var genericErrorView: GenericErrorState? {
		get {
			self.genericError
		}
		
		set {
			if let dismissed = newValue?.isDismissed, dismissed {
				self.counter.genericError = nil
			}
			
			self.genericError = newValue
		}
	}
}

let initialAppState = AppState(
	counter: .empty,
	favorites: .empty,
	genericError: nil
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
