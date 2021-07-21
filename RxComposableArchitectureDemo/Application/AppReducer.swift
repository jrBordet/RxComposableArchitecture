//
//  AppReducer.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture
import Login

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer.combine(
	counterViewReducer.pullback(
		value: \AppState.counter,
		action: /AppAction.counter,
		environment: { $0.counter }
	),
	loginViewReducer.pullback(
		value: \AppState.login,
		action: /AppAction.login,
		environment: { $0.login }
	)
)
