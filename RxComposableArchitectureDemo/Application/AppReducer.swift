//
//  AppReducer.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer.combine(
	counterReducer.pullback(
		value: \AppState.counterView,
		action: /AppAction.counter,
		environment: { $0.counter }
	),
	favoritesReducer.pullback(
		value: \AppState.favoritesView,
		action: /AppAction.favorites,
		environment: { $0.counter }
	)
)
