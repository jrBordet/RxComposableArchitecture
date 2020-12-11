//
//  Effect.swift
//  ComposableArchitecture
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import RxSwift

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
