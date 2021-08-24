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
import Login

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
		dump(state)
//		if case let .login(.login(loginAction)) = action {
//			os_log("login %{public}@ ", log: OSLog.login, type: .info, [action, state])
//			
//			switch loginAction {
//			case .username(_):
//				break
//			case .password(_):
//				break
//			case .login:
//				break
//			case .loginResponse(_):
//				break
//			case .checkRememberMeStatus:
//				break
//			case .checkRememberMeStatusResponse(_, _):
//				break
//			case .rememberMe:
//				break
//			case .rememberMeResponse(_):
//				break
//			case .dismissAlert:
//				break
//			case .retrieveCredentials:
//				break
//			case .retrieveCredentialsResponse(_, _):
//				break
//			case .none:
//				break
//			}
//		}
		
		return reducer(&state, action, environment)
	}
}

extension OSLog {
	private static var subsystem = Bundle.main.bundleIdentifier!
	
	static let counter = OSLog(subsystem: subsystem, category: "Counter")
	static let login = OSLog(subsystem: subsystem, category: "Login")
}
