//
//  Utils.swift
//  ComposableArchitecture
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation

public func compose<A, B, C>(
    _ f: @escaping (B) -> C,
    _ g: @escaping (A) -> B
) -> (A) -> C {
    return { (a: A) -> C in
        f(g(a))
    }
}

public func with<A, B>(_ a: A, _ f: (A) throws -> B) rethrows -> B {
    return try f(a)
}


/**
Lens
- parameter A: a Whole.
- parameter B: a Part.
*/

public struct Lens <A, B> {
	public let get: (A) -> B
	public let set: (B, A) -> A
	
	public init(
		get: @escaping (A) -> B,
		set: @escaping (B, A) -> A
	) {
		self.get = get
		self.set = set
	}
}

public struct LensLaw {
	public static func setGet<A, B>(
		_ lens: Lens<A, B>,
		_ whole: A,
		_ part: B
	) -> Bool where B: Equatable {
		lens.get(lens.set(part, whole)) == part
	}
}

extension Lens {
	public func then<C>(_ other: Lens<B, C>) -> Lens<A, C> {
		Lens<A, C> (
			get: { a -> C in
				other.get(self.get(a))
			},
			set: { (c, a) -> A in
				self.set(other.set(c, self.get(a)), a)
			}
		)
	}
	
	public func over(
		_ f: @escaping(B) -> B
	) -> (A) -> A {
		return { a in
			self.set(f(self.get(a)), a)
		}
	}
	
	public static func zip<B1, B2>(
		_ p1: Lens<A,B1>,
		_ p2: Lens<A,B2>)
	-> Lens<A, (B1, B2)> {
		return Lens<A, (B1, B2)>(
			get: { whole in
				(p1.get(whole), p2.get(whole))
			},
			set: { (part: (B1, B2), whole: A)  in
				p2.set(part.1, p1.set(part.0, whole))
			}
		)
	}

}
