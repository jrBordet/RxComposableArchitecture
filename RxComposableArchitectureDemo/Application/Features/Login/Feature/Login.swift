//
//  Login.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 26/08/2020.
//

import Foundation
import RxComposableArchitecture

public func loginReducer(
    state: inout LoginState,
    action: LoginAction,
    environment: LoginEnvironment
) -> [Effect<LoginAction>] {
    switch action {
    case .incrTapped:
        state.count += 1
        return []
    case .decrTapped:
        state.count -= 1
        return []
    case .nthPrimeButtonTapped:
        return [
            environment(state.count).map(LoginAction.nthPrimeResponse)
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

// MARK: - State

public typealias LoginState = (count: Int, isLoading: Bool, alertNthPrime: PrimeAlert?)

// MARK: - Action

public enum LoginAction: Equatable {
    case incrTapped
    case decrTapped
    case nthPrimeButtonTapped
    case nthPrimeResponse(Int?)
    case alertDismissButtonTapped
}

// MARK: - Environment

public typealias LoginEnvironment = (
    (Int) -> Effect<Int?>
)
