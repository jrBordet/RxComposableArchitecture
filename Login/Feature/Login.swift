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
    case let .userame(value):
        state.username = value
        return []
    case let .password(value):
        state.password = value
        return []
    case .login:
        state.isLoading = true
        
        return [
            environment(state.username, state.password).map(LoginAction.loginResponse)
        ]
    case let .loginResponse(result):
        state.isLoading = false

        if case let .success(message) = result {
            state.alert = LoginAlert(message: message)
        }
        
        if case let .failure(error) = result {
            switch error {
            case .generic:
                break
            case let .invalidCredentials(m):
                state.alert = LoginAlert(message: m)
                break
            }
        }
        
        return []
    }
}

// MARK: - State

public typealias LoginState = (username: String, password: String, isLoading: Bool, isEnabled: Bool, alert: LoginAlert?)

// MARK: - Action

public enum LoginAction: Equatable {
    case userame(String)
    case password(String)
    
    case login
    case loginResponse(Result<String, LoginError>)
}

// MARK: - Environment

public typealias LoginEnvironment = (
    (_ username: String, _ password: String) -> Effect<Result<String, LoginError>>
)

public enum LoginError: Error, Equatable {
    case generic
    case invalidCredentials(String)
}

// MARK: - Common

public struct LoginAlert: Equatable {
  let message: String
  public var content: String { self.message }
    
    public init(message: String) {
        self.message = message
    }
}
