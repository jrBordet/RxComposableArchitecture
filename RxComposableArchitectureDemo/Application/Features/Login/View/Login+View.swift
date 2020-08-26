//
//  LoginViewState.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 26/08/2020.
//

import Foundation
import RxComposableArchitecture

public struct LoginViewState: Equatable {
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

public enum LoginViewAction: Equatable {
    case counter(LoginAction)
}

public typealias LoginViewEnvironment = (
    counter: (Int) -> Effect<Int?>,
    other: () -> Effect<Bool>
)

public let loginViewReducer: Reducer<LoginViewState, LoginViewAction, LoginViewEnvironment> = combine(
    pullback(
        loginReducer,
        value: \LoginViewState.counter,
        action: /LoginViewAction.counter,
        environment: { $0.counter }
    )
)
