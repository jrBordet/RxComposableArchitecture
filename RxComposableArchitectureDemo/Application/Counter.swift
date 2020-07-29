//
//  Counter.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 29/07/2020.
//

import Foundation
import RxComposableArchitecture

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

public typealias CounterViewEnvironment = (
    counter: (Int) -> Effect<Int?>,
    other: () -> Effect<Bool>
)

public let counterViewReducer: Reducer<CounterViewState, CounterViewAction, CounterViewEnvironment> = combine(
    pullback(
        counterReducer,
        value: \CounterViewState.counter,
        action: \CounterViewAction.counter,
        environment: { $0.counter }
    )
)

// MARK: - Counter Reducer

public func counterReducer(
    state: inout CounterState,
    action: CounterAction,
    environment: CounterEnvironment
) -> [Effect<CounterAction>] {
    switch action {
    case .incrTapped:
        state.count += 1
        return []
    case .decrTapped:
        state.count -= 1
        return []
    case .nthPrimeButtonTapped:
        return [
            environment(state.count).map(CounterAction.nthPrimeResponse)
        ]
    case let .nthPrimeResponse(value):
        guard let value = value else {
            return []
        }
        
        state.alertNthPrime = PrimeAlert(prime: value)
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
