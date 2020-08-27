//
//  LoginViewState.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 26/08/2020.
//

import Foundation
import RxComposableArchitecture

public struct LoginViewState: Equatable {
    public var username: String
    public var password: String
    public var isLoading: Bool
    public var isEnabled: Bool
    public var alert: LoginAlert?
    
    public init(
     username: String,
     password: String,
     isLoading: Bool,
     isEnabled: Bool,
     alert: LoginAlert?) {
        self.username = username
        self.password = password
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.alert = alert
    }
    
    var login: LoginState {
        get { (self.username, self.password, self.isLoading, self.isEnabled, self.alert) }
        set {  (self.username, self.password, self.isLoading, self.isEnabled, self.alert) = newValue }
    }
}

public enum LoginViewAction: Equatable {
    case login(LoginAction)
}

public typealias LoginViewEnvironment = (
    login: (_ username: String, _ password: String) -> Effect<Result<String, LoginError>>,
    saveCredentials: (_ username: String, _ password: String) -> Effect<Bool>
)

public let loginViewReducer: Reducer<LoginViewState, LoginViewAction, LoginViewEnvironment> = combine(
    pullback(
        loginReducer,
        value: \LoginViewState.login,
        action: /LoginViewAction.login,
        environment: { $0.login }
    )
)
