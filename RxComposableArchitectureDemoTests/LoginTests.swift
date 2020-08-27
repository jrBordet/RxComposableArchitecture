//
//  LoginTests.swift
//  RxComposableArchitectureDemoTests
//
//  Created by Jean Raphael Bordet on 26/08/2020.
//

import XCTest
@testable import RxComposableArchitectureDemo
import Login
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa

let envLoginSuccess: (String, String) -> Effect<Result<String, LoginError>> =  {  _,_ in .sync { .success("") } }
let envLoginFailureGeneric: (String, String) -> Effect<Result<String, LoginError>> =  {  _,_ in .sync { .failure(.generic) } }
let envLoginFailureCredentials: (String, String) -> Effect<Result<String, LoginError>> =  {  _,_ in .sync { .failure(.invalidCredentials("invalid credentials")) } }


class LoginTests: XCTestCase {
    var initialState: LoginViewState = LoginViewState(
        username: "",
        password: "",
        isLoading: false,
        isEnabled: false,
        alert: nil
    )
    
    let env: LoginViewEnvironment = (
        login: envLoginSuccess,
        saveCredentials: { _,_ in  .sync { true } }
    )
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_insert_username() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, LoginViewAction.login(LoginAction.userame("fake@mail.com")), { state in
                state.username = "fake@mail.com"
            })
        )
    }
    
    func test_insert_password() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, LoginViewAction.login(LoginAction.password("Aa123123")), { state in
                state.password = "Aa123123"
            })
        )
    }
    
    func test_login_success() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, LoginViewAction.login(LoginAction.login), { state in
                state.isLoading = true
            }),
            Step(.receive, LoginViewAction.login(LoginAction.loginResponse(.success(""))), { state in
                state.isLoading = false
                state.alert = LoginAlert(message: "")
            })
        )
    }
    
    func test_login_failure() {
        let env: LoginViewEnvironment = (
            login: envLoginFailureGeneric,
            saveCredentials: { _,_ in  .sync { true } }
        )
        
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, LoginViewAction.login(LoginAction.login), { state in
                state.isLoading = true
            }),
            Step(.receive, LoginViewAction.login(LoginAction.loginResponse(.failure(.generic))), { state in
                state.isLoading = false
                state.alert = nil
            })
        )
    }
    
    func test_login_failure_invalid_credentials() {
        let env: LoginViewEnvironment = (
            login: envLoginFailureCredentials,
            saveCredentials: { _,_ in  .sync { true } }
        )
        
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, LoginViewAction.login(LoginAction.login), { state in
                state.isLoading = true
            }),
            Step(.receive, LoginViewAction.login(LoginAction.loginResponse(.failure(.invalidCredentials("invalid credentials")))), { state in
                state.alert = LoginAlert(message: "invalid credentials")
                state.isLoading = false
            })
        )
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
