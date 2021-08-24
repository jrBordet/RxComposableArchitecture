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

public struct AppState {
	var loginState: LoginViewState
}

public struct FeatureCounterState {
	public var count: Int
	public var isLoading: Bool
	//    public var alertNthPrime: PrimeAlert?
}

extension AppState {
	//    var counter: CounterViewState {
	//        get {
	//            CounterViewState(
	//                count: self.featureCounterState.count,
	//                isLoading: self.featureCounterState.isLoading,
	//                alertNthPrime: self.featureCounterState.alertNthPrime
	//            )
	//        }
	//        set {
	//            self.featureCounterState.count = newValue.count
	//            self.featureCounterState.isLoading = newValue.isLoading
	//            self.featureCounterState.alertNthPrime = newValue.alertNthPrime
	//        }
	//    }
	
	var login: LoginViewState {
		get {
			LoginViewState(
				username: self.loginState.username,
				password: self.loginState.password,
				isLoading: self.loginState.isLoading,
				isEnabled: self.loginState.isEnabled,
				alert: self.loginState.alert,
				rememberMeStatus: self.loginState.rememberMeStatus
			)
		}
		
		set {
			self.loginState = newValue
		}
	}
}

let initialAppState = AppState(
	loginState: LoginViewState(
		username: "",
		password: "",
		isLoading: false,
		isEnabled: false,
		alert: nil,
		rememberMeStatus: false
	)
)

func activityFeed(
	_ reducer: Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {
	return .init { state, action, environment in
		if case let .login(.login(loginAction)) = action {
			os_log("login %{public}@ ", log: OSLog.login, type: .info, [action, state])
			
			switch loginAction {
			case .username(_):
				break
			case .password(_):
				break
			case .login:
				break
			case .loginResponse(_):
				break
			case .checkRememberMeStatus:
				break
			case .checkRememberMeStatusResponse(_, _):
				break
			case .rememberMe:
				break
			case .rememberMeResponse(_):
				break
			case .dismissAlert:
				break
			case .retrieveCredentials:
				break
			case .retrieveCredentialsResponse(_, _):
				break
			case .none:
				break
			}
		}
		
		return reducer(&state, action, environment)
	}
}

extension OSLog {
	private static var subsystem = Bundle.main.bundleIdentifier!
	
	static let counter = OSLog(subsystem: subsystem, category: "Counter")
	static let login = OSLog(subsystem: subsystem, category: "Login")
}
