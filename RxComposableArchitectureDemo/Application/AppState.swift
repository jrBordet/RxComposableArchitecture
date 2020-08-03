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

public struct AppState {
    var featureCounterState: FeatureCounterState
}

public struct FeatureCounterState {
    public var count: Int
    public var isLoading: Bool
    public var alertNthPrime: PrimeAlert?
}

extension AppState {
  var counter: CounterViewState {
    get {
        CounterViewState(
            count: self.featureCounterState.count,
            isLoading: self.featureCounterState.isLoading,
            alertNthPrime: self.featureCounterState.alertNthPrime
        )
    }
    set {
        self.featureCounterState.count = newValue.count
        self.featureCounterState.isLoading = newValue.isLoading
        self.featureCounterState.alertNthPrime = newValue.alertNthPrime
    }
  }
}

let initialAppState = AppState(
    featureCounterState: FeatureCounterState(
        count: 0,
        isLoading: false,
        alertNthPrime: nil
    )
)

func activityFeed(
  _ reducer: @escaping Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {
  return { state, action, environment in
    switch action {
    case .counter(.counter(.incrTapped)):
        os_log("incrTapped %{public}@ ", log: OSLog.counter, type: .info, [state])
        break
    default:
      break
    }
    
    return reducer(&state, action, environment)
  }
}

extension OSLog {
  private static var subsystem = Bundle.main.bundleIdentifier!
  
  static let counter = OSLog(subsystem: subsystem, category: "Counter")
}
