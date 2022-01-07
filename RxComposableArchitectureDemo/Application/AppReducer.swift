//
//  AppReducer.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture

//let appReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer.combine(
//	counterReducer.pullback(
//		state: \AppState.counterView,
//		action: /AppAction.counter,
//		environment: { $0.counter }
//	),
//	favoritesReducer.pullback(
//		state: \AppState.favoritesView,
//		action: /AppAction.favorites,
//		environment: { $0.counter }
//	),
////	genericErrorReducer.optional.pullback(
////		value: \AppState.genericErrorView,
////		action: /AppAction.genericError,
////		environment: { _ in GenericErrorEnvironment() }
////	),
//	Reducer<AppState, AppAction, AppEnvironment> { state, action, env -> Effect<AppAction> in
//		if case AppAction.genericError(GenericErrorAction.dismiss) = action {
//			state.genericError = nil
//			return .none
//		}
//		
//		return .none
//	}
//)
