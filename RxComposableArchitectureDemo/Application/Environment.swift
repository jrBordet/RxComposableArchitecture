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

struct AppEnvironment {
	var counter: CounterEnvironment
}

extension AppEnvironment {
	enum env {
		static let live = AppEnvironment(
			counter: (
				isPrime: { v in Effect.sync { isPrime(v) } },
				trivia: { triviaRequest($0) }
			)
		)
		
		static let mock = AppEnvironment(
			counter: (
				isPrime: { v in Effect.sync { isPrime(v) } },
				trivia: { Observable<String>.just("\($0) awesome") }
			)
		)
	}
}

let live = AppEnvironment.env.live

func triviaRequest(_ v: Int) -> Observable<String>{
	URLSession.shared.rx
		.data(request: URLRequest(url: URL(string: "http://numbersapi.com/\(v)/trivia")!))
		.debug("[TRIVIA-REQUEST]", trimOutput: false)
		.map { d -> String? in
			String(data: d, encoding: .utf8)
		}
		.map { $0 ?? "" }
		.catchAndReturn("")
}

public func isPrime (_ p: Int) -> Bool {
	if p <= 1 { return false }
	if p <= 3 { return true }
	
	for i in 2...Int(sqrtf(Float(p))) {
		if p % i == 0 { return false }
	}
	
	return true
}
