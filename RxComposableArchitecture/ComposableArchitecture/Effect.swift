//
//  Effect.swift
//  ComposableArchitecture
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import RxSwift

public struct SideEffect<Output>: ObservableType {
	public typealias Element = Output
	
	public let upstream: Observable<Output>
	
	public init(_ observable: Observable<Output>) {
	  self.upstream = observable
	}

	public func subscribe<Observer>(
		_ observer: Observer
	) -> Disposable where Observer : ObserverType, Element == Observer.Element {
		upstream.subscribe(observer)
	}
	
}

extension SideEffect {
	static func just(value: Output) -> SideEffect {
		.init(Observable.just(value))
	}
	
	public static var none: SideEffect {
		Observable.empty().eraseToEffect()
	}
}

extension ObservableType {
  /// Turns any publisher into an `Effect`.
  ///
  /// This can be useful for when you perform a chain of publisher transformations in a reducer, and
  /// you need to convert that publisher to an effect so that you can return it from the reducer:
  ///
  ///     case .buttonTapped:
  ///       return fetchUser(id: 1)
  ///         .filter(\.isAdmin)
  ///         .eraseToEffect()
  ///
  /// - Returns: An effect that wraps `self`.
  public func eraseToEffect() -> SideEffect<Element> {
	  SideEffect(asObservable())
  }

  /// Turns any publisher into an `Effect` that cannot fail by wrapping its output and failure in a
  /// result.
  ///
  /// This can be useful when you are working with a failing API but want to deliver its data to an
  /// action that handles both success and failure.
  ///
  ///     case .buttonTapped:
  ///       return fetchUser(id: 1)
  ///         .catchToEffect()
  ///         .map(ProfileAction.userResponse)
  ///
  /// - Returns: An effect that wraps `self`.
  public func catchToEffect() -> SideEffect<Result<Element, Error>> {
	self.map(Result<Element, Error>.success)
	  .catchError { Observable<Result<Element, Error>>.just(Result.failure($0)) }
	  .eraseToEffect()
  }
}

public enum EffectError: Error {
    case generic
    case custom(String)
}

extension EffectError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generic:
            return NSLocalizedString("something goes wrong", comment: "")
        case let .custom(title):
            return NSLocalizedString(title, comment: "")
        }
    }
}

extension Effect {
    public static func fireAndForget(work: @escaping () -> Void) -> Effect {
        create { observer -> Disposable in
            
            work()
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public static func sync(work: @escaping () -> Element ) -> Effect {
        create { observer in
        
            observer.onNext(work())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public static func error(title: String) -> Effect {
        create { observer -> Disposable in
            
            observer.onError(EffectError.custom(title))

            return Disposables.create()
        }
    }
}
