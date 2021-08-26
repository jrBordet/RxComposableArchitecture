//
//  Environment.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture

public struct AppEnvironment {
	var counter: CounterEnvironment
}

let live = AppEnvironment(
	counter: { value in
		Effect.sync {
			isPrime(value)
		}
	}
)


public func isPrime (_ p: Int) -> Bool {
	if p <= 1 { return false }
	if p <= 3 { return true }
	
	for i in 2...Int(sqrtf(Float(p))) {
		if p % i == 0 { return false }
	}
	
	return true
}
