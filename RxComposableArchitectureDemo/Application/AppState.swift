//
//  AppState.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import Foundation
import RxComposableArchitecture

public struct AppState {
    let isLoading: Bool
}

public enum AppAction {
    case counter(CounterViewAction)
}

let initialAppState = AppState(
    isLoading: false
)
