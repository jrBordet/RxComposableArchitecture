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

let envLoginSuccess: Login =  {  _,_ in .sync { .success("message") } }
let envLoginFailureGeneric: Login =  {  _,_ in .sync { .failure(.generic) } }
let envLoginFailureCredentials: Login =  {  _,_ in .sync { .failure(.invalidCredentials("invalid credentials")) } }

class LoginTests: XCTestCase {
    var initialState: LoginViewState = LoginViewState(
        username: "",
        password: "",
        isLoading: false,
        isEnabled: false,
        alert: nil,
        rememberMeStatus: false
    )
    
    let env: LoginViewEnvironment = (
        login: envLoginSuccess,
        saveCredentials: { _,_ in  .sync { true } },
        retrieveCredentials: { username in .sync { ("fake@email.com", "Aa123123") } },
        ereaseCredentials: { username in .sync { true } }
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
            Step(.send, .login(.password("Aa123123")), { state in
                state.password = "Aa123123"
            }),
            Step(.send, .login(.username("fake@gmail.com")), { state in
                state.username = "fake@gmail.com"
                state.isEnabled = true
            })
        )
    }
    
    func test_insert_username_empty_password() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, .login(.username("fake@gmail.com")), { state in
                state.username = "fake@gmail.com"
                state.isEnabled = false
            }),
            Step(.send, .login(.password("")), { state in
                state.username = "fake@gmail.com"
                state.password = ""
                state.isEnabled = false
            })
        )
    }
    
    func test_insert_password() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, .login(.username("fake@gmail.com")), { state in
                state.username = "fake@gmail.com"
                state.isEnabled = false
            }),
            Step(.send, .login(.password("Aa123123")), { state in
                state.password = "Aa123123"
                state.isEnabled = true
            })
        )
    }
    
    func test_username_validation() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, .login(.username("wrong_username")), { state in
                state.username = "wrong_username"
                state.isEnabled = false
            }),
            Step(.send, .login(.username("email@gmail.com")), { state in
                state.username = "email@gmail.com"
                state.isEnabled = false
            })
        )
    }
    
    func test_remember_me_filled_username_password() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, .login(.username("fake@gmail.com")), { state in
                state.username = "fake@gmail.com"
                state.isEnabled = false
            }),
            Step(.send, .login(.password("Aa123123")), { state in
                state.password = "Aa123123"
                state.isEnabled = true
            }),
            Step(.send, .login(.rememberMe(true)), { state in
                state.rememberMeStatus = true
            }),
            Step(.receive, .login(.rememberMeResponse(true)), { _ in
                
            })
        )
    }
    
    func test_remember_me_empty_username_password() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, .login(.rememberMe(true)), { state in
                state.rememberMeStatus = false
            })
        )
    }
    
    func test_retrieve_credentials() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, .login(.retrieveCredentials), { _ in
                
            }),
            Step(.receive, .login(.retrieveCredentialsResponse("fake@email.com", "Aa123123")), { state in
                state.username = "fake@email.com"
                state.password = "Aa123123"
                state.isEnabled = true
            })
        )
    }
    
    func test_username_autocomplete() {
        let initialState: LoginViewState = LoginViewState(
            username: "",
            password: "",
            isLoading: false,
            isEnabled: false,
            alert: nil,
            rememberMeStatus: true
        )
        
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, .login(.username("fak")), { state in
                state.username = "fak"
                state.isEnabled = false
                state.rememberMeStatus = true
            }),
            Step(.receive, .login(.retrieveCredentialsResponse("fake@email.com", "Aa123123")), { state in
                state.username = "fake@email.com"
                state.password = "Aa123123"
                state.isEnabled = true
                state.rememberMeStatus = true
            })
        )
    }
    
    func test_login_success() {
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, LoginViewAction.login(.login), { state in
                state.isLoading = true
            }),
            Step(.receive, LoginViewAction.login(.loginResponse(.success("message"))), { state in
                state.isLoading = false
                state.alert = LoginAlert(message: "message")
            }),
            Step(.receive, LoginViewAction.login(LoginAction.none), { state in
                
            })
        )
    }
    
    func test_login_failure() {
        let env: LoginViewEnvironment = (
            login: envLoginFailureGeneric,
            saveCredentials: { _,_ in  .sync { true } },
            retrieveCredentials: { username in .sync { ("fake@email.com", "Aa123123") } },
            ereaseCredentials: { username in .sync { true } }
        )
        
        assert(
            initialValue: initialState,
            reducer: loginViewReducer,
            environment: env,
            steps:
            Step(.send, .login(.login), { state in
                state.isLoading = true
            }),
            Step(.receive, .login(.loginResponse(.failure(.generic))), { state in
                state.isLoading = false
                state.alert = nil
            }),
            Step(.receive, LoginViewAction.login(LoginAction.none), { state in
                
            })
        )
    }
    
    func test_login_failure_invalid_credentials() {
        let env: LoginViewEnvironment = (
            login: envLoginFailureCredentials,
            saveCredentials: { _,_ in  .sync { true } },
            retrieveCredentials: { username in .sync { ("fake@email.com", "Aa123123") } },
            ereaseCredentials: { username in .sync { true } }
        )
        
        self.measure {
            assert(
                initialValue: initialState,
                reducer: loginViewReducer,
                environment: env,
                steps:
                    Step(.send, .login(.login), { state in
                        state.isLoading = true
                    }),
                Step(.receive, .login(LoginAction.loginResponse(.failure(.invalidCredentials("invalid credentials")))), { state in
                    state.alert = LoginAlert(message: "invalid credentials")
                    state.isLoading = false
                }),
                Step(.receive, LoginViewAction.login(LoginAction.none), { state in
                    state.isLoading = false
                })
            )
        }
        
    }
}
