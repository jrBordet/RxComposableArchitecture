//
//  CasePathTests.swift
//  RxComposableArchitectureDemoTests
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import XCTest
@testable import RxComposableArchitectureDemo
import Difference
import RxComposableArchitecture

enum Example {
    case foo(Int)
    case bar(Int)
    
    var foo: Int? {
        get {
            guard case let Example.foo(value) = self else {
                return nil
            }
            
            return value
        }
        
        set {
            guard
                case Example.foo = self,
                let newValue = newValue else {
                    return
            }
            
            self = Example.foo(newValue)
        }
    }
}

enum LoadState<A> {
    case loading
    case offline
    case loaded(Result<A, Error>)
}

class CasePathTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_mirroring() throws {
        let auth = Authentication.authenticated(AccessToken(token: "deadbeef"))
        
        let mirror = Mirror(reflecting: auth)
        
        XCTAssertEqual(mirror.children.count, 1)
        
        dump(mirror.children.first!)
        
        let accessToken = mirror.children.first!.value as? AccessToken
        
        XCTAssertEqual(accessToken!, AccessToken(token: "deadbeef"))
    }
    
    func test_extract() {
//        let auth = Authentication.authenticated(AccessToken(token: "deadbeef"))
//        
//        let result = extract(case: "authenticated", auth) as AccessToken?
//        
//        XCTAssertEqual(result, AccessToken(token: "deadbeef"))
    }
    
//    func test_extact_help() {
//        let auth = Authentication.authenticated(AccessToken(token: "deadbeef"))
//
//        let accessToken = extractHelp(case: Authentication.authenticated, from: auth) // AccessToken
//        XCTAssertEqual(accessToken, AccessToken(token: "deadbeef"))
//
//        extractHelp(case: Authentication.authenticated, from: .unauthenticated) // nil
//
//        extractHelp(case: Result<Int, Error>.success, from: .success(42)) // 42
//
//        struct MyError: Error {}
//
//        extractHelp(case: Result<Int, Error>.failure, from: .failure(MyError())) // MyError
//
//        extractHelp(case: Example.foo, from: .foo(2)) // 2
//        extractHelp(case: Example.bar, from: .foo(2)) // nil
//    }
//
//    func test_casePath_init() {
//        let foo = CasePath(Example.foo)
//        let bar = CasePath(Example.bar)
//        let authenticated = CasePath(Authentication.authenticated)
//
//        XCTAssertEqual(foo.extract(.foo(5)), 5)
//        XCTAssertEqual(bar.extract(.bar(42)), 42)
//
//        let ten = foo.embed(10)
//        XCTAssertEqual(foo.extract(ten), 10)
//
//        let example = Example.foo(10)
//
//        // Ergonomics
//        XCTAssertEqual(CasePath(Example.foo).extract(example), 10)
//
//        // Classic
//        switch example {
//        case let .foo(result):
//            XCTAssertEqual(result, 10)
//            break
//        case .bar(_):
//            break
//        }
//
//        enum ExampleWithArgumentLabels {
//            case foo(value: Int)
//        }
//
//        //        extractHelp(case: ExampleWithArgumentLabels.foo, from: .foo(value: 2)) // nil
//        //        extractHelp(case: Authentication.unauthenticated, from: .unauthenticated)
//
//        //        let countryCasePath = CasePath<Location, String>(
//        //          { country in Location(city: "Brooklyn", country: country) }
//        //        )
//
//        CasePath(DispatchTimeInterval.seconds)
//        CasePath(DispatchTimeInterval.milliseconds)
//        CasePath(DispatchTimeInterval.microseconds)
//        CasePath(DispatchTimeInterval.nanoseconds)
//
//        _ = /DispatchTimeInterval.seconds
//
//        let prova = ^(/DispatchTimeInterval.seconds)
//        _ = prova(.seconds(10))
//
//        _ = (^(/DispatchTimeInterval.seconds))(.seconds(10))
//
//        //        let seconds = CasePath(DispatchTimeInterval.seconds).embed(10)
//        //
//        //        let result = CasePath(DispatchTimeInterval.seconds).extract(.seconds(100))
//    }
//
//    func test_composition() {
//        let success = /Result<DispatchTimeInterval, Error>.success .. /DispatchTimeInterval.seconds
//
//        _ = (/Result<DispatchTimeInterval, Error>.success .. /DispatchTimeInterval.seconds).embed(200)
//
//        let ten = success.embed(10)
//
//        let seconds = success.extract(ten)
//        XCTAssertEqual(seconds, 10)
//    }
    
//    func test_load_state() {
//        //        With case paths we can easily express the idea of wanting to focus in on the success case of the result in the loaded case of this enum:
//        
//        let loadSuccess = /LoadState<Int>.loaded .. /Result.success
//        loadSuccess.embed(2)
//        
//        let states1: [LoadState<Int>] = [
//            .loaded(.success(2)),
//            .loaded(.failure(NSError(domain: "", code: 1, userInfo: [:]))),
//            .loaded(.success(3)),
//            .loading,
//            .loaded(.success(4)),
//            .offline,
//        ]
//        
//        states1.compactMap(^(/LoadState.loaded .. /Result.success))
//        
//        dump(states1)
//        
//        let states2: [LoadState<Authentication>] = [
//            .loading,
//            .loaded(.success(.authenticated(AccessToken(token: "deadbeef")))),
//            .loaded(.failure(NSError(domain: "", code: 1, userInfo: [:]))),
//            .loaded(.success(.authenticated(AccessToken(token: "cafed00d")))),
//            .loaded(.success(.unauthenticated)),
//            .offline
//        ]
//        
//        states2
//          .compactMap(^(/LoadState.loaded .. /Result.success .. /Authentication.authenticated))
//        // [{token "deadbeef"}, {token "cafed00d"}]
//        
//    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
