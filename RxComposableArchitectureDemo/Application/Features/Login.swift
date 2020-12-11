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
    case let .username(value):
        state.username = value
        
        state.isEnabled = isValidUsername(state.username) && state.password.isEmpty == false

        if state.rememberMeStatus && value.count == 3 {
            return [
                environment.retrieveCredentials(value).map(LoginAction.retrieveCredentialsResponse)
            ]
        }
        
        return []
    case let .password(value):
        state.password = value
        
        state.isEnabled = isValidUsername(state.username) && state.password.isEmpty == false
        
        return []
    case .login:
        state.isLoading = true
        
        if state.rememberMeStatus == false {
            return [
                environment.login(state.username, state.password).map(LoginAction.loginResponse),
                environment.ereaseCredentials(state.username).map { _ in .none }
            ]
        }
        
        return [
            environment.login(state.username, state.password).map(LoginAction.loginResponse)
        ]
    case let .loginResponse(result):
        state.isLoading = false

        if case let .success(message) = result {
            state.alert = LoginAlert(message: message)
        }
        
        if case let .failure(error) = result {
            guard case let .invalidCredentials(m) = error else {
                return []
            }
            
            state.alert = LoginAlert(message: m)
        }
        
        return []
    case .rememberMe:
        guard state.isEnabled else {
            return []
        }
        
        return [
            environment.saveCredentials(state.username, state.password).map(LoginAction.rememberMeResponse)
        ]
    case .rememberMeResponse:
        return []
    case .dismissAlert:
        state.alert = nil
        return []
    case .retrieveCredentials:
        return [
            environment.retrieveCredentials(state.username).map(LoginAction.retrieveCredentialsResponse)
        ]
    case let .retrieveCredentialsResponse(username, password):
        state.username = username
        state.password = password
        
        state.isEnabled = isValidUsername(state.username) && state.password.isEmpty == false

        return []
    case .checkRememberMeStatus:
        return [
            environment.retrieveCredentials(state.username).map(LoginAction.checkRememberMeStatusResponse)
        ]
    case let .checkRememberMeStatusResponse(username, password):
        state.rememberMeStatus = username.isEmpty == false && password.isEmpty == false
        return []
    case .none:
        return []
    }
}

func isValidUsername(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

// MARK: - State

public typealias LoginState = (username: String, password: String, isLoading: Bool, isEnabled: Bool, alert: LoginAlert?, rememberMeStatus: Bool)

// MARK: - Action

public enum LoginAction: Equatable {
    case username(String)
    case password(String)
    
    case login
    case loginResponse(Result<String, LoginError>)
    
    case checkRememberMeStatus
    case checkRememberMeStatusResponse(String, String)
    case rememberMe
    case rememberMeResponse(Bool)
    
    case dismissAlert
    
    case retrieveCredentials
    case retrieveCredentialsResponse(String, String)
    
    case none
}

// MARK: - Environment

public typealias LoginEnvironment = (
    login: (_ username: String, _ password: String) -> Effect<Result<String, LoginError>>,
    saveCredentials: (_ username: String, _ password: String) -> Effect<Bool>,
    retrieveCredentials: (_ username: String) -> Effect<(String, String)>,
    ereaseCredentials: (_ username: String) -> Effect<Bool>
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
