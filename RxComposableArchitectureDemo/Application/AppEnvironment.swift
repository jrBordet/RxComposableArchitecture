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
	var favorites: FavoritesEnvironment
}

extension AppEnvironment {
	enum env {
		static let live = AppEnvironment(
			counter: .live,
			favorites: .live
		)
		
		static let mock = AppEnvironment(
			counter: .mock(),
			favorites: .mock()
		)
	}
}

let live = AppEnvironment.env.live

