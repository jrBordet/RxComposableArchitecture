//
//  Environment.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import Login
import RxComposableArchitecture

public struct AppEnvironment {
	var counter: CounterEnvironment
}

//let envLoginSuccess: Login =  {  _,_ in .sync { .success("login success") } }
//let envLoginFailureGeneric: Login =  {  _,_ in .sync { .failure(.generic) } }
//let envLoginFailureCredentials: Login =  {  _,_ in .sync { .failure(.invalidCredentials("invalid credentials")) } }
//let envLoginGenericError: Login =  {  _,_ in Effect.error(title: "custom error") }
//
//let envLoginSuccessDemo: (String, String) -> Effect<Result<String, LoginError>> =  { username, pasword in
//	guard username == "demo@gmail.com", pasword == "Aa123123" else {
//		return .sync { .failure(LoginError.invalidCredentials("invalid credentials message")) }
//	}
//
//	return .sync { .success("login success") }
//}
//
//var credentials: (String, String)? = nil
//
//let loginEnv: LoginViewEnvironment = (
//	login: envLoginGenericError,
//	saveCredentials: { username, passwd in
//		credentials = (username, passwd)
//		return  Effect.error(title: "error")//.sync { true }
//	},
//	retrieveCredentials: { usename in
//		guard let c = credentials else {
//			return .sync { ("", "") }
//		}
//
//		return .sync { c }
//	},
//	ereaseCredentials: { _ in
//		credentials = nil
//		return .sync { true }
//	}
//)

let live = AppEnvironment(
	counter: { v in
		Effect.sync {
			print(";lkdfs")
			return true
		}
	}
)
