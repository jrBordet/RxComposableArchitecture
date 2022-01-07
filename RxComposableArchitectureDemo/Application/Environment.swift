//
//  Environment.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture
import RxSwift
import RxCocoa

//struct AppEnvironment {
//	var counter: CounterEnvironment
//}
//
//extension AppEnvironment {
//	enum env {
//		static let live = AppEnvironment(
//			counter: (
//				isPrime: { v in Effect.sync { isPrime(v) } },
//				trivia: { triviaRequest($0) }
//			)
//		)
//		
//		static let mock = AppEnvironment(
//			counter: (
//				isPrime: { v in Effect.sync { isPrime(v) } },
//				trivia: { Observable<String>.just("\($0) awesome") }
//			)
//		)
//	}
//}
//
//let live = AppEnvironment.env.live
//
