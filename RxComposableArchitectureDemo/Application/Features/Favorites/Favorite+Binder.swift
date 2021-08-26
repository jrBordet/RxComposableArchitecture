//
//  Favorite+Binder.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 26/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxComposableArchitecture

public extension Reactive where Base: Store<FavoritesState, FavoritesAction> {
	
	var select: Binder<Int> {
		Binder(self.base) { store, value in
			store.send(FavoritesAction.selectAt(value))
		}
	}
}
