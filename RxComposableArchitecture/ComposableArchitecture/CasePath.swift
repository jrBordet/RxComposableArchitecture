//
//  CasePath.swift
//  RxComposableArchitecture
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation

/**
 The name “key path” most likely comes from naming used in Objective-C and so-called “key-value observation”, also known as KVO.
 In KVO a key path is a string that navigates to some data inside a structure,
 which can look like this in practice:
 
 [user valueForKeyPath:@"location.city"]
 */


struct _WritableKeyPath<Root, Value> {
    let get: (Root) -> Value
    let set: (inout Root, Value) -> Void
}

/**
 
 This extract function is the enum version of the get function for structs. It allows us to get at the data on the inside of the enum, it just doesn’t always succeed in doing that.
 
 The other fundamental operation that properties on structs have is the ability to mutate the whole of the struct by setting a property. With enums we can do something similar, but we instead can take an associated value of one of the cases, and embed it into the root enum
 
 */

public struct CasePath<Root, Value> {
    public let extract: (Root) -> Value?
    public let embed: (Value) -> Root
    
    public init(
        extract: @escaping (Root) -> Value?,
        embed: @escaping (Value) -> Root
    ) {
        self.extract = extract
        self.embed = embed
    }
}

extension CasePath {
    public init(_ case: @escaping (Value) -> Root) {
        self.embed = `case`
        self.extract = { root in
            extractHelp(case: `case`, from: root)
        }
    }
}

extension CasePath where Root == Value {
    public static var `self`: CasePath {
        CasePath(
            extract: { .some($0) },
            embed: { $0 }
        )
    }
}

extension CasePath {
    public func appending<AppendedValue>(
        path: CasePath<Value, AppendedValue>
    ) -> CasePath<Root, AppendedValue> {
        CasePath<Root, AppendedValue>(
            extract: { root in
                self.extract(root).flatMap(path.extract)
        },
            embed: { appendedValue in
                self.embed(path.embed(appendedValue))
        })
    }
}

precedencegroup Composition {
    associativity: right
}

infix operator ..: Composition

public func .. <A, B, C> (
    lhs: CasePath<A, B>,
    rhs: CasePath<B, C>
) -> CasePath<A, C> {
    lhs.appending(path: rhs)
}

prefix operator ^

public prefix func ^ <Root, Value>(
    path: CasePath<Root, Value>
) -> (Root) -> Value? {
    return path.extract
}

prefix operator /

public prefix func / <Root, Value>(
    case: @escaping (Value) -> Root
) -> CasePath<Root, Value> {
    return CasePath(`case`)
}

//public func extract<Root, Value>(from root: Root) -> Value? {
//    let mirror = Mirror.init(reflecting: root)
//
//    guard let child = mirror.children.first else {
//        return nil
//    }
//
//    return child.value as? Value
//}

public func extract<Root, Value>(case: String, from root: Root) -> Value? {
    let mirror = Mirror(reflecting: root)
    
    guard let child = mirror.children.first else {
        return nil
    }
    
    guard `case` == child.label else {
        return nil
    }
    
    return child.value as? Value
}

public func extractHelp<Root, Value>(
    case: @escaping (Value) -> Root,
    from root: Root
) -> Value? {
    let mirror = Mirror(reflecting: root)
    
    guard let child = mirror.children.first else {
        return nil
    }
    
    guard let value = child.value as? Value else {
        return nil
    }
    
    let newRoot = `case`(value)
    let newMirror = Mirror(reflecting: newRoot)
    
    guard let newChild = newMirror.children.first else {
        return nil
    }
    
    guard newChild.label == child.label else {
        return nil
    }
    
    return value
}

//let successCasePath: CasePath<Result<Success, Failure>, Success>

extension Result {
    
    public static var successCasePath: CasePath<Result, Success> {
        CasePath<Result, Success>(
            extract: { result in
                if case let .success(success) = result {
                    return success
                }
                return nil
        },
            embed: Result.success
        )
    }
    
    public static var failureCasePath: CasePath<Result, Failure> {
        CasePath<Result, Failure>(
            extract: { result in
                if case let .failure(failure) = result {
                    return failure
                }
                return nil
        },
            embed: Result.failure
        )
    }
}


