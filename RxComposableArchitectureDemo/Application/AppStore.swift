//
//  AppStore.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture

var applicationStore: Store<AppState, AppAction> =
  Store(
    initialValue: initialAppState,
    reducer: with(
      appReducer,
      compose(
        logging,
        activityFeed
    )),
    environment: live
)
