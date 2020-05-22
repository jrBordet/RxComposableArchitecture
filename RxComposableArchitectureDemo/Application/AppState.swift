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

// MARK: - Counter views

public struct CounterViewState: Equatable {
    public var count: Int
    public var isLoading: Bool
    public var alertNthPrime: PrimeAlert?
    
    public init(
        count: Int = 0,
        isLoading: Bool = false,
        alertNthPrime: PrimeAlert? = nil
    ) {
        self.count = count
        self.isLoading = isLoading
        self.alertNthPrime = alertNthPrime
    }
    
    var counter: CounterState {
        get { (self.count, self.isLoading, self.alertNthPrime) }
        set { (self.count, self.isLoading, self.alertNthPrime) = newValue }
    }
}

public enum CounterViewAction: Equatable {
    case counter(CounterAction)
    
    var counter: CounterAction? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        set {
            guard case .counter = self, let newValue = newValue else { return }
            self = .counter(newValue)
        }
    }
}

// MARK: - Counter Reducer

public func counterReducer(
    state: inout CounterState,
    action: CounterAction,
    environment: CounterEnvironment
) -> [Effect<CounterAction>] {
    switch action {
    case .incrTapped:
        return []
    case .decrTapped:
        return []
    case .nthPrimeButtonTapped:
        return [
            environment(state.count).map(CounterAction.nthPrimeResponse)
        ]
    case .nthPrimeResponse(_):
        return []
    case .alertDismissButtonTapped:
        return []
    }
}

// MARK: - Counter State

public typealias CounterState = (count: Int, isLoading: Bool, alertNthPrime: PrimeAlert?)

// MARK: - Counter Action

public enum CounterAction: Equatable {
    case incrTapped
    case decrTapped
    case nthPrimeButtonTapped
    case nthPrimeResponse(Int?)
    case alertDismissButtonTapped
}

// MARK: - Counter Environment

public typealias CounterEnvironment = (
    (Int) -> Effect<Int?>
)

// MARK: - Common

public struct PrimeAlert: Equatable, Identifiable {
  let prime: Int
  public var id: Int { self.prime }
}

//let appReducer: Reducer<AppState, A>

/**
let appReducer: Reducer<AppState, AppAction, AppEnvironment> =  combine(
    pullback(
        globalInformationsViewReducer,
        value: \AppState.globalInfoView,
        action: \AppAction.globalInfoView,
        environment: {(
            globalInfoCache: $0.globalInformations.cache,
            globalInfoAPI: $0.globalInformations.api
            )}
    ),
    pullback(
        searchCountriesViewReducer,
        value: \AppState.searchCountriesView,
        action: \AppAction.searchCountriesView,
        environment: {(
            countriesCache: $0.countries.cache,
            countriesAPI: $0.countries.api,
            favorites: $0.favorites.load,
            saveFavorites: $0.favorites.save
            )}
    ),
    pullback(
        countriesViewReducer,
        value: \AppState.countriesView,
        action: \AppAction.countriesView,
        environment: {(
            countriesCache: $0.countries.cache,
            countriesAPI: $0.countries.api,
            favorites: $0.favorites.load,
            saveFavorites: $0.favorites.save
            )}
    )
)
*/
