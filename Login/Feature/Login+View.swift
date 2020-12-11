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
    public var rememberMeStatus: Bool
    
    public init(
     username: String,
     password: String,
     isLoading: Bool,
     isEnabled: Bool,
     alert: LoginAlert?,
    rememberMeStatus: Bool
    ) {
        self.username = username
        self.password = password
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.alert = alert
        self.rememberMeStatus = rememberMeStatus
    }
    
    var login: LoginState {
        get { (self.username, self.password, self.isLoading, self.isEnabled, self.alert, self.rememberMeStatus) }
        set { (self.username, self.password, self.isLoading, self.isEnabled, self.alert, self.rememberMeStatus) = newValue }
    }
}

public enum LoginViewAction: Equatable {
    case login(LoginAction)
}

public typealias Login = (_ username: String, _ password: String) -> Effect<Result<String, LoginError>>
public typealias SaveCredentials = (_ username: String, _ password: String) -> Effect<Bool>
public typealias RetrieveCredentials = (_ username: String) -> Effect<(String, String)>
public typealias EreaseCredentials = (_ username: String) -> Effect<Bool>

public typealias LoginViewEnvironment = (
    login: Login,
    saveCredentials: SaveCredentials,
    retrieveCredentials: RetrieveCredentials,
    ereaseCredentials: EreaseCredentials
)

public let loginViewReducer: Reducer<LoginViewState, LoginViewAction, LoginViewEnvironment> = combine(
    pullback(
        loginReducer,
        value: \LoginViewState.login,
        action: /LoginViewAction.login,
        environment: { $0 }
    )
)
