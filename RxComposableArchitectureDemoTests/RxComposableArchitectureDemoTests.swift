//
//  RxComposableArchitectureDemoTests.swift
//  RxComposableArchitectureDemoTests
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import XCTest
@testable import RxComposableArchitectureDemo
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa

class RxComposableArchitectureDemoTests: XCTestCase {
//    var initialState: CounterViewState! = CounterViewState(count: 0, isLoading: false, alertNthPrime: nil)
//    
//    let env: CounterViewEnvironment = (
//        counter: { _ in .sync { 5 } },
//        other: { .sync { true } }
//    )
//    
//    override func setUp() {
//        initialState = CounterViewState(count: 0, isLoading: false, alertNthPrime: nil)
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//    
//    func test_counter_incr() {
//        assert(
//            initialValue: initialState,
//            reducer: counterViewReducer,
//            environment: env,
//            steps:
//            Step(.send, .counter(.incrTapped), { state in
//                state.count = 1
//            }),
//            Step(.send, .counter(.incrTapped), { state in
//                state.count = 2
//            })
//        )
//    }
//    
//    func test_counter_decr() {
//        assert(
//            initialValue: initialState,
//            reducer: counterViewReducer,
//            environment: env,
//            steps: Step(.send, .counter(.decrTapped), { state in
//                state.count = -1
//            })
//        )
//    }
//    
//    func test_counter_nthPrimeTapped() {
//        assert(
//            initialValue: initialState,
//            reducer: counterViewReducer,
//            environment: env,
//            steps:
//            Step(.send, .counter(.nthPrimeButtonTapped), { state in
//            
//            }),
//            Step(.receive, .counter(.nthPrimeResponse(5)), { state in
//                state.alertNthPrime = PrimeAlert(prime: 5)
//            })
//        )
//    }
}
