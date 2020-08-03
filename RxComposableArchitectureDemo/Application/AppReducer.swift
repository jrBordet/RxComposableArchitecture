//
//  AppReducer.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =  combine(
  pullback(
    counterViewReducer,
    value: \AppState.counter,
    action: /AppAction.counter,
    environment: { $0.counter }
  )
)
