//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by Jean Raphael Bordet on 19/03/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol StoreViewController {
	associatedtype Value
	associatedtype Action
	
	var store: Store<Value, Action>? { get set }
}

extension StoreViewController {
	public func apply(block: @escaping(Self) -> Void) -> Self {
		block(self)
		return self
	}
}

public typealias Effect<A> = Observable<A>

public typealias Reducer<Value, Action, Environment> = (inout Value, Action, Environment) -> [Effect<Action>]

public final class Store<Value, Action> {
	private let reducer: Reducer<Value, Action, Any>
	
	public private(set) var value: BehaviorRelay<Value>
	
	private let environment: Any
	
	private let disposeBag = DisposeBag()
	
	public init<Environment>(
		initialValue: Value,
		reducer: @escaping Reducer<Value, Action, Environment>,
		environment: Environment
	) {
		self.reducer = { value, action, environment in
			reducer(&value, action, environment as! Environment)
		}
		
		self.value = BehaviorRelay<Value>(value: initialValue)
		
		self.environment = environment
	}
	
	public func send(_ action: Action, error: Error? = nil) {
		var valueCopy = self.value.value
		let effects = self.reducer(&valueCopy, action, self.environment)
		
		self.value.accept(valueCopy)
		
		effects.forEach { effect in
			effect.subscribe { [weak self] action in
				self?.send(action)
			}
			.disposed(by: disposeBag)
			
		}
	}
	
	public func view<LocalValue, LocalAction>(
		value toLocalValue: @escaping (Value) -> LocalValue,
		action toGlobalAction: @escaping (LocalAction) -> Action
	) -> Store<LocalValue, LocalAction> {
		let localStore = Store<LocalValue, LocalAction>(
			initialValue: toLocalValue(self.value.value),
			reducer: { localValue, localAction, _ in
				self.send(toGlobalAction(localAction))
				localValue = toLocalValue(self.value.value)
				return []
			}, environment: self.environment)
		
		value.subscribe(onNext: { (newValue: Value) in
			localStore.value.accept(toLocalValue(newValue))
		}).disposed(by: localStore.disposeBag)
		
		return localStore
	}
}

public func combine<Value, Action, Environment>(
	_ reducers: Reducer<Value, Action, Environment>...
) -> Reducer<Value, Action, Environment> {
	{ value, action, environment in
		let effects = reducers.flatMap {
			$0(&value, action, environment)
		}
		
		return effects
	}
}

/**

Then inside here we have access to a global value and a reducer that works on local values.
So, we can use the key path to extract the local value from the global value,
run the reducer on that local value, and then plug that local value back into the global value:

*/

//public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, LocalEnvironment, GlobalEnvironment>(
//    _ reducer: @escaping Reducer<LocalValue, LocalAction, LocalEnvironment>,
//    value: WritableKeyPath<GlobalValue, LocalValue>,
//    action: WritableKeyPath<GlobalAction, LocalAction?>,
//    environment: @escaping (GlobalEnvironment) -> LocalEnvironment
//) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
//    return { globalValue, globalAction, globalEnvironment in
//        guard let localAction = globalAction[keyPath: action] else {
//            return []
//        }
//        //  var localValue = globalValue[keyPath: value]
//        //  reducer(&localValue, action)
//        //  globalValue[keyPath: value] = localValue
//        
//        // WritableKeyPath<GlobalValue, LocalValue>
//        // \User.id as WritableKeyPath<User, Int>
//        
//        // That one line is simultaneously getting the local value, mutating it, and plugging it back into the global value.
//        let localEffects = reducer(&globalValue[keyPath: value], localAction, environment(globalEnvironment))
//        
//        return localEffects.map { localEffect in
//            localEffect.map { localAction -> GlobalAction in
//                var globalAction = globalAction
//                globalAction[keyPath: action] = localAction
//                return globalAction
//            }
//        }
//    }
//}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, LocalEnvironment, GlobalEnvironment>(
	_ reducer: @escaping Reducer<LocalValue, LocalAction, LocalEnvironment>,
	value: WritableKeyPath<GlobalValue, LocalValue>,
	action: CasePath<GlobalAction, LocalAction>,
	environment: @escaping (GlobalEnvironment) -> LocalEnvironment
) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
	{ globalValue, globalAction, globalEnvironment in
		guard let localAction = action.extract(globalAction) else {
			return []
		}
		
		// That one line is simultaneously getting the local value, mutating it, and plugging it back into the global value.
		let localEffects = reducer(
			&globalValue[keyPath: value],
			localAction,
			environment(globalEnvironment)
		)
		
		return localEffects.map { $0.map(action.embed) }
	}
}

public func logging<Value, Action, Environment>(
	_ reducer: @escaping Reducer<Value, Action, Environment>
) -> Reducer<Value, Action, Environment> {
	return { value, action, environment in
		let effects = reducer(&value, action, environment)
		let _value = value
		return [.fireAndForget {
			
			dump("Action: \(action)")
			
			let mirror = Mirror(reflecting: _value)
			
			let sValue = mirror.children.map { $0.label }.compactMap { $0 }
			
			print(sValue)
			
			print("---")
		}] + effects
	}
}
