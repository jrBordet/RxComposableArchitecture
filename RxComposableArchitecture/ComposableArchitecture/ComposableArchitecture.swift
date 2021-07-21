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

public struct Reducer<State, Action, Environment> {
	let reducer: (inout State, Action, Environment) -> [Effect<Action>]
	
	public init(
		_ reducer: @escaping (inout State, Action, Environment) -> [Effect<Action>]
	) {
		self.reducer = reducer
	}
}

extension Reducer where Environment == Void {
	init(_ reducer: @escaping (inout State, Action) -> Void) {
		self.reducer = { state, action, _ in
			reducer(&state, action)
			return []
		}
	}
}

/// Transforms a reducer that works on non-optional state into one that works on optional state by
/// only running the non-optional reducer when state is non-nil.
///
/// Often used in tandem with `pullback` to transform a reducer on a non-optional local domain
/// into a reducer on a global domain that contains an optional local domain:
///
///     // Global domain that holds an optional local domain:
///     struct AppState { var modal: ModalState? }
///     struct AppAction { case modal(ModalAction) }
///     struct AppEnvironment { var mainQueue: AnySchedulerOf<DispatchQueue> }
///
///     // A reducer that works on the non-optional local domain:
///     let modalReducer = Reducer<ModalState, ModalAction, ModalEnvironment { ... }
///
///     // Pullback the local modal reducer so that it works on all of the app domain:
///     let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
///       modalReducer.optional.pullback(
///         state: \.modal,
///         action: /AppAction.modal,
///         environment: { ModalEnvironment(mainQueue: $0.mainQueue) }
///       )
///
/// - See also: `IfLetStore`, a SwiftUI helper for transforming a store on optional state into a
///   store on non-optional state.
/// - See also: `Store.ifLet`, a UIKit helper for doing imperative work with a store on optional
///   state.s
extension Reducer {
	public var optional: Reducer<State?, Action, Environment> {
		.init { value, action, environment in
			guard value != nil else {
				return []
			}
			
			return self(&value!, action, environment)
		}
	}
}

//extension Reducer {
//	func optional() -> Reducer<State?, Action, Environment> {
//		.init { state, action, environment in
//			guard var wrappedState = state
//			else { return .none }
//			defer { state = wrappedState }
//			return self.run(&wrappedState, action, environment)
//		}
//	}
//}

extension Reducer {
	public func callAsFunction(
		_ value: inout State,
		_ action: Action,
		_ environment: Environment
	) -> [Effect<Action>] {
		self.reducer(&value, action, environment)
	}
}

public final class Store<State, Action> {
	private let reducer: Reducer<State, Action, Any>
	
	public private(set) var state: BehaviorRelay<State>
	
	private let environment: Any
	
	private let send = PublishSubject<Action>()
	
	private let disposeBag = DisposeBag()
	
	public init<Environment>(
		initialValue: State,
		reducer: Reducer<State, Action, Environment>,
		environment: Environment
	) {
		/**
		
		In the body of the initializer we wrap the given reducer with a new one in order to “erase” its environment,
		something we motivated back in our episodes on modular dependency management.
		This wrapper needs to invoke Reducer’s initializer, as well:

		[Modular State Management: Reducers](https://www.pointfree.co/collections/composable-architecture/modularity/ep72-modular-state-management-reducers)
		*/
		self.reducer = Reducer { value, action, environment in
			reducer(&value, action, environment as! Environment)
		}
				
		self.state = BehaviorRelay<State>(value: initialValue)
		
		self.environment = environment
	}
	
	public func send(_ action: Action) {
		var valueCopy = self.state.value
		
		let effects = self.reducer(&valueCopy, action, self.environment)
		
		self.state.accept(valueCopy)
		
		effects.forEach {
			$0.bind(to: send)
				.disposed(by: disposeBag)
		}
		
//		effects.forEach { effect in
//			effect
//				.bind(to: sendAction)
//				.disposed(by: disposeBag)
//
////			effect.subscribe(onNext: {  [weak self] action in
////				self?.send(action)
////			}) { error in
////
////			} onCompleted: {
////
////			}
////			.disposed(by: disposeBag)
//		}
	}
	
	public func scope<LocalState, LocalAction>(
		value toLocalValue: @escaping (State) -> LocalState,
		action toGlobalAction: @escaping (LocalAction) -> Action
	) -> Store<LocalState, LocalAction> {
		var isSending = false
		
		let localStore = Store<LocalState, LocalAction>(
			initialValue: toLocalValue(self.state.value),
			reducer: .init { [weak self] localValue, localAction, _ in
				guard let self = self else {
					return []
				}
				
				isSending = true
				 defer { isSending = false }
				
				self.send(toGlobalAction(localAction))
				
				localValue = toLocalValue(self.state.value)
				
				return []
			}, environment: self.environment
		)
		
		state
			.map { toLocalValue($0) }
			.filter { _ in isSending }
			.skip(1) // TODO: check this [](https://www.pointfree.co/episodes/ep151-composable-architecture-performance-view-stores-and-scoping#t824)
			.bind(to: localStore.state)
			.disposed(by: localStore.disposeBag)
		
		return localStore
	}
}

extension Reducer {
	public static func combine(
		_ reducers: Reducer...
	) -> Reducer {
		return Reducer { value, action, environment in
			//		let effects = reducers.flatMap {
			//			$0.reducer(&value, action, environment)
			//		}
			
			let effects = reducers.flatMap { $0(&value, action, environment) }
			
			return effects
		}
	}
}

extension Reducer {
	public func pullback<GlobalValue, GlobalAction, GlobalEnvironment>(
		value: WritableKeyPath<GlobalValue, State>,
		action: CasePath<GlobalAction, Action>,
		environment: @escaping (GlobalEnvironment) -> Environment
	) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
		return .init { globalValue, globalAction, globalEnvironment in
			guard let localAction = action.extract(globalAction) else {
				return []
			}
			
			/// That one line is simultaneously getting the local value, mutating it,
			/// and plugging it back into the global value.
			let localEffects = self(
				&globalValue[keyPath: value],
				localAction,
				environment(globalEnvironment)
			)
			
			return localEffects.map { $0.map(action.embed) }
		}
	}
}

extension Reducer {
	public func debug(
		_ prefix: String = ""
	) -> Reducer {
		#if DEBUG
		return .init { value, action, environment in
			let effects = self(&value, action, environment)
			let _value = value
			return [.fireAndForget {
				
				dump("\(prefix) Action: \(action)")
				
				let mirror = Mirror(reflecting: _value)
				
				let sValue = mirror.children.map { $0.label }.compactMap { $0 }
				
				print("\(prefix) \(sValue)")
				
				print("---")
			}] + effects
		}
		#else
		return self
		#endif
	}
}

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

/**

Then inside here we have access to a global value and a reducer that works on local values.
So, we can use the key path to extract the local value from the global value,
run the reducer on that local value, and then plug that local value back into the global value:

*/
public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, LocalEnvironment, GlobalEnvironment>(
	_ reducer: Reducer<LocalValue, LocalAction, LocalEnvironment>,
	value: WritableKeyPath<GlobalValue, LocalValue>,
	action: CasePath<GlobalAction, LocalAction>,
	environment: @escaping (GlobalEnvironment) -> LocalEnvironment
) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
	return .init { globalValue, globalAction, globalEnvironment in
		guard let localAction = action.extract(globalAction) else {
			return []
		}
		
		/// That one line is simultaneously getting the local value, mutating it,
		/// and plugging it back into the global value.
		let localEffects = reducer(
			&globalValue[keyPath: value],
			localAction,
			environment(globalEnvironment)
		)
		
		return localEffects.map { $0.map(action.embed) }
	}
}

public func logging<Value, Action, Environment>(
	_ reducer:  Reducer<Value, Action, Environment>
) -> Reducer<Value, Action, Environment> {
	return .init { value, action, environment in
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
