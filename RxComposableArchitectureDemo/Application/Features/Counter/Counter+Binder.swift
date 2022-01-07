//
//  CounterView+Binder.swift
//  RxComposableArchitectureDemo
//
//  Created by Jean Raphael Bordet on 24/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxComposableArchitecture

public extension Reactive where Base: Store<CounterState, CounterAction> {
	
//	var incr: Binder<Void> {
//		Binder(self.base) { store, value in
//			store.send(CounterAction.incrTapped)
//		}
//	}
//	
//	var decr: Binder<Void> {
//		Binder(self.base) { store, value in
//			store.send(CounterAction.decrTapped)
//		}
//	}
//	
//	var add: Binder<Void> {
//		Binder(self.base) { store, value in
//			store.send(CounterAction.addFavorite)
//		}
//	}
//	
//	var remove: Binder<Void> {
//		Binder(self.base) { store, value in
//			store.send(CounterAction.removeFavorite)
//		}
//	}
//	
//	var isPrime: Binder<Void> {
//		Binder(self.base) { store, value in
//			store.send(CounterAction.isPrime)
//		}
//	}
//	
//	// true: remove
//	// false: add
//	var addRemove: Binder<Bool> {
//		Binder(self.base) { store, value in
//			if value {
//				store.send(CounterAction.removeFavorite)
//			} else {
//				store.send(CounterAction.addFavorite)
//			}
//		}
//	}
}
